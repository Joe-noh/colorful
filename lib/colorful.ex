defmodule Colorful do
  defmacro __using__(_) do
    quote do
      require Colorful
    end
  end

  defmacro string(string, colors) do
    decos = Atom.to_string(colors) |> String.split("_")
    quote do
      unquote(
        List.foldl decos, "", fn(deco, acc) ->
          quote do: unquote(acc) <> IO.ANSI.unquote(String.to_atom deco)
        end
      ) <> unquote(string) <> IO.ANSI.reset
    end
  end
end
