-- lastLogin for tes3mp 0.7-prerelease. created by malic for JRP Roleplay
-- Adds custom player variable for last login date and /lastlogin command to check
-- under BSD

-- to-do: update time on disconnect

local function SetLastOnlineTime(eventStatus,pid)
	Players[pid].data.customVariables.lastLogin = os.date('%Y-%m-%d %H:%M:%S')
	Players[pid]:Save()
end

local function ChatListener(pid,cmd)
	if cmd[1] == "lastlogin" and cmd[2] ~= nil then
		local targetName = tableHelper.concatenateFromIndex(cmd, 2)
		local targetPlayer = logicHandler.GetPlayerByName(targetName)

        if targetPlayer == nil then
            tes3mp.SendMessage(pid, color.SlateGray .. "Player " .. targetName .. " does not exist.\n", false)
		elseif targetPlayer.data.customVariables.lastLogin ~= nil then
			tes3mp.SendMessage(pid, color.SlateGray .. targetName .. " was last online " .. targetPlayer.data.customVariables.lastLogin .. ".\n", false)
		else
			tes3mp.SendMessage(pid, color.SlateGray .. targetName .. " has not logged on since this feature was added.\n", false)
		end
	end
end


customEventHooks.registerHandler("OnPlayerAuthentified", SetLastOnlineTime)
customCommandHooks.registerCommand("lastlogin", ChatListener)