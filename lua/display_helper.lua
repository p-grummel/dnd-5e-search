local utils = require("utils")

function title_section(entry)
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

function ac_speed_hp_section(entry)
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

	local armor_type_string = function()
		if entry.armor_class[1].type == "armor" then
			return ""
		else
			return " *(" .. entry.armor_class[1].type .. ")*"
		end
	end

	local speed_types = function()
		local t = {}
		for k, v in pairs(entry.speed) do
			table.insert(t, "- " .. k .. ": " .. v)
		end
		return t
	end

	return utils.merge_tables({
		{
			"**Armor Class**: " .. entry.armor_class[1].value .. armor_pieces_string() .. armor_type_string(),
			"**HP**: " .. entry.hit_points,
			"___",
			"**Speed**: ",
		},
		speed_types(),
		{ "___" },
	})
end

function stat_section(entry)
	return {
		"| **STR** | **DEX** | **CON** | **INT** | **WIS** | **CHA** |",
		"|---|---|---|---|---|---|",
		"| "
			.. entry.strength
			.. " ("
			.. utils.ability_score_to_modifier(entry.strength)
			.. ")"
			.. " | "
			.. entry.dexterity
			.. " ("
			.. utils.ability_score_to_modifier(entry.dexterity)
			.. ")"
			.. " | "
			.. entry.constitution
			.. " ("
			.. utils.ability_score_to_modifier(entry.constitution)
			.. ")"
			.. " | "
			.. entry.intelligence
			.. " ("
			.. utils.ability_score_to_modifier(entry.intelligence)
			.. ")"
			.. " | "
			.. entry.wisdom
			.. " ("
			.. utils.ability_score_to_modifier(entry.wisdom)
			.. ")"
			.. " | "
			.. entry.charisma
			.. " ("
			.. utils.ability_score_to_modifier(entry.charisma)
			.. ")"
			.. " |",
	}
end

return {
	display_monster = function(entry)
		return utils.merge_tables({ title_section(entry), ac_speed_hp_section(entry), stat_section(entry) })
	end,
}
