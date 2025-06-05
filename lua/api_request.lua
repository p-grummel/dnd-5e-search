local Job = require("plenary.job")
local constants = require("constants")

local function sort_by_name(entry_1, entry_2)
  return entry_1.name < entry_2.name
end

return {
  send = function(sort, prompt, callback)
    print(constants.BASE_URL .. prompt)
    Job:new({
      command = "curl",
      args = { "--silent", constants.BASE_URL .. prompt },
      on_exit = function(j, return_val)
        --TODO: Error handling
        local output_string = table.concat(j:result(), "\n")
        vim.schedule(function()
          local json = vim.json.decode(output_string).results
          if sort then
            table.sort(json, sort_by_name)
          end
          print(vim.inspect(json))
          callback(json)
        end)
      end,
    }):start()
  end,
}
