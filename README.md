# telescope-tfsec.nvim

An extension for the telescope.nvim to search tfsec results.

[![asciicast](https://asciinema.org/a/554154.svg)](https://asciinema.org/a/554154)

## Get Started

Install with lazy

```lua
{
	"walbi-malbi/telescope-tfsec.nvim",
	config = function()
		require("telescope").load_extension("tfsec")
	end,
},
```

Install with packer

```lua
use({
	"walbi-malbi/telescope-tfsec.nvim",
	config = function()
		require("telescope").load_extension("tfsec")
	end,
})
```

## Mappings

|Keymap|Description|
|:-|:-|
|\<C-i\>| insert ignore|
|\<C-y\>| copy url |

## Require

- [tfsec](https://github.com/aquasecurity/tfsec)
- [bat](https://github.com/sharkdp/bat)
- [jq](https://stedolan.github.io/jq)

## Usage

```
:Telescope tfsec
```
