-- deleteCharacter for tes3mp 0.7-prerelease. created by malic for JRP Roleplay
-- upon player request, adds .del to character file, effectively deleting it (but admin can still revert)
-- under GPLv3

local deleteCharacter = {}
deleteCharacter.playerFolder = tes3mp.GetModDir() .. "/player/"

table.insert(guiHelper.names, "deleteCharacter_warn")
table.insert(guiHelper.names, "deleteCharacter_entry")
table.insert(guiHelper.names, "deleteCharacter_entry2")
guiHelper.ID = tableHelper.enum(guiHelper.names)

local function ShowDeleteMenu(pid)
	local msg = "Enter your password to delete."
	tes3mp.InputDialog(pid, guiHelper.ID.deleteCharacter_entry, msg, "")
end

local function ShowDeleteConfirmMenu(pid)
	local msg = "Enter your password again to confirm."
	tes3mp.InputDialog(pid, guiHelper.ID.deleteCharacter_entry2, msg, "")
end

local function ShowDeleteWarn(eventStatus,pid)
	local message = color.Yellow .. "WARNING: This menu is for " .. color.Red .. "deleting" .. color.Yellow .. " your character.\nBy entering your password on the next screen, your character will be deleted.\n" .. color.Default .. "If you entered this menu on mistake, simply enter anything besides your password into the text box.\nDeletions can be reverted by the host of the server upon request."
	tes3mp.CustomMessageBox(pid, guiHelper.ID.deleteCharacter_warn, message, "Next")
end

local function DeleteCharacterFunction(accountName,pid)
	if logicHandler.CheckPlayerValidity(pid, pid) then
		tes3mp.LogMessage(2, "[deleteCharacter] " .. Players[pid].data.login.name .. " was kicked.")
		Players[pid]:Kick()
		
		local playerFileName = Players[pid].data.login.name .. ".json"
		
		if tes3mp.DoesFileExist(deleteCharacter.playerFolder .. playerFileName) then
			tes3mp.LogMessage(2, "[deleteCharacter] Found character file.")
			if tes3mp.DoesFileExist(deleteCharacter.playerFolder .. playerFileName .. ".del") then
				-- if other deleted character files detected, use a counter
				local counter = 0
				local freeNumberFound = false
				for i = 1,100 do
					if freeNumberFound == false then
						if tes3mp.DoesFileExist(deleteCharacter.playerFolder .. playerFileName .. ".del" .. i) == false then
							freeNumberFound = true
							tes3mp.LogMessage(2, "[deleteCharacter] Renaming character file")
							local newCharFile = deleteCharacter.playerFolder .. playerFileName .. ".del" .. i
							os.rename (deleteCharacter.playerFolder .. playerFileName, newCharFile)
						end
					end
				end
			else
				-- if no other deleted character files, just give this one a suffix of .del
				tes3mp.LogMessage(2, "[deleteCharacter] Renaming character file")
				local newCharFile = deleteCharacter.playerFolder .. playerFileName .. ".del"
				os.rename (deleteCharacter.playerFolder .. playerFileName, newCharFile)
			end
		end
	else
		tes3mp.LogMessage(2, "[deleteCharacter] Character file wasn't found. Not continuing.")
	end
end

local function CheckGUI(newStatus,pid,idGui,data)
	if idGui == guiHelper.ID.deleteCharacter_entry then
		if data == Players[pid].data.login.password then
			tes3mp.LogMessage(2, "[deleteCharacter] " .. Players[pid].data.login.name .. " entered their password for deletion. Confirming one more time...")
			ShowDeleteConfirmMenu(pid)
		else
			tes3mp.LogMessage(2, "[deleteCharacter] " .. Players[pid].data.login.name .. " exited deletion screen.")
		end
	elseif idGui == guiHelper.ID.deleteCharacter_entry2 then
		if data == Players[pid].data.login.password then
			tes3mp.LogMessage(2, "[deleteCharacter] " .. Players[pid].data.login.name .. " confirmed their password. Deleting...")
			DeleteCharacterFunction(Players[pid].data.login.name,pid)
		end
	end
end

local function ChatListener(pid, cmd)
	if cmd[1] == "deletecharacter" then
		ShowDeleteWarn(eventStatus,pid)
		ShowDeleteMenu(pid)
	end
end

customCommandHooks.registerCommand("deletecharacter", ChatListener)
customEventHooks.registerValidator("OnGUIAction", CheckGUI)
