return {

	display_monster = function(entry)
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
			"**Armor Class**: " .. entry.armor_class[1].value,
		}
	end,
}
