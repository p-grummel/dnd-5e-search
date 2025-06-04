local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

vim.api.nvim_create_user_command("DnDMonsterManual", function()
	pickers
		.new({}, {
			prompt_title = "Hello from Telescope",
			finder = finders.new_table({
				results = {
					"Test1",
					"Test2",
					"Test3",
					"Test4",
					"Test5",
				},
			}),
			sorter = conf.generic_sorter({}),
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					-- print("You selected: " .. selection[1])
				end)
				return true
			end,
		})
		:find()
end, {})
