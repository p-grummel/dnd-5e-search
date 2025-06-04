local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local Job = require("plenary.job")

local function fetch_monsters_async(query, on_result)
	if query == "" then
		on_result({})
		return
	end

	Job:new({
		command = "curl",
		args = {
			"--silent",
			"https://www.dnd5eapi.co/api/2014/monsters/?name=" .. query,
		},
		on_exit = function(j, return_val)
			local raw = table.concat(j:result(), "\n")
			local decoded = vim.fn.json_decode(raw) or {}
			local results = {}
			if decoded.results then
				for _, monster in ipairs(decoded.results) do
					table.insert(results, monster.name)
				end
			end
			vim.schedule(function()
				on_result(results)
			end)
		end,
	}):start()
end

local function search_monsters()
	pickers
		.new({}, {
			prompt_title = "Search DnD Monsters",
			finder = finders.new_dynamic({
				fn = function(prompt, process_result)
					fetch_monsters_async(prompt, function(results)
						process_result(results)
					end)
				end,
			}),
			sorter = conf.generic_sorter({}),
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					local selection = action_state.get_selected_entry()
					print("Selected: " .. selection[1])
					actions.close(prompt_bufnr)
				end)
				return true
			end,
		})
		:find()
end

vim.api.nvim_create_user_command("DnDMonsterManual", function()
	search_monsters()
end, {})
