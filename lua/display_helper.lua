return {

	display_monster = function(entry)
		local armor_pieces_string = function()
			if entry.armor_class[1].armor then
				local t = {}
				for index, i in ipairs(entry.armor_class[1].armor) do
					table.insert(t, (index == 1 and i.name or ", " .. i.name))
				end
				return " (" .. table.concat(t) .. ")"
			else
				return ""
			end
		end

		return {
			-- Title
			"___.:"
				.. entry.name
				.. ":.___",
			"",
			entry.size
				.. " "
				.. entry.type
				.. (entry.subtype and " (" .. entry.subtype .. ")" or "")
				.. ", "
				.. entry.alignment,
			"___",
			"",
			-- AC, HP, Speed
			"**Armor Class**: "
				.. entry.armor_class[1].value
				.. armor_pieces_string(),
		}
	end,
}
