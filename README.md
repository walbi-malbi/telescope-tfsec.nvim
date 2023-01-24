# telescope-tfsec.nvim

An extension for the telescope.nvim to search tfsec results.

[![asciicast](https://asciinema.org/a/553878.svg)](https://asciinema.org/a/553878)

## Get Started

Install with packer

```lua
use({
	"walbi-malbi/telescope-tfsec.nvim",
	config = function()
		require("telescope").load_extension("tfsec")
	end,
})
```

## Require

- [tfsec](https://github.com/aquasecurity/tfsec)
- [bat](https://github.com/sharkdp/bat)

## Usage

```
:Telescope tfsec
```
