const assetpath = pkgdir(Connectomes, "assets")
Connectome2FS() = deserialize(joinpath(assetpath, "dicts/Connectome2FS.jls"))
FS2Connectome() = deserialize(joinpath(assetpath, "dicts/FS2Connectome.jls"))
node2FS() = deserialize(joinpath(assetpath, "dicts/node2FS.jls"))

connectome_path() = joinpath(assetpath, "connectomes/Connectomes-hcp-scale1.xml")
"""
    Connectome(path::String; norm=true)

Main type introduced by Connectomes.jl,

```julia
struct Connectome
    parc::DataFrame
    graph::SimpleWeightedGraph{Int64, Float64}
    n_matrix::Matrix{Float64}
    l_matrix::Matrix{Float64}
end
```
where `parc` is the parcellation atlas, graph is a 
`SimpleWeightedGraph` encoding a weighted Connectome, `n_matrix` is 
the length matrix and `l_matrix` is the length matrix.

# Example

```julia
julia> filter(Connectome(Connectomes.connectomepath()), 1e-2)
Parcellation: 
83×8 DataFrame
 Row │ ID     Label                 Region       Hemisphere  x          y           z            Lobe      
     │ Int64  String                String       String      Float64    Float64     Float64      String    
─────┼─────────────────────────────────────────────────────────────────────────────────────────────────────
   1 │     1  lateralorbitofrontal  cortical     right        25.0057    33.4625    -16.6508     frontal
   2 │     2  parsorbitalis         cortical     right        43.7891    41.4659    -11.8451     frontal
   3 │     3  frontalpole           cortical     right         9.59579   67.3442     -8.94211    frontal
   4 │     4  medialorbitofrontal   cortical     right         5.799     40.7383    -15.7166     frontal
   5 │     5  parstriangularis      cortical     right        48.3993    31.8555      5.60427    frontal
  ⋮  │   ⋮             ⋮                 ⋮           ⋮           ⋮          ⋮            ⋮           ⋮
  80 │    80  Left-Accumbens-area   subcortical  left         -8.14103   11.416      -6.32051    subcortex
  81 │    81  Left-Hippocampus      subcortical  left        -25.5001   -22.6622    -13.6924     temporal
  82 │    82  Left-Amygdala         subcortical  left        -22.7183    -5.11994   -18.8364     temporal
  83 │    83  brainstem             subcortical  none         -6.07796  -31.5015    -32.8539     subcortex
                                                                                            74 rows omitted
Adjacency Matrix: 
83×83 SparseArrays.SparseMatrixCSC{Float64, Int64} with 392 stored entries:
⣮⢛⣣⡠⠀⠀⠀⠀⠀⠀⠀⡁⠀⠀⠠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠉⡺⢺⠒⣒⠄⢀⠀⠀⠀⠀⠄⠀⠀⠀⠀⠂⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠘⠜⠚⣠⣐⡐⠀⠀⣀⡄⠀⠀⠀⠀⠀⠈⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠐⢐⠸⢴⡳⡄⠌⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠂⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⡀⠍⠯⡧⡄⠀⠀⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠄⠠⠀⠄⠀⠼⠁⠀⠀⠉⠯⡣⣄⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠄
⠀⠀⠀⠀⠀⠀⠀⠀⠤⠄⠀⠝⠏⠅⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠁
⠀⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡎⡭⡦⠂⠀⠀⠀⠀⠀⠀⠠⠀⠀⠀
⠀⠀⠈⠠⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠨⠋⡏⡩⡕⠀⠄⠀⠀⠐⠐⠀⠀⠀
⠀⠀⠀⠀⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠑⠉⠡⡦⢥⠁⠀⢰⠶⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠅⠓⢯⣳⣐⠂⠀⠀⢀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⢀⣀⠰⠘⢺⣲⣀⠀⠘⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⠀⠂⠐⠀⠘⠃⠀⠀⠀⠘⢪⣲⣔⡂
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠄⠄⠀⠀⠀⠀⠀⠀⠀⠀⠐⠒⠀⠰⠹⠐⠀
```
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
    A = replace(sym_n ./ (sym_l).^2, NaN=>0)

    #Graph = SimpleWeightedGraph(symmetrise(n_matrix ./ (l_matrix)^2))
    if norm
        Graph = A |> max_norm |> SimpleWeightedGraph
    else
        Graph = SimpleWeightedGraph(A)
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

function slice(c::Connectome, rois::DataFrame; norm=true)
    N = c.n_matrix[rois.ID, rois.ID]
    L = c.l_matrix[rois.ID, rois.ID]
    A = replace(( N ./ L.^2), NaN => 0)
    if norm
        G = A |> max_norm |> SimpleWeightedGraph
    else
        G = SimpleWeightedGraph(A)
    end
    Connectome(rois, G, N, L)
end