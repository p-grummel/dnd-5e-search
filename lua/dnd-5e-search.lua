local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local Job = require("plenary.job")

-- ╔═════╗
-- ║ Api ║
-- ╚═════╝

local function fetch_monsters(query, callback_outer)
  --TODO: replace spaces in query with +
  query = query or ""
  if query == "" then
    --TODO: Second param for message
    callback_outer({})
    return
  end

  Job:new({
    command = "curl",
    args = {
      "--silent",
      "https://www.dnd5eapi.co/api/2014/monsters/?name=" .. query,
    },
    on_exit = function(j)
      local raw = table.concat(j:result(), "\n")

      -- Defer to main thread
      vim.schedule(function()
        local decoded = vim.fn.json_decode(raw)

        if not decoded or not decoded.results then
          --TODO: Differentiate between false response and no results
          print("No Result (not deoced or not decoded.results)")
          callback_outer({})
          return
        end

        local results = {}
        for _, monster in ipairs(decoded.results) do
          table.insert(results, monster.name)
        end

        callback_outer(results)
        return
      end)
    end,
  }):start()
end

-- ╔════════════════╗
-- ║ Monster Manual ║
-- ╚════════════════╝
vim.api.nvim_create_user_command("DnDMonsterManual", function()
  pickers
      .new({}, {
        prompt_title = "Monser Manual",
        results_title = "TestTest",

        finder = finders.new_dynamic({
          fn = function(prompt, callback)
            fetch_monsters(prompt, callback)
          end,

          entry_maker = function(entry)
            return {
              value = entry,
              display = entry,
              ordinal = entry,
            }
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
end, {})
