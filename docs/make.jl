using Documenter, Connectomes

makedocs(
	sitename="Connectomes.jl",
	modules = [Connectomes],
	format=Documenter.HTML(), 
	pages = [
	"Home" => "index.md",
	"Connectomes" => "connectomes.md"]
)

deploydocs(;
    repo = "github.com/PavanChaggar/Connectomes.jl.git",
	devbranch="main",
)