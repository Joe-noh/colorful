# Colorful

**WIP**

This provides some macros to decorate characters on CUI.

## Usage

```
use Colorful

Colorful.string("hello", "red underline")  #=> "\e[31m\e[4mhello\e[0m"

Colorful.string("hello")   #=> "\e[0m\e[1mhello\e[0m"

Colorful.puts("hello", "red")
Colorful.inspects([1, 2], "blue white_background")
```
