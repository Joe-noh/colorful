defmodule ColorfulTest do
  use ExUnit.Case
  use Colorful

  alias Colorful, as: C

  import ExUnit.CaptureIO

  test :string do
    assert C.string("hello", :red)            == "\e[31mhello\e[0m"
    assert C.string("hello", :red_underline)  == "\e[31m\e[4mhello\e[0m"
    assert C.string("hello", "underline_red") == "\e[4m\e[31mhello\e[0m"
  end

  test :puts do
    assert capture_io(fn -> C.puts("hello", :red) end) == "\e[31mhello\e[0m\n"
  end

  test :inspects do
    assert capture_io(fn -> C.inspects([1, 2], :red) end) == "\e[31m[1, 2]\e[0m\n"
  end

  test :default_decorator do
    assert C.string("hello") == "\e[0mhello\e[0m"
  end
end
