local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local entry_display = require("telescope.pickers.entry_display")
local previewers = require("telescope.previewers")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local M = {}

M.tfsec = function(opts)
	opts = opts or {}

	local exec_tfsec = function()
		local handle = io.popen("tfsec -f json --no-module-downloads --ignore-hcl-errors | jq -c")
		if handle ~= nil then
			local tfsec_results = handle:read("*a")
			handle:close()
			return vim.json.decode(tfsec_results) or {}
		else
			return {}
		end
	end

	local displayer = entry_display.create({
		separator = " ",
		items = {
			{ width = 40 },
			{ width = 60 },
			{ remaining = true },
		},
	})

	local make_display = function(entry)
		return displayer({
			entry.severity .. " " .. entry.resource,
			entry.long_id,
		})
	end

	pickers
		.new(opts, {
			prompt_title = "test prompt title",
			finder = finders.new_table({
				results = exec_tfsec().results,
				entry_maker = function(entry)
					return {
						ordinal = entry.severity .. entry.resource .. entry.long_id,
						display = make_display,

						rule_id = entry.rule_id,
						long_id = entry.long_id,
						rule_description = entry.rule_description,
						rule_provider = entry.rule_provider,
						rule_service = entry.rule_service,
						impact = entry.impact,
						resolution = entry.resolution,
						links = entry.links,
						description = entry.description,
						severity = entry.severity,
						warning = entry.warning,
						status = entry.status,
						resource = entry.resource,
						location = entry.location,
					}
				end,
			}),
			sorter = conf.generic_sorter(opts),
			previewer = previewers.new_termopen_previewer({
				title = "tfsec result",
				get_command = function(entry)
					return {
						vim.env.SHELL,
						"-c",
						"echo 'rule_id: '"
							.. entry.rule_id
							.. "'\nlong_id: '"
							.. entry.long_id
							.. "'\nrule_description: '"
							.. entry.rule_description
							.. "'\nrule_provider: '"
							.. entry.rule_provider
							.. "'\nrule_service: '"
							.. entry.rule_service
							.. "'\nimpact: '"
							.. entry.impact
							.. "'\nresolution: '"
							.. entry.resolution
							.. "'\nlinks: '"
							.. "'\n- '"
							.. entry.links[1]
							.. "'\n- '"
							.. entry.links[2]
							.. "'\ndescription: '"
							.. entry.description
							.. "'\nseverity: '"
							.. entry.severity
							.. "'\nwarning: '"
							.. tostring(entry.warning)
							-- .. "'\nstatus: '"
							-- .. entry.status
							.. "'\nresource: '"
							.. '"'
							.. entry.resource
							.. '"'
							.. "'\nlocation: '"
							.. "'\n  filename: '"
							.. entry.location.filename
							.. "'\n  start_line: '"
							.. entry.location.start_line
							.. "'\n  end_line: '"
							.. entry.location.end_line
							.. "'' | bat -l yaml --theme=DarkNeon --color=auto -p",
					}
				end,
			}),
			attach_mappings = function(prompt_bufnr)
				actions.select_default:replace(function()
					local entry = action_state.get_selected_entry()
					actions.close(prompt_bufnr)

					local win = vim.api.nvim_get_current_win()
					vim.cmd.edit(entry.location.filename)
					vim.api.nvim_win_set_cursor(win, { entry.location.start_line, 0 })

					vim.fn.setreg("*", entry.links[1])
				end)
				actions.select_horizontal:replace(function()
					local entry = action_state.get_selected_entry()
					actions.close(prompt_bufnr)

					vim.cmd("split")
					local bufnr = vim.uri_to_bufnr(vim.uri_from_fname(entry.location.filename))
					local win = vim.api.nvim_get_current_win()
					vim.api.nvim_win_set_buf(win, bufnr)
					vim.api.nvim_win_set_cursor(win, { entry.location.start_line, 0 })

					vim.fn.setreg("*", entry.links[1])
				end)
				actions.select_vertical:replace(function()
					local entry = action_state.get_selected_entry()
					actions.close(prompt_bufnr)

					vim.cmd("vsplit")
					local bufnr = vim.uri_to_bufnr(vim.uri_from_fname(entry.location.filename))
					local win = vim.api.nvim_get_current_win()
					vim.api.nvim_win_set_buf(win, bufnr)
					vim.api.nvim_win_set_cursor(win, { entry.location.start_line, 0 })

					vim.fn.setreg("*", entry.links[1])
				end)
				return true
			end,
		})
		:find()
end

return M
