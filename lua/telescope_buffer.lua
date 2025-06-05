local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local constants = require("constants")

return {
	draw = function(table_content)
		pickers
			.new({}, {
				prompt_title = constants.MONSTER_MANUAL_ICON .. "Monster Manual",
				--INFO: entries shown at once are limited to 200 or so by default
				-- -> maybe see how to change this in case it becomes annoying, but
				-- seems fine for now
				finder = finders.new_table({
					results = table_content,
					entry_maker = function(entry)
						return {
							value = entry.index,
							ordinal = entry.name,
							display = entry.name,
						}
					end,
				}),
				sorter = conf.generic_sorter({}),
				sorting_strategy = "ascending",
				scroll_strategy = "limit",
				attach_mappings = function(prompt_bufnr, map)
					actions.select_default:replace(function()
						actions.close(prompt_bufnr)
						local selection = action_state.get_selected_entry()
						-- custom_floating_buffer.open_floating_window({ "Test", "Test2", "Test3" })
						--TODO: Callback
					end)
					return true
				end,
			})
			:find()
	end,
}
