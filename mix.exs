defmodule PatreonEx.MixProject do
  use Mix.Project

  @source_url "https://github.com/visuelledata/PatreonEx"
  def project do
    [
      app: :patreon_ex,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: "PatreonEx",
      description: "PatreonEx provides functions to access the Patreon V2 API",
      source_url: @source_url,
      package: package(),
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:castore, "~> 0.1.0"},
      {:mint, "~> 1.0"},
      {:jason, "~> 1.3"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
    ]
  end

  defp package do
    [
      licenses: ["Apache-2.0"],
      maintainers: ["Chris Peralta"],
      links: %{
        "GitHub" => @source_url,
        "Patreon API Docs" => "https://docs.patreon.com/"
      }
    ]
  end
end
