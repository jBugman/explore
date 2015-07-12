defmodule Process.Mixfile do
  use Mix.Project

  def project do
    [app: :process,
     version: "0.0.1",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     escript: [main_module: Process.CLI],
     deps: deps]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do [
      {:poison, "~> 1.3"},
      {:csv, "~> 1.0.0"}
    ]
  end
end
