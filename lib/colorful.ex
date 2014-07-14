defmodule Colorful do
  defmacro __using__(_) do
    quote do
      require Colorful
    end
  end

  defmacro string(target, decorators \\ "reset") do
    quote do
      unquote(
        List.foldl split_decorators(decorators), "", fn(deco, acc) ->
          quote do: unquote(acc) <> IO.ANSI.unquote(String.to_atom deco)
        end
      ) <> unquote(target) <> IO.ANSI.reset
    end
  end

  defmacro puts(target, decorators \\ "reset") do
    quote do
      IO.puts(unquote(
        List.foldl split_decorators(decorators), "", fn(deco, acc) ->
          quote do: unquote(acc) <> IO.ANSI.unquote(String.to_atom deco)
        end
      ) <> unquote(target) <> IO.ANSI.reset)
    end
  end

  defmacro inspects(target, decorators \\ "reset") do
    quote do
      IO.puts(unquote(
        List.foldl split_decorators(decorators), "", fn(deco, acc) ->
          quote do: unquote(acc) <> IO.ANSI.unquote(String.to_atom deco)
        end
      ) <> (inspect unquote(target)) <> IO.ANSI.reset)
    end
  end

  defp split_decorators(decorators) when is_binary(decorators) do
    decorators |> String.split(" ", trim: true)
  end
end
