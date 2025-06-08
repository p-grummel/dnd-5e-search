local function merge_tables(tables)
	local result = {}
	for _, t in ipairs(tables) do
		for _, v in ipairs(t) do
			table.insert(result, v)
		end
	end
	return result
end

local function number_to_modifier_string(num)
	return (num < 0 and "" or "+") .. tostring(num)
end

local function ability_score_to_modifier(ability_score)
	local score = math.floor((ability_score - 10) / 2)
	return number_to_modifier_string(score)
end

return {
	merge_tables = merge_tables,
	number_to_modifier_string = number_to_modifier_string,
	ability_score_to_modifier = ability_score_to_modifier,
}
