inventoryHelper = require("inventoryHelper")

customEventHooks.registerValidator("OnObjectActivate", function(eventStatus, pid, cellDescription, objects, players)
	local isValid = eventStatus.validDefaultHandler

	for n,object in pairs(objects) do
		local objectUniqueIndex = object.uniqueIndex
		local objectRefId = object.refId
		
		-- player house
		if objectRefId == "sw_doortatbuyhouse" then
			if objectUniqueIndex == nil then isValid = false return end
			logicHandler.RunConsoleCommandOnPlayer(pid, "sw_doortatbuyhouse->unlock")
		end
		if objectRefId == "sw_manordoor" then
			if objectUniqueIndex == nil then isValid = false return end
			logicHandler.RunConsoleCommandOnPlayer(pid, "sw_manordoor->unlock")
		end
		
		-- ???
		if objectRefId == "door_sotha_pre_loadextra" then
			if objectUniqueIndex == nil then isValid = false return end
			logicHandler.RunConsoleCommandOnPlayer(pid, "door_sotha_pre_loadextra->unlock")
		end
		
		-- planets
		if objectRefId == "sw_plankash" then
			if objectUniqueIndex == nil then isValid = false return end
			logicHandler.RunConsoleCommandOnPlayer(pid, "Player->PositionCell, 798, 1455, 13975, 45, \"Kashyyk\"")
			logicHandler.RunConsoleCommandOnPlayer(pid, "Set TravelState to 0")
			logicHandler.RunConsoleCommandOnPlayer(pid, "player->additem common_pants_03 1")
			logicHandler.RunConsoleCommandOnPlayer(pid, "player->equip common_pants_03")
			logicHandler.RunConsoleCommandOnPlayer(pid, "player->RemoveSpell SW_BlasterShip")
			isValid = false
		end
		if objectRefId == "sw_planman" then
			if objectUniqueIndex == nil then isValid = false return end
			logicHandler.RunConsoleCommandOnPlayer(pid, "Player->PositionCell, 297, 10279, 7544, 171, \"Manaan, Docking Bay\"")
			logicHandler.RunConsoleCommandOnPlayer(pid, "Set TravelState to 0")
			logicHandler.RunConsoleCommandOnPlayer(pid, "player->additem common_pants_03 1")
			logicHandler.RunConsoleCommandOnPlayer(pid, "player->equip common_pants_03")
			logicHandler.RunConsoleCommandOnPlayer(pid, "player->RemoveSpell SW_BlasterShip")
			isValid = false
		end
		if objectRefId == "sw_planstation" then
			if objectUniqueIndex == nil then isValid = false return end
			logicHandler.RunConsoleCommandOnPlayer(pid, "Player->PositionCell, 3356, 3986, 14999, 268, \"The Outer Rim, Wonder Station\"")
			logicHandler.RunConsoleCommandOnPlayer(pid, "Set TravelState to 0")
			logicHandler.RunConsoleCommandOnPlayer(pid, "player->additem common_pants_03 1")
			logicHandler.RunConsoleCommandOnPlayer(pid, "player->equip common_pants_03")
			logicHandler.RunConsoleCommandOnPlayer(pid, "player->RemoveSpell SW_BlasterShip")
			isValid = false
		end
		if objectRefId == "sw_planstation2" then
			if objectUniqueIndex == nil then isValid = false return end
			logicHandler.RunConsoleCommandOnPlayer(pid, "Player->PositionCell, -162, 3659, 12320, 137, \"The Outer Rim, Abandoned Station\"")
			logicHandler.RunConsoleCommandOnPlayer(pid, "Set TravelState to 0")
			logicHandler.RunConsoleCommandOnPlayer(pid, "player->additem common_pants_03 1")
			logicHandler.RunConsoleCommandOnPlayer(pid, "player->equip common_pants_03")
			logicHandler.RunConsoleCommandOnPlayer(pid, "player->RemoveSpell SW_BlasterShip")
			isValid = false
		end
		if objectRefId == "sw_plantat" then
			if objectUniqueIndex == nil then isValid = false return end
			logicHandler.RunConsoleCommandOnPlayer(pid, "Player->PositionCell, 7538, 7042, 12354, 268, \"Tatooine, Sandriver\"")
			logicHandler.RunConsoleCommandOnPlayer(pid, "Set TravelState to 0")
			logicHandler.RunConsoleCommandOnPlayer(pid, "player->additem common_pants_03 1")
			logicHandler.RunConsoleCommandOnPlayer(pid, "player->equip common_pants_03")
			logicHandler.RunConsoleCommandOnPlayer(pid, "player->RemoveSpell SW_BlasterShip")
			isValid = false
		end
		
		
		-- sith republic
		if objectRefId == "sw_repentr2" then
			if objectUniqueIndex == nil then isValid = false return end
			if nil ~= Players[pid].data.factionRanks["the republic"] then
				logicHandler.RunConsoleCommandOnPlayer(pid, "sw_repentr2->unlock")
			else
				tes3mp.CustomMessageBox(pid, -1, "You do not have access to this area.", "Ok")
				logicHandler.RunConsoleCommandOnPlayer(pid, "sw_repentr2->lock 100")
				isValid = false
			end
		end
		if objectRefId == "sw_repembassdoor" then
			if objectUniqueIndex == nil then isValid = false return end
			if nil ~= Players[pid].data.factionRanks["the sith"] then
				tes3mp.CustomMessageBox(pid, -1, "You do not have access to this area Sith scum.", "Ok")
				isValid = false
			end
		end
		if objectRefId == "sw_sithentr" then
			if objectUniqueIndex == nil then isValid = false return end
			if nil ~= Players[pid].data.factionRanks["the sith"] then
				logicHandler.RunConsoleCommandOnPlayer(pid, "sw_sithentr->unlock")
			else
				tes3mp.CustomMessageBox(pid, -1, "You do not have access to this area.", "Ok")
				logicHandler.RunConsoleCommandOnPlayer(pid, "sw_sithentr->lock 100")
				isValid = false
			end
		end
		if objectRefId == "sw_sithembassydoor" then
			if objectUniqueIndex == nil then isValid = false return end
			if nil ~= Players[pid].data.factionRanks["the republic"] then
				tes3mp.CustomMessageBox(pid, -1, "You do not have access to this area Republic scum.", "Ok")
				isValid = false
			end
		end
		
		-- forest
		if objectRefId == "sw_lafeauxkash" then
			if objectUniqueIndex == nil then isValid = false return end
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
		
		-- water
		if objectRefId == "sw_manadoorfame" then
			if objectUniqueIndex == nil then isValid = false return end
			if Players[pid].data.fame["reputation"] >= 20 then
				logicHandler.RunConsoleCommandOnPlayer(pid, "sw_manadoorfame->unlock")
			else
				tes3mp.CustomMessageBox(pid, -1, "You do not have access to this area.", "Ok")
				logicHandler.RunConsoleCommandOnPlayer(pid, "sw_manadoorfame->lock 100")
				isValid = false
			end
		end
		
		-- desert
		if objectRefId == "sw_sandrivergate" then
			if objectUniqueIndex == nil then isValid = false return end
			local journal = Players[pid].data.journal
			local hasEntry = false
			for index, entry in pairs(journal) do
				if entry["quest"] == "sw_work" and entry["index"] >= 30 then
					hasEntry = true
				end
			end
			if hasEntry then
				logicHandler.RunConsoleCommandOnPlayer(pid, "sw_sandrivergate->unlock")
			else
				tes3mp.CustomMessageBox(pid, -1, "You do not have access to this area.", "Ok")
				logicHandler.RunConsoleCommandOnPlayer(pid, "sw_sandrivergate->lock 100")
				isValid = false
			end
		end
		if objectRefId == "sw_sandrivergate2" then
			if objectUniqueIndex == nil then isValid = false return end
			local journal = Players[pid].data.journal
			local hasEntry = false
			for index, entry in pairs(journal) do
				if entry["quest"] == "sw_work" and entry["index"] >= 30 then
					hasEntry = true
				end
			end
			if hasEntry then
				logicHandler.RunConsoleCommandOnPlayer(pid, "sw_sandrivergate2->unlock")
			else
				tes3mp.CustomMessageBox(pid, -1, "You do not have access to this area.", "Ok")
				logicHandler.RunConsoleCommandOnPlayer(pid, "sw_sandrivergate2->lock 100")
				isValid = false
			end
		end
		if objectRefId == "sw_czerkadoor" then
			if objectUniqueIndex == nil then isValid = false return end
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
				tes3mp.CustomMessageBox(pid, -1, "You do not have access to this area.", "Ok")
				logicHandler.RunConsoleCommandOnPlayer(pid, "sw_czerkadoor->lock 100")
				isValid = false
			end
		end
		if objectRefId == "sw_geno" then
			if objectUniqueIndex == nil then isValid = false return end
			if nil ~= Players[pid].data.factionRanks["sw_genoharadan"] then
				logicHandler.RunConsoleCommandOnPlayer(pid, "sw_geno->unlock")
			end
		end
		if objectRefId == "sw_genotrapdoor" then
			if objectUniqueIndex == nil then isValid = false return end
			logicHandler.RunConsoleCommandOnPlayer(pid, "sw_genotrapdoor->unlock")
		end
		if objectRefId == "sw_tuskenabjam" then
			if objectUniqueIndex == nil then isValid = false return end
			local journal = Players[pid].data.journal
			local hasEntry = false
			for index, entry in pairs(journal) do
				if entry["quest"] == "sw_siddahca" and entry["index"] >= 10 then
					hasEntry = true
				end
			end
			if hasEntry then
				logicHandler.RunConsoleCommandOnPlayer(pid, "sw_tuskenabjam->unlock")
			else
				tes3mp.CustomMessageBox(pid, -1, "You do not have access to this area.", "Ok")
				logicHandler.RunConsoleCommandOnPlayer(pid, "sw_tuskenabjam->lock 100")
				isValid = false
			end
		end
		
		-- city
		if objectRefId == "sw_narelevator" then
			if objectUniqueIndex == nil then isValid = false return end
			local inventory = Players[pid].data.inventory
			if not inventoryHelper.containsItem(inventory, "sw_narkey", -1, -1, "") then
				tes3mp.CustomMessageBox(pid, -1, "You do not have access to this area.", "Ok")
				logicHandler.RunConsoleCommandOnPlayer(pid, "sw_narelevator->lock 100")
				isValid = false
			end
		end
		if objectRefId == "sw_bedkidnap" then
			if objectUniqueIndex == nil then isValid = false return end
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
		if objectRefId == "sw_greatness7" then
			if objectUniqueIndex == nil then isValid = false return end
			local hasSpell = false
			local spellbook = Players[pid].data.spellbook
			for index, item in pairs(spellbook) do
				if spellbook[index] == "soul trap" then
					hasSpell = true
				end
			end
			if not hasSpell then
				tes3mp.CustomMessageBox(pid, -1, "Adding spell soul trap.", "Ok")
				logicHandler.RunConsoleCommandOnPlayer(pid, "player->addSpell \"soul trap\"")
				isValid = false
			end
		end

	-- End New Additions
	eventStatus.validDefaultHandler = isValid
	return eventStatus

	end
end)