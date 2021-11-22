const dictpath = "/"*relpath((@__FILE__)*"/../..","/") * "/assets/dicts"

const Connectome2FS = deserialize(dictpath * "/Connectome2FS.jls")
const FS2Connectome = deserialize(dictpath * "/FS2Connectome.jls")

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

    return SimpleWeightedGraph((A + transpose(A))*0.5)
end

function read_cmtk_parcellation(graph_path)
    xdoc = parse_file(graph_path)
    xroot = root(xdoc)
    ces = collect(child_elements(xroot))
    graph = ces[end]
    
    n_nodes = length(graph["node"])
    nID = Vector{Int}(undef, n_nodes)
    region = Vector{String}(undef, n_nodes)
    labels = Vector{String}(undef, n_nodes)
    hemisphere = Vector{String}(undef, n_nodes)

    for i ∈ 1:n_nodes
        for j ∈ child_elements(graph["node"][i])
            if attribute(j, "key") == "d0"
                region[i] = LightXML.content(j)
            elseif attribute(j, "key") == "d1"
                labels[i] = LightXML.content(j)
            elseif attribute(j, "key") == "d2"
                hemisphere[i] = LightXML.content(j)
            elseif attribute(j, "key") == "d3"
                nID[i] = parse(Int, LightXML.content(j))
            end
        end
    end
    return DataFrame(ID=nID, Label=labels, Region=region, Hemisphere=hemisphere)
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
    function Connectome(graph_path::String; norm=true)
        parc, Graph = load_graphml(graph_path)
        if norm
            Graph = SimpleWeightedGraphs.adjacency_matrix(Graph) |> max_norm |> SimpleWeightedGraph
        end
        A = SimpleWeightedGraphs.adjacency_matrix(Graph)
        D = degree_matrix(Graph)
        L = SimpleWeightedGraphs.laplacian_matrix(Graph)
        new(parc, Graph, A, D, L)
    end

    function Connectome(parc, A)
        Graph = SimpleWeightedGraph(A)
        new(parc, Graph, SimpleWeightedGraphs.adjacency_matrix(Graph), degree_matrix(Graph), laplacian_matrix(Graph))
    end

    function Connectome(parc, coords, A)
        for (i, j) in enumerate([:x, :y, :z])
            parc[!, j] = coords[:,i]
        end
        Connectome(parc, A)
    end
end

# convenience functions for processing graphs
function graph_filter(connectome::Connectome, cutoff::Float64=1e-2)
    A = graph_filter(connectome.A, cutoff)
    Connectome(connectome.parc, A)
end

graph_filter(A, cutoff=1e-2) = A .* (A .> cutoff)

max_norm(M) = M ./ maximum(M)

function degree(C::Connectome)
    diag(C.D) |> Array 
end