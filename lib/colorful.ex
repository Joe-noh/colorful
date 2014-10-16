defmodule Colorful do
  @moduledoc """
  This module is a wrapper for IO.ANSI module.

      iex> Colorful.string("hello", "red underline")
      "\\e[0m\\e[31m\\e[4mhello\\e[0m"

      iex> Colorful.string("hello", ["red", "underline"])
      "\\e[0m\\e[31m\\e[4mhello\\e[0m"

      iex> Colorful.string("hello", [:red, :underline])
      "\\e[0m\\e[31m\\e[4mhello\\e[0m"

      iex> Colorful.puts("hello", "red")
      hello   # colored

      iex> Colorful.inspect(:hello, "red")
      :hello  # colored
      :hello  # return value, an atom

  Followings are valid decorators.

  - `red`
  - `green`
  - `blue`
  - `cyan`
  - `magenta`
  - `yellow`
  - `black`
  - `white`
  - `default_color`

  - `red_background`
  - `green_background`
  - `blue_background`
  - `cyan_background`
  - `magenta_background`
  - `yellow_background`
  - `black_background`
  - `white_background`
  - `default_background`

  - `normal`
  - `bright`
  - `italic`
  - `overlined`
  - `underline`
  - `crossed_out`
  - `reverse`
  - `inverse`
  - `conceal`
  - `faint`
  - `framed`
  - `encircled`
  - `blink_slow`
  - `blink_rapid`

  - `reset`
  - `not_italic`
  - `not_overlined`
  - `no_underline`
  - `not_framed_encircled`
  - `blink_off`

  - `primary_font`
  - `font_1`
  - `font_2`
  - `font_3`
  - `font_4`
  - `font_5`
  - `font_6`
  - `font_7`
  - `font_8`
  - `font_9`

  - `home`
  - `clear`
  """

  @type decorators :: String.t | atom | [String.t | atom]

  import Kernel, except: [inspect: 1]

  @doc false
  defmacro __using__(_) do
    # leave this for compatibility
  end

  @reset IO.ANSI.reset

  @doc """
  This function makes given string decorated.

  The decoration is specified in the second argument.
  It is a string, or a list which members are string or atom.
  """
  @spec string(String.t, decorators) :: String.t
  def string(text, decorators \\ nil) do
    sandwich_between_resets(to_ansi_code(decorators) <> text)
  end

  @doc """
  This outputs colored string to stdout as same as `IO.puts`.
  The return value is always `:ok`.
  """
  @spec puts(String.t, decorators) :: :ok
  def puts(text, decorators \\ nil) do
    puts(:erlang.group_leader, text, decorators)
  end

  @doc """
  Outputs decorated text to specified device, similar to `IO.puts/2`
  """
  @spec puts(atom | pid, String.t, decorators) :: :ok
  def puts(device, text, decorators) do
    decorated = to_ansi_code(decorators) <> text
    IO.puts(device, sandwich_between_resets(decorated))
  end

  @doc """
  This writes colored string to stdout.
  The string is made of first argument according to `Inspect` protocol.

  This returns given first argument as it is.
  """
  @spec inspect(term, decorators) :: term
  def inspect(term, decorators \\ nil) do
    __MODULE__.inspect(:erlang.group_leader, term, decorators)
  end

  @doc """
  Inspects decorated text to specified device.
  """
  @spec inspect(atom | pid, term, decorators) :: term
  def inspect(device, term, decorators) do
    decorated = to_ansi_code(decorators) <> Kernel.inspect(term)
    IO.puts(device, sandwich_between_resets(decorated))
    term
  end

  defp to_ansi_code(nil), do: ""

  defp to_ansi_code(decorators) when is_binary(decorators) do
    decorators
    |> String.split(" ", trim: true)
    |> to_ansi_code
  end

  defp to_ansi_code(decorators) when is_atom(decorators) do
    to_ansi_code [decorators]
  end

  defp to_ansi_code(decorators) when is_list(decorators) do
    decorators
    |> Enum.map(& io_ansi(&1))
    |> Enum.join
  end

  defp to_ansi_code(decorator) do
    raise ArgumentError,
          "Expected a binary, an atom or a list. But got #{Kernel.inspect decorator}"
  end

  defp io_ansi(fn_name) when is_atom(fn_name) or is_binary(fn_name) do
    "IO.ANSI.#{fn_name}"
    |> Code.eval_string
    |> elem(0)
  end

  defp io_ansi(fn_name) do
    raise ArgumentError, "IO.ANSI.#{Kernel.inspect fn_name} is not defined."
  end

  defp sandwich_between_resets(text) do
    @reset <> text <> @reset
  end
end
