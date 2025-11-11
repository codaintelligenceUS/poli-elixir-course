defmodule ElixirBeginnerCourse.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixir_beginner_course,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env()),
      test_paths: ["lib"]
    ]
  end

  def application, do: [extra_applications: [:logger]]

  defp deps do
    [
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.34", only: :dev, runtime: false}
    ]
  end

  defp elixirc_paths(_), do: ["lib"]
end
