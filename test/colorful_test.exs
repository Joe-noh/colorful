defmodule ColorfulTest do
  use ExUnit.Case
  use Colorful

  alias Colorful, as: C

  import ExUnit.CaptureIO

  test :string do
    assert C.string("hello", "  red  ")       == "\e[31mhello\e[0m"
    assert C.string("hello", "red underline") == "\e[31m\e[4mhello\e[0m"
    assert C.string("hello", "underline red") == "\e[4m\e[31mhello\e[0m"
  end

  test :puts do
    assert capture_io(fn -> C.puts("hello", "red") end) == "\e[31mhello\e[0m\n"
  end

  test :puts_to_device do
    assert capture_io(:stderr, fn ->
      C.puts(:stderr, "hello", "red")
    end) == "\e[31mhello\e[0m\n"

    assert capture_io(:stderr, fn -> C.puts("hello", "red") end) == ""
  end

  test :inspects do
    assert capture_io(fn -> C.inspects([1, 2], "red") end) == "\e[31m[1, 2]\e[0m\n"
  end

  test :inspects_to_device do
    assert capture_io(:stderr, fn ->
      C.inspects(:stderr, [1, 2], "red")
    end) == "\e[31m[1, 2]\e[0m\n"

    assert capture_io(:stderr, fn -> C.inspects([1, 2], "red") end) == ""
  end

  test :default_decorator do
    assert C.string("hello") == "\e[0mhello\e[0m"
  end

  test :adapt_a_list do
    assert C.string("hello", ["underline", "red"]) == "\e[4m\e[31mhello\e[0m"
    assert C.string("hello", [:underline,  "red"]) == "\e[4m\e[31mhello\e[0m"
  end
end
