# Colorful

**WIP**

This provides some macros to decorate characters on CUI.

## Usage

```
use Colorful

Colorful.string("hello", :red_underline)
#=> "\e[31m\e[4mhello\e[0m"

Colorful.string("hello", :blue_bright)
#=> "\e[34m\e[1mhello\e[0m"
```
