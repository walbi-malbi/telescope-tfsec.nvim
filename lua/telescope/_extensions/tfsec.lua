local tfsec = require("telescope._extensions.tfsec.main")
local tfsec_actions = require("telescope._extensions.tfsec.actions")

return require("telescope").register_extension({
	exports = {
		tfsec = tfsec.main,
		actions = tfsec_actions,
	},
})
