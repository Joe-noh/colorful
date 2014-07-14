defmodule Colorful do
  @moduledoc """
    Wrapper for IO.ANSI module.

        use Colorful

        Colorful.string("hello", "red white_background bright")

        Colorful.puts("hello", "red")
        Colorful.inspects(:hello, "underline")
  """

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
      IO.puts(unquote(
        List.foldl split_decorators(decorators), "", fn(deco, acc) ->
          quote do: unquote(acc) <> IO.ANSI.unquote(String.to_atom deco)
        end
      ) <> unquote(target) <> IO.ANSI.reset)
    end
  end

  @doc "Note that inspects, not inspect"
  defmacro inspects(target, decorators \\ "reset") do
    quote do
      IO.puts(unquote(
        List.foldl split_decorators(decorators), "", fn(deco, acc) ->
          quote do: unquote(acc) <> IO.ANSI.unquote(String.to_atom deco)
        end
      ) <> (inspect unquote(target)) <> IO.ANSI.reset)
    end
  end

  @doc false
  defp split_decorators(decorators) when is_binary(decorators) do
    decorators |> String.split(" ", trim: true)
  end
end
