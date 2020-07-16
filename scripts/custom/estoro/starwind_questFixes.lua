local Methods = {}

Methods.OnCharacterCreated = function(eventStatus, pid)
    logicHandler.RunConsoleCommandOnPlayer(pid, "Journal SW_CharGen 1")
	logicHandler.RunConsoleCommandOnPlayer(pid, "Journal SW_CharGen 2")
	logicHandler.RunConsoleCommandOnPlayer(pid, "Journal SW_CharGen 3")
end

Methods.OnLogin = function(pid)
    -- Remove faction expulsion
    local factions = Players[pid].data.factionExpulsion
    for faction, state in pairs(factions) do
        factions[faction] = false
    end
    Players[pid]:LoadFactionExpulsion()
    -- Remove skill damage
    local skills = Players[pid].data.skills
    for index, skill in pairs(skills) do
        skill["damage"] = 0
    end
    Players[pid]:LoadSkills()
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