defmodule Colorful.Mixfile do
  use Mix.Project

  def project do
    [app: :colorful,
     version: "0.6.0",
     elixir: ">= 1.0.0",
     description: "Modules which manage colors",
     deps: [
       {:earmark, "~> 0.1", only: :dev},
       {:ex_doc,  "~> 0.7", only: :dev}
     ],
     package: package
   ]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger]]
  end

  defp package do
    [
      files: ["lib", "priv", "mix.exs", "README.md", "LICENSE.txt"],
      contributors: ["Joe Honzawa"],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/Joe-noh/colorful"}
    ]
  end
end
