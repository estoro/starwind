inventoryHelper = require("inventoryHelper")

customEventHooks.registerValidator("OnObjectActivate", function(eventStatus, pid, cellDescription, objects, players)
    local isValid = eventStatus.validDefaultHandler

    for n,object in pairs(objects) do
        local objectUniqueIndex = object.uniqueIndex
        local objectRefId = object.refId
        
        if objectRefId == "sw_lafeauxkash" then
            if objectUniqueIndex == nil then isValid = false return end
            if objectUniqueIndex == "194-0" then
                local journal = Players[pid].data.journal
                local hasEntry = false
                for index, entry in pairs(journal) do
                    if entry["quest"] == "sw_jedi" then
                        if entry["index"] >= 50 then
                            hasEntry = true
                        end
                    end
                end
                if not hasEntry then
                    tes3mp.CustomMessageBox(pid, -1, "Lafeaux ignores you.", "Ok")
                    isValid = false
                end
            end
        end
        if objectRefId == "sw_bedkidnap" then
            if objectUniqueIndex == nil then isValid = false return end
            if objectUniqueIndex == "7235-0" then
                local journal = Players[pid].data.journal
                local hasEntry40 = false
                local hasEntry45 = false
                for index, entry in pairs(journal) do
                    if entry["quest"] == "sw_republic" or entry["quest"] == "sw_sith" then
                        if entry["index"] == 40 then
                            hasEntry40 = true
                        end
                        if entry["index"] == 45 then
                            hasEntry45 = true
                        end
                    end
                end
                if not hasEntry40 or hasEntry45 then
                    tes3mp.CustomMessageBox(pid, -1, "Nothing happens.", "Ok")
                    isValid = false
                end
            end
        end
        if objectRefId == "ex_s_door" then
            if objectUniqueIndex == nil then isValid = false return end
            if objectUniqueIndex == "1741-0" then
                local journal = Players[pid].data.journal
                local hasEntry20 = false
                local hasEntry25 = false
                for index, entry in pairs(journal) do
                    if entry["quest"] == "sw_hunt" then
                        if entry["index"] == 20 then
                            hasEntry20 = true
                        elseif entry["index"] == 25 then
                            hasEntry25 = true
                        end
                    end
                end
                if hasEntry20 and not hasEntry25 then
                    local inventory = Players[pid].data.inventory
                    tes3mp.CustomMessageBox(pid, -1, "This area is currently not working. Sand Maggot Queen eggs added to inventory.", "Ok")
                    if not inventoryHelper.containsItem(inventory, "sw_sandeggs", -1, -1, "") then
                        logicHandler.RunConsoleCommandOnPlayer(pid, "player->addItem sw_sandeggs 1")
                    end
                else
                    tes3mp.CustomMessageBox(pid, -1, "This area is currently not working.", "Ok")
                end
                isValid = false
            end
        end
        if objectRefId == "sw_korribandoor" then
            if objectUniqueIndex == nil then isValid = false return end
            if objectUniqueIndex == "6556-0" then
                tes3mp.CustomMessageBox(pid, -1, "This area is currently not working. I will fix it soon.", "Ok")
                -- TODO disable bad script when player enters area and figure out what to do about non functioning doors
                isValid = false
            end
        end
        if objectRefId == "sw_repentr2" then
            if objectUniqueIndex == nil then isValid = false return end
            if objectUniqueIndex == "5759-0" then
                if nil ~= Players[pid].data.factionRanks["the republic"] then
                    logicHandler.RunConsoleCommandOnPlayer(pid, "sw_repentr2->unlock")
                else
                    logicHandler.RunConsoleCommandOnPlayer(pid, "sw_repentr2->lock 100")
                    isValid = false
                end
            end
        end
        if objectRefId == "sw_sithentr" then
            if objectUniqueIndex == nil then isValid = false return end
            if objectUniqueIndex == "7871-0" then
                if nil ~= Players[pid].data.factionRanks["the sith"] then
                    logicHandler.RunConsoleCommandOnPlayer(pid, "sw_sithentr->unlock")
                else
                    logicHandler.RunConsoleCommandOnPlayer(pid, "sw_sithentr->lock 100")
                    isValid = false
                end
            end
        end
        if objectRefId == "sw_manadoorframe" then
            if objectUniqueIndex == nil then isValid = false return end
            if objectUniqueIndex == "3424-0" then
                -- unlocks after certain quest ???
                --[[
                local journal = Players[pid].data.journal
                local hasEntry = false
                for index, entry in pairs(journal) do
                    if entry["quest"] == "" and entry["index"] ==  then
                        hasEntry = true
                    end
                end
                if hasEntry then
                    logicHandler.RunConsoleCommandOnPlayer(pid, "sw_manadoorframe->unlock")
                else
                    logicHandler.RunConsoleCommandOnPlayer(pid, "sw_manadoorframe->lock 100")
                    isValid = false
                end
                ]]--
            end
        end
        if objectRefId == "sw_sandrivergate2" then
            if objectUniqueIndex == nil then isValid = false return end
            if objectUniqueIndex == "3849-0" then
                local journal = Players[pid].data.journal
                local hasEntry = false
                for index, entry in pairs(journal) do
                    if entry["quest"] == "sw_work" and entry["index"] == 31 then
                        hasEntry = true
                    end
                end
                if hasEntry then
                    logicHandler.RunConsoleCommandOnPlayer(pid, "sw_sandrivergate2->unlock")
                else
                    logicHandler.RunConsoleCommandOnPlayer(pid, "sw_sandrivergate2->lock 100")
                    isValid = false
                end
            end
        end
        if objectRefId == "sw_czerkadoor" then
            if objectUniqueIndex == nil then isValid = false return end
            if objectUniqueIndex == "3833-0" then
                local journal = Players[pid].data.journal
                local hasEntry = false
                for index, entry in pairs(journal) do
                    if entry["quest"] == "sw_czerkamurd" and entry["index"] == 30 then
                        hasEntry = true
                    end
                end
                if hasEntry then
                    logicHandler.RunConsoleCommandOnPlayer(pid, "sw_czerkadoor->unlock")
                else
                    logicHandler.RunConsoleCommandOnPlayer(pid, "sw_czerkadoor->lock 100")
                    isValid = false
                end
            end
        end
        if objectRefId == "sw_geno" then
            if objectUniqueIndex == nil then isValid = false return end
            if objectUniqueIndex == "1748-0" then
                if nil ~= Players[pid].data.factionRanks["sw_genoharadan"] then
                    logicHandler.RunConsoleCommandOnPlayer(pid, "sw_geno->unlock")
                else
                    logicHandler.RunConsoleCommandOnPlayer(pid, "sw_geno->lock 100")
                    isValid = false
                end
            end
        end
        if objectRefId == "sw_narelevator" then
            if objectUniqueIndex == nil then isValid = false return end
            if objectUniqueIndex == "7582-0" then
                local inventory = Players[pid].data.inventory
                if not inventoryHelper.containsItem(inventory, "sw_narkey", -1, -1, "") then
                    logicHandler.RunConsoleCommandOnPlayer(pid, "sw_narelevator->lock 100")
                    isValid = false
                end
            end
        end
        if objectRefId == "sw_submersible" then
            if objectUniqueIndex == nil then isValid = false return end
            if objectUniqueIndex == "6532-0" then
                logicHandler.RunConsoleCommandOnPlayer(pid, "coc \"Manaan, Submersible Docking Bay\"")
            end
        end

    -- End New Additions
    eventStatus.validDefaultHandler = isValid
    return eventStatus

    end
end)