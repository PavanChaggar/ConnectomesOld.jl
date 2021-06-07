using CSV

FS = CSV.File("/Users/pavanchaggar/.julia/dev/Connectomes/FSLabels.csv"; delim=",") |> DataFrame

ID = FS[!,:ID]
Labels = FS[!, :Label]

for i in eachindex(Labels)
    Labels[i] = replace(Labels[i], "ctx-" => "")
end
for i in eachindex(Labels)
    Labels[i] = replace(Labels[i], "lh-" => "lh.")
end
for i in eachindex(Labels)
    Labels[i] = replace(Labels[i], "rh-" => "rh.")
end

FSD = Dict(ID .=> Labels)
FSDinv = Dict(Labels .=> ID)

connectome_path = "/"*relpath((@__FILE__)*"/../..","/") * "/assets/connectomes/hcp-scale1-standard-master.graphml"

connectome = Connectome(connectome_path)
connectome.parc[!,:ID]

CD = Dict(connectome.parc[!,:ID] .=> connectome.parc[!,:Label])
CDinv = Dict(connectome.parc[!,:Label] .=> connectome.parc[!,:ID])


C2FS = [FSDinv[CD[i]] for i in 1:83]

Connectome2FS = Dict(connectome.parc[!,:ID] .=> C2FS)