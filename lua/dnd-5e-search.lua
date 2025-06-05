local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local Job = require("plenary.job")

local function api_request(prompt)
	Job:new({
		command = "curl",
		args = { "--silent", "https://www.dnd5eapi.co/api/2014/monsters/?name=" .. prompt },
		on_exit = function(j, return_val)
			local output = table.concat(j:result(), "\n")
			vim.schedule(function()
				print("API response:\n" .. output)
			end)
		end,
	}):start()
end

local function custom_finder()
	pickers
		.new({}, {
			prompt_title = "colors",
			finder = finders.new_job(function(prompt)
				print(prompt)
				if prompt == nil or prompt == "" then
					return nil
				end
				return { "echo", prompt }
			end),
			sorter = conf.generic_sorter({}),
		})
		:find()
end

vim.api.nvim_create_user_command("DnDMonsterManual", function()
	api_request("goblin")
end, {})

-- command = "curl",
-- args = { "--silent", "https://www.dnd5eapi.co/api/2014/monsters/?name=" .. prompt },
