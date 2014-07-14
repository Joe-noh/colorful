defmodule ColorfulTest do
  use ExUnit.Case
  use Colorful

  alias Colorful, as: C

  test :string do
    assert C.string("hello", :red) == "\e[31mhello\e[0m"
    assert C.string("hello", :red_underline) == "\e[31m\e[4mhello\e[0m"
    assert C.string("hello", :underline_red) == "\e[4m\e[31mhello\e[0m"
  end
end
