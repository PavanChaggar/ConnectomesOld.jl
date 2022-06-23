const dictpath = "/"*relpath((@__FILE__)*"/../..","/") * "/assets/dicts"

Connectome2FS() = deserialize(dictpath * "/Connectome2FS.jls")
FS2Connectome() = deserialize(dictpath * "/FS2Connectome.jls")
node2FS() = deserialize(dictpath * "/node2FS.jls")

"""
    Connectome(path::String; norm=true)

Main type introduced by Connectomes.jl
"""
struct Connectome
    parc::DataFrame
    graph::SimpleWeightedGraph{Int64, Float64}
    n_matrix::Matrix{Float64}
    l_matrix::Matrix{Float64}
end

function Connectome(graph_path::String; norm=true)
    parc, n_matrix, l_matrix = load_graphml(graph_path)
    sym_n = symmetrise(n_matrix)
    sym_l = symmetrise(l_matrix)
    Graph = SimpleWeightedGraph(replace(sym_n ./ (sym_l).^2, NaN=>0))

    #Graph = SimpleWeightedGraph(symmetrise(n_matrix ./ (l_matrix)^2))
    if norm
        Graph = adjacency_matrix(Graph) |> max_norm |> SimpleWeightedGraph
    end
    return Connectome(parc, Graph, n_matrix, l_matrix)
end

function cmtkConnectome(graph_path::String; norm=true)
    parc, n_matrix, l_matrix = cmtk_load_graphml(graph_path)
    sym_n = symmetrise(n_matrix)
    sym_l = symmetrise(l_matrix)
    Graph = SimpleWeightedGraph(replace(sym_n ./ (sym_l).^2, NaN=>0))

    if norm
        Graph = adjacency_matrix(Graph) |> max_norm |> SimpleWeightedGraph
    end
    Connectome(parc, Graph, n_matrix, l_matrix)
end


function Connectome(parc::DataFrame, c::Connectome)
    Connectome(parc, c.graph, c.n_matrix, c.l_matrix)
end

function Connectome(A::SparseMatrixCSC{Float64, Int64}, c::Connectome)
    G = SimpleWeightedGraph(A)
    Connectome(c.parc, G, c.n_matrix, c.l_matrix)
end

function Base.show(io::IO, c::Connectome)
    print(io, "Parcellation: \n")
    display(c.parc)
    print(io, "Adjacency Matrix: \n") 
    display(adjacency_matrix(c))
end

# convenience functions for processing graphs
function Base.filter(c::Connectome, cutoff::Float64=1e-2)
    A = filter(adjacency_matrix(c), cutoff)
    Connectome(A, c)
end

Base.filter(A::SparseMatrixCSC{Float64, Int64}, cutoff::Float64) = A .* (A .> cutoff)

max_norm(M) = M ./ maximum(M)

degree(C::Connectome) = diag(C.D) |> Array 

function symmetrise(A)
    (A + transpose(A)) / 2
end

adjacency_matrix(c::Connectome) = adjacency_matrix(c.graph)
degree_matrix(c::Connectome) = degree_matrix(c.graph)
laplacian_matrix(c::Connectome) = laplacian_matrix(c.graph)

function get_edge_weight(c::Connectome)
    w = weights(c.graph)
    lt_w = UpperTriangular(w) |> sparse
    lt_w.nzval
end
