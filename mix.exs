defmodule Colorful.Mixfile do
  use Mix.Project

  def project do
    [app: :colorful,
     version: "0.4.1",
     elixir: ">= 1.0.0",
     description: "Wrapper for IO.ANSI modules",
     deps: [],
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
      files: ["lib", "mix.exs", "README.md", "LICENSE.txt"],
      contributors: ["Joe Honzawa"],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/Joe-noh/colorful"}
    ]
  end
end
