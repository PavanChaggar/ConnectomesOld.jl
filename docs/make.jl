using Documenter, Connectomes

makedocs(
	sitename="Connectomes.jl",
	modules = [Connectomes],
	pages = [
	"Home" => "index.md",
	"Connectomes" => "connectomes.md"]
)
