local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local transform_mod = require("telescope.actions.mt").transform_mod

local M = {}

M.insert_ignore = function(prompt_bufnr)
	local entry = action_state.get_selected_entry()
	actions.close(prompt_bufnr)

	local tfsec_ignore = "#tfsec:ignore:" .. entry.long_id

	local win = vim.api.nvim_get_current_win()
	vim.cmd.edit(entry.location.filename)
	vim.api.nvim_win_set_cursor(win, { entry.location.start_line, 0 })
	vim.api.nvim_buf_set_lines(0, entry.location.start_line - 1, entry.location.start_line - 1, false, { tfsec_ignore })
	vim.api.nvim_command("write")
	vim.api.nvim_command("stopinsert")
end

M.yank_url = function(prompt_bufnr)
	local entry = action_state.get_selected_entry()
	vim.fn.setreg("*", entry.links[1])
end

return transform_mod(M)
