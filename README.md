# Colorful

## `Colorful`

```elixir
Colorful.string("hello", "red underline")    #=> "\e[0m\e[31m\e[4mhello\e[0m"
Colorful.string("hello", ["red", "bright"])  #=> "\e[0m\e[31m\e[1mhello\e[0m"
Colorful.string("hello", [:red, :bright])    #=> "\e[0m\e[31m\e[1mhello\e[0m"

Colorful.string("orange", {5, 2, 1})
Colorful.string("underlined orange", [:underline, {5, 2, 1}])

Colorful.string("hello")   #=> "\e[0mhello\e[0m"

Colorful.puts("hello", "red")
Colorful.inspect([1, 2], "blue white_background")  # This returns [1, 2] like IO.inspect

Colorful.puts(:stderr, "hello", "red")
```

## `Colorful.Color`

```elixir
Colorful.Color.from_name "air_force_blue"
#=> %Colorful.Color{blue: 168, brightness: 51.2, code: "#5d8aa8", green: 138,
#                   hue: 204.0, name: "air_force_blue", red: 93, saturation: 30.1}

Colorful.Color.from_name("blue") = Colorful.Color.from_name(:blue)

Colorful.Color.names
# => ["air_force_blue", "alice_blue", "alizarin_crimson", ... ]
```
