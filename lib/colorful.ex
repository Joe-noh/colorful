defmodule Colorful do
  @moduledoc """
  Wrapper for IO.ANSI module.

      use Colorful

      Colorful.string("hello", "red white_background bright")

      Colorful.puts("hello", "red")
      Colorful.inspects(:hello, "underline")
  """

  import Kernel, except: [inspect: 1]

  @doc false
  defmacro __using__(_) do
    quote do
      require Colorful
    end
  end

  @doc "Make colored string"
  defmacro string(target, decorators \\ "reset") do
    quote do
      unquote(
        List.foldl split_decorators(decorators), "", fn(deco, acc) ->
          quote do: unquote(acc) <> IO.ANSI.unquote(String.to_atom deco)
        end
      ) <> unquote(target) <> IO.ANSI.reset
    end
  end

  @doc "Output colored string to stdout"
  defmacro puts(target, decorators \\ "reset") do
    quote do
      Colorful.puts(:erlang.group_leader, unquote(target), unquote(decorators))
    end
  end

  defmacro puts(device, target, decorators) do
    quote do
      IO.puts(unquote(device), Colorful.convert_to_ansi(unquote decorators) <> unquote(target) <> IO.ANSI.reset)
    end
  end

  @doc "Inspect colored object"
  defmacro inspect(target, decorators \\ "reset") do
    quote do
      Colorful.inspect(:erlang.group_leader, unquote(target), unquote(decorators))
    end
  end

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

  defmacro convert_to_ansi(decorators) do
    List.foldl split_decorators(decorators), "", fn(deco, acc) ->
      quote do: unquote(acc) <> IO.ANSI.unquote(String.to_atom deco)
    end
  end
end
