defmodule Elias.MixProject do
  use Mix.Project

  def project do
    [
      app: :elias,
      version: "0.2.1",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      source_url: "https://github.com/oestrich/elias",
      docs: [
        main: "readme",
        extras: ["README.md"]
      ]
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
      {:benchee, "~> 1.0", only: :dev},
      {:credo, "~> 1.2", only: [:dev, :test], runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp description() do
    """
    UCL parser
    """
  end

  defp package() do
    [
      maintainers: ["Eric Oestrich"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/oestrich/elias"
      }
    ]
  end
end
