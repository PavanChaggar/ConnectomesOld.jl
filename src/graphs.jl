function create_dict(xroot, key, val)
    children = collect(child_elements(xroot))
    dict = Dict{String, String}()
    for i ∈ children[1:end-1]
        k = attribute(i, key)
        v = attribute(i, val)
        dict[k] = v
    end
    return dict
end

function get_node_attributes(graph)
    n_nodes = length(graph["node"])
    coords = Array{Float64}(undef, n_nodes, 3)
    nID = Vector{Int}(undef, n_nodes)
    region = Vector{String}(undef, n_nodes)
    labels = Vector{String}(undef, n_nodes)
    hemisphere = Vector{String}(undef, n_nodes)
    for i ∈ 1:n_nodes
        for j ∈ child_elements(graph["node"][i])
            if attribute(j, "key") == "d0"
                coords[i, 1] = parse(Float64, LightXML.content(j))
            elseif attribute(j, "key") == "d1"
                coords[i, 2] = parse(Float64, LightXML.content(j))
            elseif attribute(j, "key") == "d2"
                coords[i, 3] = parse(Float64, LightXML.content(j))
            elseif attribute(j, "key") == "d3"
                nID[i] = parse(Int, LightXML.content(j))
            elseif attribute(j, "key") == "d4"
                region[i] = LightXML.content(j)
            elseif attribute(j, "key") == "d5"
                labels[i] = LightXML.content(j)
            elseif attribute(j, "key") == "d7"
                hemisphere[i] = LightXML.content(j)
            end
        end
    end
    x, y, z = coords[:,1], coords[:,2], coords[:,3]
    return DataFrame(ID=nID, Label=labels, Region=region, Hemisphere=hemisphere, x=x, y=y, z=z)
end

function get_adjacency_matrix(graph)
    A = spzeros(83,83)
    local n
    local l
    for edge in graph["edge"]
        i = parse(Int, attribute(edge, "source"))
        j = parse(Int, attribute(edge, "target"))
        for child in child_elements(edge)
            if attribute(child, "key") == "d9"
                n = parse(Float64, LightXML.content(child))
            elseif attribute(child, "key") == "d12"
               l = parse(Float64, LightXML.content(child))
            end
        end
        A[i,j] = n / l^2
    end
    Anorm = max_norm(A)

    return SimpleWeightedGraph(Anorm + transpose(Anorm))
end

function load_graphml(graph_path::String)
    xdoc = parse_file(graph_path)
    xroot = root(xdoc)
    ces = collect(child_elements(xroot))

    node_attributes = get_node_attributes(ces[end])
    A = get_adjacency_matrix(ces[end])
    return node_attributes, A
end

struct Connectome
    parc::DataFrame
    graph::SimpleWeightedGraph{Int64, Float64}
    A::SparseMatrixCSC{Float64, Int64}
    D::SparseMatrixCSC{Float64, Int64}
    L::SparseMatrixCSC{Float64, Int64}
    function Connectome(graph_path::String)
        parc, Graph = load_graphml(graph_path)
        A = adjacency_matrix(Graph)
        D = degree_matrix(Graph)
        L = laplacian_matrix(Graph)
        new(parc, Graph, A, D, L)
    end

    function Connectome(parc, A)
        Graph = SimpleWeightedGraph(A)
        new(parc, Graph, adjacency_matrix(Graph), degree_matrix(Graph), laplacian_matrix(Graph))
    end
end

function graph_filter(connectome::Connectome, cutoff::Float64)
    A = graph_filter(connectome.A, cutoff)
    Connectome(connectome.parc, A)
end

graph_filter(A, cutoff) = A .* (A .> cutoff)

max_norm(M) = M ./ maximum(M)