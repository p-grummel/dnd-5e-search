return {
	merge_tables = function(tables)
		local result = {}
		for _, t in ipairs(tables) do
			for _, v in ipairs(t) do
				table.insert(result, v)
			end
		end
		return result
	end,
}
