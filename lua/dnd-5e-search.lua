local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values

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
	custom_finder()
end, {})

-- command = "curl",
-- args = { "--silent", "https://dnd5eapi.co/api/2014/monsters/?name=" .. prompt },
