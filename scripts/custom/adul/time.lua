customCommandHooks.registerCommand("at", function(pid, cmd)
	if cmd[2] == nil then
		tes3mp.SendMessage(pid, "You must enter the number of hours to pass.\n", false)
        return false
	end
	
	local hours = math.floor(tonumber(cmd[2]))
	
	if hours < 1 then
		tes3mp.SendMessage(pid, "You must enter a positive integer.\n", false)
        return false
	end
	
	for i = hours,1,-1 do
		if WorldInstance.data.time.hour < 23 then
			WorldInstance.data.time.hour = WorldInstance.data.time.hour + 1
		else
			WorldInstance.data.time.hour = WorldInstance.data.time.hour - 23
			WorldInstance:IncrementDay()
		end
	end
	
	WorldInstance:QuicksaveToDrive()
	WorldInstance:LoadTime(pid, true)
	hourCounter = WorldInstance.data.time.hour
	
	if hours == 1 then
		tes3mp.SendMessage(pid, "Time advanced by " .. hours .. " hour.\n", false)
	else
		tes3mp.SendMessage(pid, "Time advanced by " .. hours .. " hours.\n", false)
	end
end)