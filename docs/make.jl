push!(LOAD_PATH,"../src/")
using Documenter, MPCCModels

makedocs(
  modules = [MPCCModels],
  doctest = true,
  linkcheck = true,
  format = Documenter.HTML(
    assets = ["assets/style.css"],
    prettyurls = get(ENV, "CI", nothing) == "true",
    size_threshold_ignore = ["reference.md"],
  ),
  sitename = "MPCCModels.jl",
  pages = [
    "Home" => "index.md",
    "API" => "api.md",
    "Reference" => "reference.md",
  ],
)

deploydocs(
  repo = "github.com/MadNLP/MPCCModels.jl.git",
  push_preview = true,
  devbranch = "master",
)
