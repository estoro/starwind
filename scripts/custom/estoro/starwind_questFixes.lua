local Methods = {}

Methods.OnCharacterCreated = function(eventStatus, pid)
    logicHandler.RunConsoleCommandOnPlayer(pid, "Journal SW_CharGen 1")
    logicHandler.RunConsoleCommandOnPlayer(pid, "Journal SW_CharGen 2")
    logicHandler.RunConsoleCommandOnPlayer(pid, "Journal SW_CharGen 3")
    local spellbook = Players[pid].data.spellbook
    for index, item in pairs(spellbook) do
        if spellbook[index] == "bound dagger" then
            logicHandler.RunConsoleCommandOnPlayer(pid, "player->removeSpell \"bound dagger\"")
        elseif spellbook[index] == "hearth heal" then
            logicHandler.RunConsoleCommandOnPlayer(pid, "player->removeSpell \"hearth heal\"")
        elseif spellbook[index] == "chameleon" then
            logicHandler.RunConsoleCommandOnPlayer(pid, "player->removeSpell \"chameleon\"")
        elseif spellbook[index] == "detect_creature" then
            logicHandler.RunConsoleCommandOnPlayer(pid, "player->removeSpell \"detect_creature\"")
        elseif spellbook[index] == "fire bite" then
            logicHandler.RunConsoleCommandOnPlayer(pid, "player->removeSpell \"fire bite\"")
        elseif spellbook[index] == "sanctuary" then
            logicHandler.RunConsoleCommandOnPlayer(pid, "player->removeSpell \"sanctuary\"")
        elseif spellbook[index] == "shield" then
            logicHandler.RunConsoleCommandOnPlayer(pid, "player->removeSpell \"shield\"")
        elseif spellbook[index] == "summon ancestral ghost" then
            logicHandler.RunConsoleCommandOnPlayer(pid, "player->removeSpell \"summon ancestral ghost\"")
        elseif spellbook[index] == "water walking" then
            logicHandler.RunConsoleCommandOnPlayer(pid, "player->removeSpell \"water walking\"")
        end
    end
end

Methods.OnLogin = function(pid)
    -- Remove imperial legion faction
    local factionExpulsion = Players[pid].data.factionExpulsion
    if nil ~= factionExpulsion["imperial legion"] then
        factionExpulsion["imperial legion"] = nil
        Players[pid]:LoadFactionExpulsion()
    end
    local factionReputation = Players[pid].data.factionReputation
    if nil ~= factionReputation["imperial legion"] then
        factionReputation["imperial legion"] = nil
        Players[pid]:LoadFactionReputation()
    end
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