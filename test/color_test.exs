defmodule ColorTest do
  use ExUnit.Case

  alias Colorful.Color

  test :names do
    names = Color.names

    assert is_list(names)
    assert Enum.count(names) > 700
    assert names == Enum.sort(names)
    assert "air_force_blue" in names
    assert "zinnwaldite_brown" in names
  end

  test :from_name do
    air_force_blue    = Color.from_name("air_force_blue")
    zinnwaldite_brown = Color.from_name("zinnwaldite_brown")

    [name: "air_force_blue", code: "#5d8aa8",
     red: 93, green: 138, blue: 168,
     hue: 204.0, saturation: 30.1, brightness: 51.2]
    |> Enum.each fn {key, val} ->
      assert Map.get(air_force_blue, key) == val
    end

    [name: "zinnwaldite_brown", code: "#2c1608",
     red: 44, green: 22, blue: 8,
     hue: 23.3, saturation: 69.2, brightness: 10.2]
    |> Enum.each fn {key, val} ->
      assert Map.get(zinnwaldite_brown, key) == val
    end
  end

  test :from_name_undefined do
    assert_raise Colorful.Color.UndefinedColorException, fn ->
      Color.from_name("unknown_color")
    end
  end
end
