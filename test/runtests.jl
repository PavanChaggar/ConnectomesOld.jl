using Connectomes
using Test


@testset "Connectomes.jl" begin
    connectome_path = "/"*relpath((@__FILE__)*"/../..","/") * "/assets/connectomes/hcp-scale1-standard-master.graphml"

    connectome = Connectome(connectome_path)

    @test typeof(connectome) == Connectome
end
