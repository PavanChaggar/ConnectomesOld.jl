using LightXML
using Connectomes
using DataFrames
using CSV
using Test

@testset "xml" begin
    assetpath = "/"*relpath((@__FILE__)*"/../..","/") * "/assets/"
    connectome_path = assetpath * "connectomes/hcp-scale1-standard-master.graphml"
    connectome = cmtkConnectome(connectome_path)
    @test connectome isa Connectome

    test = Connectome(joinpath(assetpath, "connectomes/Connectomes-hcp-scale1.xml"))

    save_connectome(joinpath(@__DIR__, "test.xml"), test)

    retest = Connectome(joinpath(@__DIR__, "test.xml"))

    for fn in fieldnames(Connectome)
        eval( quote display( @test test.$fn == retest.$fn) end)
    end

    rm(joinpath(@__DIR__, "test.xml"))
end