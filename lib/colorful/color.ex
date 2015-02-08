defmodule Colorful.Color do
  @moduledoc """
  This module provides information on named colors.

      iex> Colorful.Color.from_name "bittersweet"
      %Colorful.Color{blue: 94, brightness: 68.2, code: "#fe6f5e", green: 111,
      hue: 6.4, name: "bittersweet", red: 254, saturation: 98.8}

      iex> Colorful.Color.from_name :bittersweet
      %Colorful.Color{blue: 94, brightness: 68.2, code: "#fe6f5e", green: 111,
      hue: 6.4, name: "bittersweet", red: 254, saturation: 98.8}

  You can see all valid names using `Colorful.Color.names/0`.
  """

  defmodule UndefinedColorException do
    defexception [:message]

    def exception(name) do
      %UndefinedColorException{message: "'#{name}' is not defined"}
    end
  end

  defstruct name: "", code: "",
            red: 0, green: 0, blue: 0,
            hue: 0.0, saturation: 0.0, brightness: 0.0

  @external_resource colors_txt =
    [__DIR__, ~w(.. .. priv colors.txt)]
    |> List.flatten
    |> Path.join

  @doc """
  Returns color data as `%Colorful.Color{}`.
  """
  def from_name(name)

  @names []
  for line <- File.stream!(colors_txt) do
    [name, code, red, green, blue, hue, sat, bri] = line
      |> String.split
      |> Enum.map(&String.strip/1)

    @names [name | @names]
    def from_name(unquote name) do
      %__MODULE__{
        name:       unquote(name),
        code:       unquote(code),
        red:        String.to_integer(unquote red),
        green:      String.to_integer(unquote green),
        blue:       String.to_integer(unquote blue),
        hue:        to_float(unquote hue),
        saturation: to_float(unquote sat),
        brightness: to_float(unquote bri)
      }
    end
  end

  def from_name(name) when is_atom(name) do
    from_name(Atom.to_string name)
  end

  def from_name(name) do
    raise UndefinedColorException, name
  end

  @names Enum.sort(@names)
  @doc """
  Returns a list of all valid color names.
  """
  def names, do: @names

  @doc false
  defp to_float(str) do
    case String.contains?(str, ".") do
      true  -> String.to_float(str)
      false -> String.to_float(str <> ".0")
    end
  end
end
