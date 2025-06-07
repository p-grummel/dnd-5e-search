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

	ability_score_to_modifier = function(ability_score)
		local score = math.floor((ability_score - 10) / 2)
		local score_string = (score < 0 and "" or "+") .. tostring(score)
		return score_string
	end,
}
