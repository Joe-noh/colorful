defmodule Colorful do
  @moduledoc """
  Wrapper for IO.ANSI module.

      use Colorful

      Colorful.string("hello", "red white_background bright")

      Colorful.puts("hello", "red")
      Colorful.inspects(:hello, "underline")
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
  defmacro string(target, decorators \\ "reset") do
    quote do
      unquote(
        List.foldl split_decorators(decorators), "", fn(deco, acc) ->
          quote do: unquote(acc) <> IO.ANSI.unquote(String.to_atom deco)
        end
      ) <> unquote(target) <> IO.ANSI.reset
    end
  end

  @doc """
  This outputs colored string to stdout as same as `IO.puts`.
  The return value is always `:ok`.
  """
  @spec puts(String.t, decorators) :: :ok
  defmacro puts(target, decorators \\ "reset") do
    quote do
      Colorful.puts(:erlang.group_leader, unquote(target), unquote(decorators))
    end
  end

  @doc """
  Outputs decorated text to specified device, similar to `IO.puts/2`
  """
  @spec puts(atom | pid, String.t, decorators) :: :ok
  defmacro puts(device, target, decorators) do
    quote do
      IO.puts(unquote(device), Colorful.convert_to_ansi(unquote decorators) <> unquote(target) <> IO.ANSI.reset)
    end
  end

  @doc """
  This writes colored string to stdout and return it.
  The string is made of first argument according to `Inspect` protocol.
  """
  @spec inspect(String.t, decorators) :: String.t
  defmacro inspect(target, decorators \\ "reset") do
    quote do
      Colorful.inspect(:erlang.group_leader, unquote(target), unquote(decorators))
    end
  end

  @doc """
  Inspects decorated text to specified device.
  """
  @spec inspect(atom | pid, String.t, decorators) :: :ok
  defmacro inspect(device, target, decorators) do
    quote do
      IO.puts(unquote(device), Colorful.convert_to_ansi(unquote decorators) <> inspect(unquote target) <> IO.ANSI.reset)
      unquote(target)
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
