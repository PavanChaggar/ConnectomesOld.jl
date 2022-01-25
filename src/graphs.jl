const dictpath = "/"*relpath((@__FILE__)*"/../..","/") * "/assets/dicts"

const Connectome2FS = deserialize(dictpath * "/Connectome2FS.jls")
const FS2Connectome = deserialize(dictpath * "/FS2Connectome.jls")

"""
    Connectome(path::String; norm=true)

Main type introduced by Connectomes.jl
"""
struct Connectome
    parc::DataFrame
    graph::SimpleWeightedGraph{Int64, Float64}
    n_matrix::SparseMatrixCSC{Float64, Int64}
    l_matrix::SparseMatrixCSC{Float64, Int64}
    A::SparseMatrixCSC{Float64, Int64}
    D::SparseMatrixCSC{Float64, Int64}
    L::SparseMatrixCSC{Float64, Int64}
end

function Connectome(graph_path::String; norm=true)
    parc, n_matrix, l_matrix = load_graphml(graph_path)
    
    Graph = SimpleWeightedGraph(replace(symmetrise(n_matrix ./ l_matrix), NaN=>0))
    if norm
        Graph = SimpleWeightedGraphs.adjacency_matrix(Graph) |> max_norm |> SimpleWeightedGraph
    end
    A = SimpleWeightedGraphs.adjacency_matrix(Graph)
    D = SimpleWeightedGraphs.degree_matrix(Graph)
    L = SimpleWeightedGraphs.laplacian_matrix(Graph)
    Connectome(parc, Graph, n_matrix, l_matrix, A, D, L)
end

function cmtkConnectome(graph_path::String; norm=true)
    parc, n_matrix, l_matrix = cmtk_load_graphml(graph_path)
    
    Graph = SimpleWeightedGraph(replace(symmetrise(n_matrix ./ l_matrix), NaN=>0))
    if norm
        Graph = SimpleWeightedGraphs.adjacency_matrix(Graph) |> max_norm |> SimpleWeightedGraph
    end
    A = SimpleWeightedGraphs.adjacency_matrix(Graph)
    D = SimpleWeightedGraphs.degree_matrix(Graph)
    L = SimpleWeightedGraphs.laplacian_matrix(Graph)
    Connectome(parc, Graph, n_matrix, l_matrix, A, D, L)
end


function Connectome(parc::DataFrame, c::Connectome)
    Connectome(parc, c.graph, c.n_matrix, c.l_matrix, c.A, c.D, c.L)
end

function Connectome(A::SparseMatrixCSC{Float64, Int64}, c::Connectome)
    G = SimpleWeightedGraph(A)
    A = SimpleWeightedGraphs.adjacency_matrix(G)
    D = SimpleWeightedGraphs.degree_matrix(G)
    L = SimpleWeightedGraphs.laplacian_matrix(G)
    empty_matrix = spzeros(size(c.A)...)
    Connectome(c.parc, G, empty_matrix, empty_matrix, A, D, L)
end

function Base.show(io::IO, c::Connectome)
    print(io, "Parcellation: \n")
    display(c.parc)
    print(io, "Adjacency Matrix: \n") 
    display(c.A)
end

# convenience functions for processing graphs
function Base.filter(c::Connectome, cutoff::Float64=1e-2)
    A = filter(c.A, cutoff)
    Connectome(A, c)
end

Base.filter(A::SparseMatrixCSC{Float64, Int64}, cutoff::Float64=1e-2) = A .* (A .> cutoff)

max_norm(M) = M ./ maximum(M)

degree(C::Connectome) = diag(C.D) |> Array 

function symmetrise(A::SparseMatrixCSC{Float64, Int64})
    A + transpose(A)
end