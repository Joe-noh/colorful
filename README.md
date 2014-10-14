# Colorful

This provides some macros to decorate characters on CUI.

## Usage

```elixir
use Colorful

Colorful.string("hello", "red underline")    #=> "\e[31m\e[4mhello\e[0m"
Colorful.string("hello", ["red", "bright"])  #=> "\e[31m\e[1mhello\e[0m"
Colorful.string("hello", [:red, :bright])    #=> "\e[31m\e[1mhello\e[0m"

Colorful.string("hello")   #=> "\e[0mhello\e[0m"

Colorful.puts("hello", "red")
Colorful.inspect([1, 2], "blue white_background")  # This returns [1, 2] like IO.inspect

Colorful.puts(:stderr, "hello", "red")
```
