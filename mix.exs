defmodule Colorful.Mixfile do
  use Mix.Project

  def project do
    [app: :colorful,
     version: "0.3.0",
     elixir: ">= 0.14.3",
     description: "Wrapper for IO.ANSI modules",
     deps: [],
     package: [
       files: ["lib", "mix.exs", "README.md", "LICENSE.txt"],
       contributors: ["Joe Honzawa"],
       licenses: ["MIT"],
       links: [github: "https://github.com/Joe-noh/colorful"]
     ]
   ]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: []]
  end
end
