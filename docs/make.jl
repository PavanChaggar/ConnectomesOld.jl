using Documenter, Connectomes

makedocs(
	sitename="Connectomes Docs",
	modules = [Connectomes],
	pages = [
	"Home" => "index.md",
	"Connectomes" => "connectomes.md"]
)
