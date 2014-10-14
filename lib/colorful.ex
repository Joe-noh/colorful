defmodule Colorful do
  @moduledoc """
  This module is a wrapper for IO.ANSI module.

      iex> use Colorful

      iex> Colorful.string("hello", "red underline")
      "\e[31m\e[4mhello\e[0m"

      iex> Colorful.string("hello", ["red", "underline"])
      "\e[31m\e[4mhello\e[0m"

      iex> Colorful.string("hello", [:red, :underline])
      "\e[31m\e[4mhello\e[0m"

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

  @type decorators :: String.t | [String.t | atom]

  import Kernel, except: [inspect: 1]

  @doc false
  defmacro __using__(_) do
    quote do
      require Colorful
    end
  end

  @doc """
  This function makes given string decorated.

  The decoration is specified in the second argument.
  It is a string, or a list which members are string or atom.
  """
  @spec string(String.t, decorators) :: String.t
  defmacro string(text, decorators \\ "reset") do
    quote do
      unquote(
        List.foldl split_decorators(decorators), "", fn(deco, acc) ->
          quote do: unquote(acc) <> IO.ANSI.unquote(String.to_atom deco)
        end
      ) <> unquote(text) <> IO.ANSI.reset
    end
  end

  @doc """
  This outputs colored string to stdout as same as `IO.puts`.
  The return value is always `:ok`.
  """
  @spec puts(String.t, decorators) :: :ok
  defmacro puts(text, decorators \\ "reset") do
    quote do
      Colorful.puts(:erlang.group_leader, unquote(text), unquote(decorators))
    end
  end

  @doc """
  Outputs decorated text to specified device, similar to `IO.puts/2`
  """
  @spec puts(atom | pid, String.t, decorators) :: :ok
  defmacro puts(device, text, decorators) do
    quote do
      IO.puts(unquote(device), Colorful.convert_to_ansi(unquote decorators) <> unquote(text) <> IO.ANSI.reset)
    end
  end

  @doc """
  This writes colored string to stdout.
  The string is made of first argument according to `Inspect` protocol.

  This returns given first argument as it is.
  """
  @spec inspect(String.t, decorators) :: String.t
  defmacro inspect(text, decorators \\ "reset") do
    quote do
      Colorful.inspect(:erlang.group_leader, unquote(text), unquote(decorators))
    end
  end

  @doc """
  Inspects decorated text to specified device.
  """
  @spec inspect(atom | pid, String.t, decorators) :: :ok
  defmacro inspect(device, text, decorators) do
    quote do
      IO.puts(unquote(device), Colorful.convert_to_ansi(unquote decorators) <> inspect(unquote text) <> IO.ANSI.reset)
      unquote(text)
    end
  end

  @doc false
  defp split_decorators(decorators) when is_binary(decorators) do
    decorators |> String.split(" ", trim: true)
  end

  @doc false
  defp split_decorators(decorators) when is_list(decorators) do
    decorators |> Enum.map fn (deco) ->
      cond do
        is_atom(deco) -> Atom.to_string(deco)
        true -> deco
      end
    end
  end

  @doc false
  defmacro convert_to_ansi(decorators) do
    List.foldl split_decorators(decorators), "", fn(deco, acc) ->
      quote do: unquote(acc) <> IO.ANSI.unquote(String.to_atom deco)
    end
  end
end
