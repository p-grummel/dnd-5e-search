local utils = require("utils")

return {

	display_monster = function(entry)
		local title_section = function()
			return {
				"___.:" .. entry.name .. ":.___",
				"",
				entry.size
					.. " "
					.. entry.type
					.. (entry.subtype and " (" .. entry.subtype .. ")" or "")
					.. ", "
					.. entry.alignment,
				"___",
			}
		end

		local ac_speed_hp_section = function()
			local armor_pieces_string = function()
				if entry.armor_class[1].armor then
					local t = {}
					for index, i in ipairs(entry.armor_class[1].armor) do
						table.insert(t, (index == 1 and i.name or ", " .. i.name))
					end
					return " *(" .. table.concat(t) .. ")*"
				else
					return ""
				end
			end

			local speed_types = function()
				for k, v in pairs(entry.speed) do
				end
			end

			return {
				"**Armor Class**: " .. entry.armor_class[1].value .. armor_pieces_string(),
				"**HP**: " .. entry.hit_points,
				-- "**Speed**: " .. entry.
				"___",
			}
		end

		return utils.merge_tables({ title_section(), ac_speed_hp_section() })
	end,
}
