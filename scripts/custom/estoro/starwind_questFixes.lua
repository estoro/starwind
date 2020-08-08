local Methods = {}

Methods.OnCharacterCreated = function(eventStatus, pid)
	logicHandler.RunConsoleCommandOnPlayer(pid, "Journal SW_CharGen 1")
	logicHandler.RunConsoleCommandOnPlayer(pid, "Journal SW_CharGen 2")
	logicHandler.RunConsoleCommandOnPlayer(pid, "Journal SW_CharGen 3")
	local spellbook = Players[pid].data.spellbook
	for index, item in pairs(spellbook) do
		if spellbook[index] == "fire bite" then
			logicHandler.RunConsoleCommandOnPlayer(pid, "player->removeSpell \"fire bite\"")
		elseif spellbook[index] == "sanctuary" then
			logicHandler.RunConsoleCommandOnPlayer(pid, "player->removeSpell \"sanctuary\"")
		elseif spellbook[index] == "summon ancestral ghost" then
			logicHandler.RunConsoleCommandOnPlayer(pid, "player->removeSpell \"summon ancestral ghost\"")
		elseif spellbook[index] == "water walking" then
			logicHandler.RunConsoleCommandOnPlayer(pid, "player->removeSpell \"water walking\"")
		end
	end
end

Methods.OnLogin = function(pid)
	logicHandler.RunConsoleCommandOnPlayer(pid, "Set TravelState to 0")
	-- Remove skill damage
	local skills = Players[pid].data.skills
	for index, skill in pairs(skills) do
		skill["damage"] = 0
	end
	Players[pid]:LoadSkills()
	-- Remove attribute damage
	local attributes = Players[pid].data.attributes
	for index, attribute in pairs(attributes) do
		attribute["damage"] = 0
	end
	Players[pid]:LoadAttributes()
	-- Fix Race Quest
	local journal = Players[pid].data.journal
	local hasEntry10 = false
	local hasEntry15 = false
	for index, entry in pairs(journal) do
		if entry["quest"] == "sw_race" then
			if entry["index"] == 10 then
				hasEntry10 = true
			elseif entry["index"] == 15 then
				hasEntry15 = true
			end
		end
	end
	if hasEntry10 and not hasEntry15 then
		logicHandler.RunConsoleCommandOnPlayer(pid, "Journal SW_Race 15")
	end
end

customEventHooks.registerHandler("OnPlayerEndCharGen", Methods.OnCharacterCreated)
customEventHooks.registerHandler("OnPlayerAuthentified", function(eventStatus, pid)
	tes3mp.LogMessage(enumerations.log.INFO, "[starwind_questFixes] OnPlayerAuthentified " .. Players[pid].name) 
	Methods.OnLogin(pid)
end)