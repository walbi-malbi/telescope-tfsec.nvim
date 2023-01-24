local tfsec = require("telescope._extensions.tfsec_builtin")

return require("telescope").register_extension({
	exports = {
		tfsec = tfsec.tfsec,
	},
})
