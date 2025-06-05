local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local Job = require("plenary.job")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

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
        prompt_title = "test",
        finder = finders.new_job(function(prompt)
          return { "echo", prompt }
        end),
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, map)
          actions.select_default:replace(function()
            actions.close(prompt_bufnr)
            local selection = action_state.get_selected_entry()
            print(selection[1])
          end)
          return true
        end,
      })
      :find()
end

vim.api.nvim_create_user_command("DnDMonsterManual", function()
  -- api_request("goblin")
  custom_finder()
end, {})

-- command = "curl",
-- args = { "--silent", "https://www.dnd5eapi.co/api/2014/monsters/?name=" .. prompt },
