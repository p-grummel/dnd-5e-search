local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local Job = require("plenary.job")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local function window_2(table_content)
  pickers
      .new({}, {
        prompt_title = "window_2",
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
        attach_mappings = function(prompt_bufnr, map)
          actions.select_default:replace(function()
            actions.close(prompt_bufnr)
            local selection = action_state.get_selected_entry()
            api_request(selection[1])
          end)
          return true
        end,
      })
      :find()
end

local function api_request(prompt)
  Job:new({
    command = "curl",
    args = { "--silent", "https://www.dnd5eapi.co/api/2014/monsters/?name=" .. prompt },
    on_exit = function(j, return_val)
      local output_string = table.concat(j:result(), "\n")
      vim.schedule(function()
        local json = vim.json.decode(output_string).results
        window_2(json)
      end)
    end,
  }):start()
end

local function window_1()
  pickers
      .new({}, {
        prompt_title = "window_1",
        finder = finders.new_job(function(prompt)
          return { "echo", prompt }
        end),
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, map)
          actions.select_default:replace(function()
            actions.close(prompt_bufnr)
            local selection = action_state.get_selected_entry()
            api_request(selection[1])
          end)
          return true
        end,
      })
      :find()
end

vim.api.nvim_create_user_command("DnDMonsterManual", function()
  window_1()
end, {})
