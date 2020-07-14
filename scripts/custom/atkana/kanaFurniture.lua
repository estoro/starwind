-- kanaFurniture - Release 3.1 - For tes3mp v0.7-alpha
-- REQUIRES: decorateHelp (https://github.com/Atkana/tes3mp-scripts/blob/master/0.7/decorateHelp.lua)
-- Purchase and place an assortment of furniture

-- NOTE FOR SCRIPTS: pname requires the name to be in all LOWERCASE

--[[ INSTALLATION:
1) Save this file as "kanaFurniture.lua" in server/scripts/custom
2) Add [ kanaFurniture = require("custom.kanaFurniture") ] to the top of customScripts.lua

]]

local config = {}
config.whitelist = false --If true, the player must be given permission to place items in the cell that they're in (set using this script's methods, or editing the world.json). Note that this only prevents placement, players can still move/remove items they've placed in the cell.
config.sellbackModifier = 0.75 -- The base cost that an item is multiplied by when selling the items back (0.75 is 75%)

--GUI Ids used for the script's GUIs. Shouldn't have to be edited.
config.MainGUI = 31363
config.BuyGUI = 31364
config.InventoryGUI = 31365
config.ViewGUI = 31366
config.InventoryOptionsGUI = 31367
config.ViewOptionsGUI = 31368

------------
--Indexed table of all available furniture. refIds should be in all lowercase
--Best resource I could find online was this: http://tamriel-rebuilt.org/content/resource-guide-models-morrowind (note, items that begin with TR are part of Tamriel Rebuilt, not basic Morrowind, and it certainly doesn't list all the furniture items)

local furnitureData = {
-- activator
{name = "Bed", refId = "sw_bed", price = 50},
{name = "Terminal", refId = "sw_terminal", price = 50},
{name = "Armor Sign", refId = "sw_signarmor", price = 50},
{name = "Cantina Sign", refId = "sw_signcantina", price = 50},
{name = "Hunter Sign", refId = "sw_signhunter", price = 50},
{name = "Kashyyk App Sign", refId = "sw_signkashyykapp", price = 50},
{name = "Medical Sign", refId = "sw_signmedical", price = 50},
{name = "Medical Sign 2", refId = "sw_signmedical2", price = 50},
{name = "Medical Sign 3", refId = "sw_signmedical3", price = 50},
{name = "Nar Armor Sign", refId = "sw_signnararmor", price = 50},
{name = "Rodian Sign", refId = "sw_signrodian", price = 50},
-- container
{name = "Chest", refId = "sw_chestrandom", price = 50},
{name = "Crate", refId = "sw_crate", price = 50},
{name = "Locker", refId = "sw_locker", price = 50},
{name = "Flora Dewback Cacti", refId = "sw_flora_dunecact", price = 50},
{name = "Flora Razor Moss", refId = "sw_flora_razormoss", price = 50},
{name = "Flora Gaart", refId = "sw_floragaart", price = 50},
{name = "Flora Jenstem", refId = "sw_florajenstem", price = 50},
{name = "Flora Kinnat", refId = "sw_florakinnat", price = 50},
{name = "Flora Mushbloom", refId = "sw_floramushbloom", price = 50},
{name = "Flora Glowing Nidus", refId = "sw_floranidus", price = 50},
{name = "Flora Blue Papaver", refId = "sw_florapapaver", price = 50},
{name = "Flora Rrwii", refId = "sw_florarrwii", price = 50},
{name = "Flora Saava", refId = "sw_florasaava", price = 50},
-- static
{name = "Cantina Floor", refId = "sw_cantinafloor", price = 50},
{name = "Cantina Table", refId = "sw_cantinatable", price = 50},
{name = "Cantina Table Glow", refId = "sw_cantinatableglow", price = 50},
{name = "Czerka Console Desk", refId = "sw_czerkaconsoledesk", price = 50},
{name = "Czerka Holo", refId = "sw_czerkaholo", price = 50},
{name = "Czerka Poster", refId = "sw_czerkaposter", price = 50},
{name = "Arena Sign", refId = "sw_ext_signarena", price = 50},
{name = "Droid Sign", refId = "sw_ext_signdroid", price = 50},
{name = "Barrel", refId = "sw_furnmanabarrel", price = 50},
{name = "Double Bench", refId = "sw_furndoublebench", price = 50},
{name = "Bench", refId = "sw_furnmanabench", price = 50},
{name = "Chair", refId = "sw_furnmanachair", price = 50},
{name = "Lamp", refId = "sw_furnmanalamp", price = 50},
{name = "Plant Pot", refId = "sw_furnmanapotted", price = 50},
{name = "Table", refId = "sw_furnmanatable", price = 50},
{name = "Monitor", refId = "sw_furnmonitor", price = 50},
{name = "Red Monitor", refId = "sw_furnmonitorred", price = 50},
{name = "Supply Lock", refId = "sw_furnsupplylock", price = 50},
{name = "Table Glow", refId = "sw_furntableglow", price = 50},
{name = "Ground Table", refId = "sw_in_tableground", price = 50},
{name = "Blue Crystal", refId = "sw_int_bluecrystal1", price = 50},
{name = "Green Crystal", refId = "sw_int_greencrystal1", price = 50},
{name = "Red Crystal", refId = "sw_int_redcrystal1", price = 50},
{name = "Yellow Crystal", refId = "sw_int_yellowcrystal1", price = 50},
{name = "Overhead Light", refId = "sw_intlightoverhead", price = 50},
{name = "Reception Desk", refId = "sw_intmanadesk", price = 50},
{name = "Kiosk", refId = "sw_kiosk1", price = 50},
{name = "Long Light", refId = "sw_lightlong", price = 50},
{name = "Large Barrel", refId = "sw_manakoltobarrel", price = 50},
{name = "Med Tank", refId = "sw_manakoltomedtank", price = 50},
{name = "Pipes", refId = "sw_manakoltopipes", price = 50},
{name = "Production 1", refId = "sw_manakoltopro1", price = 50},
{name = "Producation 2", refId = "sw_manakoltopro2", price = 50},
{name = "Tank", refId = "sw_manakoltotank", price = 50},
{name = "Wire", refId = "sw_narwires", price = 50},
{name = "Medium Pipe", refId = "sw_pipemed", price = 50},
{name = "Short Pipe", refId = "sw_pipeshort", price = 50},
{name = "Short Straight Pipe", refId = "sw_pipestraightshort", price = 50},
{name = "Vent", refId = "sw_vent", price = 50}
}
-- {name = "name", refId = "ref_id", price = 50},

------------
decorateHelp = require("custom.atkana.decorateHelp")
tableHelper = require("tableHelper")

local Methods = {}
--Forward declarations:
local showMainGUI, showBuyGUI, showInventoryGUI, showViewGUI, showInventoryOptionsGUI, showViewOptionsGUI
------------
local playerBuyOptions = {} --Used to store the lists of items each player is offered so we know what they're trying to buy
local playerInventoryOptions = {} --
local playerInventoryChoice = {}
local playerViewOptions = {} -- [pname = [index = [refIndex = x, refId = y] ]
local playerViewChoice = {}

-- ===========
--  DATA ACCESS
-- ===========

local function getFurnitureInventoryTable()
	return WorldInstance.data.customVariables.kanaFurniture.inventories
end

local function getPermissionsTable()
	return WorldInstance.data.customVariables.kanaFurniture.permissions
end

local function getPlacedTable()
	return WorldInstance.data.customVariables.kanaFurniture.placed
end

local function addPlaced(refIndex, cell, pname, refId, save)
	local placed = getPlacedTable()
	
	if not placed[cell] then
		placed[cell] = {}
	end
	
	placed[cell][refIndex] = {owner = pname, refId = refId}
	
	if save then
		WorldInstance:Save()
	end
end

local function removePlaced(refIndex, cell, save)
	local placed = getPlacedTable()
	
	placed[cell][refIndex] = nil
	
	if save then
		WorldInstance:Save()
	end
end

local function getPlaced(cell)
	local placed = getPlacedTable()
	
	if placed[cell] then
		return placed[cell]
	else
		return false
	end
end

local function addFurnitureItem(pname, refId, count, save)
	local fInventories = getFurnitureInventoryTable()
	
	if fInventories[pname] == nil then
		fInventories[pname] = {}
	end
	
	fInventories[pname][refId] = (fInventories[pname][refId] or 0) + (count or 1)
	
	--Remove the entry if the count is 0 or less (so we can use this function to remove items, too!)
	if fInventories[pname][refId] <= 0 then
		fInventories[pname][refId] = nil
	end
	
	if save then
		WorldInstance:Save()
	end
end

Methods.OnServerPostInit = function()
	--Create the script's required data if it doesn't exits
	if WorldInstance.data.customVariables.kanaFurniture == nil then
		WorldInstance.data.customVariables.kanaFurniture = {}
		WorldInstance.data.customVariables.kanaFurniture.placed = {}
		WorldInstance.data.customVariables.kanaFurniture.permissions = {}
		WorldInstance.data.customVariables.kanaFurniture.inventories = {}
		WorldInstance:Save()
	end
	
	--Slight Hack for updating pnames to their new values. In release 1, the script stored player names as their login names, in release 2 it stores them as their all lowercase names.
	local placed = getPlacedTable()
	for cell, v in pairs(placed) do
		for refIndex, v in pairs(placed[cell]) do
			placed[cell][refIndex].owner = string.lower(placed[cell][refIndex].owner)
		end
	end
	local permissions = getPermissionsTable()
		
	for cell, v in pairs(permissions) do
		local newNames = {}
		
		for pname, v in pairs(permissions[cell]) do
			table.insert(newNames, string.lower(pname))
		end
		
		permissions[cell] = {}
		for k, newName in pairs(newNames) do
			permissions[cell][newName] = true
		end
	end
	
	local inventories = getFurnitureInventoryTable()
	local newInventories = {}
	for pname, invData in pairs(inventories) do
		newInventories[string.lower(pname)] = invData
	end
	
	WorldInstance.data.customVariables.kanaFurniture.inventories = newInventories
	
	WorldInstance:Save()
end

-------------------------

local function getSellValue(baseValue)
	return math.max(0, math.floor(baseValue * config.sellbackModifier))
end

local function getName(pid)
	--return Players[pid].data.login.name
	--Release 2 change: Now uses all lowercase name for storage
	return string.lower(Players[pid].accountName)
end

local function getObject(refIndex, cell)
	if refIndex == nil then
		return false
	end
	
	if not LoadedCells[cell] then
		--TODO: Should ideally be temporary
		logicHandler.LoadCell(cell)
	end

	if LoadedCells[cell]:ContainsObject(refIndex)  then 
		return LoadedCells[cell].data.objectData[refIndex]
	else
		return false
	end	
end

--Returns the amount of gold in a player's inventory
local function getPlayerGold(pid)
	local goldLoc = inventoryHelper.getItemIndex(Players[pid].data.inventory, "gold_001", -1)
	
	if goldLoc then
		return Players[pid].data.inventory[goldLoc].count
	else
		return 0
	end
end

local function addGold(pid, amount)
	--TODO: Add functionality to add gold to offline player's inventories, too
	local goldLoc = inventoryHelper.getItemIndex(Players[pid].data.inventory, "gold_001", -1)
	
	if goldLoc then
		Players[pid].data.inventory[goldLoc].count = Players[pid].data.inventory[goldLoc].count + amount
	else
		table.insert(Players[pid].data.inventory, {refId = "gold_001", count = amount, charge = -1})
	end
	
	Players[pid]:Save()
	Players[pid]:LoadInventory()
	Players[pid]:LoadEquipment()
end

local function getFurnitureData(refId)
	local location = tableHelper.getIndexByNestedKeyValue(furnitureData, "refId", refId)
	if location then
		return furnitureData[location], location
	else
		return false
	end
end

local function hasPlacePermission(pname, cell)
	local perms = getPermissionsTable()
	
	if not config.whitelist then
		return true
	end
	
	if perms[cell] then
		if perms[cell]["all"] or perms[cell][pname] then
			return true
		else
			return false
		end
	else
		--There's not even any data for that cell
		return false
	end
end

local function getPlayerFurnitureInventory(pid)
	local invlist = getFurnitureInventoryTable()
	local pname = getName(pid)
	
	if invlist[pname] == nil then
		invlist[pname] = {}
		WorldInstance:Save()
	end
	
	return invlist[pname]
end

local function getSortedPlayerFurnitureInventory(pid)
	local inv = getPlayerFurnitureInventory(pid)
	local sorted = {}
	
	for refId, amount in pairs(inv) do
		local name = getFurnitureData(refId).name
		table.insert(sorted, {name = name, count = amount, refId = refId})
	end
	
	return sorted
end

local function placeFurniture(refId, loc, cell)
	local useTempLoad = false
	
	local location = {
		posX = loc.x, posY = loc.y, posZ = loc.z,
		rotX = 0, rotY = 0, rotZ = 0
	}
	
	if not LoadedCells[cell] then
		logicHandler.LoadCell(cell)
		useTempLoad = true
	end

	local uniqueIndex = logicHandler.CreateObjectAtLocation(cell, location, refId, "place")
	
	if useTempLoad then
		logicHandler.UnloadCell(cell)
	end
	
	return uniqueIndex
end

local function removeFurniture(refIndex, cell)
	--If for some reason the cell isn't loaded, load it. Causes a bit of spam in the server log, but that can't really be helped.
	local useTempLoad = false
	
	if LoadedCells[cell] == nil then
		logicHandler.LoadCell(cell)
		useTempLoad = true
	end
	
	if LoadedCells[cell]:ContainsObject(refIndex) and not tableHelper.containsValue(LoadedCells[cell].data.packets.delete, refIndex) then --Shouldn't ever have a delete packet, but it's worth checking anyway
		--Delete the object for all the players currently online
		logicHandler.DeleteObjectForEveryone(cell, refIndex)
		
		LoadedCells[cell]:DeleteObjectData(refIndex)
		LoadedCells[cell]:Save()
		--Removing the object from the placed list will be done elsewhere
	end
	
	if useTempLoad then
		logicHandler.UnloadCell(cell)
	end
end

local function getAvailableFurnitureStock(pid)
	--In the future this can be used to customise what items are available for a particular player, like making certain items only available for things like their race, class, level, their factions, or the quests they've completed. For now, however, everything in furnitureData is available :P
	
	local options = {}
	
	for i = 1, #furnitureData do
		table.insert(options, furnitureData[i])
	end
	
	return options
end

--If the player has placed items in the cell, returns an indexed table containing all the refIndexes of furniture that they have placed.
local function getPlayerPlacedInCell(pname, cell)
	local cellPlaced = getPlaced(cell)
	
	if not cellPlaced then
		-- Nobody has placed items in this cell
		return false
	end
	
	local list = {}
	for refIndex, data in pairs(cellPlaced) do
		if data.owner == pname then
			table.insert(list, refIndex)
		end
	end
	
	if #list > 0 then
		return list
	else
		--The player hasn't placed any items in this cell
		return false
	end
end

local function addFurnitureData(data)
	--Check the furniture doesn't already have an entry, if it does, overwrite it
	--TODO: Should probably check that the data is valid
	local fdata, loc = getFurnitureData(data.refId)
	
	if fdata then
		furnitureData[loc] = data
	else
		table.insert(furnitureData, data)
	end
end

Methods.AddFurnitureData = function(data)
	addFurnitureData(data)
end
--NOTE: Both AddPermission and RemovePermission use pname, rather than pid
Methods.AddPermission = function(pname, cell)
	local perms = getPermissionsTable()
	
	if not perms[cell] then
		perms[cell] = {}
	end
	
	perms[cell][pname] = true
	WorldInstance:Save()
end

Methods.RemovePermission = function(pname, cell)
	local perms = getPermissionsTable()
	
	if not perms[cell] then
		return
	end
	
	perms[cell][pname] = nil
	
	WorldInstance:Save()
end

Methods.RemoveAllPermissions = function(cell)
	local perms = getPermissionsTable()
	
	perms[cell] = nil
	WorldInstance:Save()
end

Methods.RemoveAllPlayerFurnitureInCell = function(pname, cell, returnToOwner)
	local placed = getPlacedTable()
	local cInfo = placed[cell] or {}
	
	for refIndex, info in pairs(cInfo) do
		if info.owner == pname then
			if returnToOwner then
				addFurnitureItem(info.owner, info.refId, 1, false)
			end
			removeFurniture(refIndex, cell)
			removePlaced(refIndex, cell, false)
		end
	end
	WorldInstance:Save()
end

Methods.RemoveAllFurnitureInCell = function(cell, returnToOwner)
	local placed = getPlacedTable()
	local cInfo = placed[cell] or {}
	
	for refIndex, info in pairs(cInfo) do
		if returnToOwner then
			addFurnitureItem(info.owner, info.refId, 1, false)
		end
		removeFurniture(refIndex, cell)
		removePlaced(refIndex, cell, false)
	end
	WorldInstance:Save()
end

--Change the ownership of the specified furniture object (via refIndex) to another character's (playerToName). If playerCurrentName is false, the owner will be changed to the new one regardless of who owned it first.
Methods.TransferOwnership = function(refIndex, cell, playerCurrentName, playerToName, save)
	local placed = getPlacedTable()
	
	if placed[cell] and placed[cell][refIndex] and (placed[cell][refIndex].owner == playerCurrentName or not playerCurrentName) then
		placed[cell][refIndex].owner = playerToName
	end
	
	if save then
		WorldInstance:Save()
	end
	
	--Unset the current player's selected item, just in case they had that furniture as their selected item
	if playerCurrentName and logicHandler.IsPlayerNameLoggedIn(playerCurrentName) then
		decorateHelp.SetSelectedObject(logicHandler.GetPlayerByName(playerCurrentName).pid, "")
	end
end

--Same as TransferOwnership, but for all items in a given cell
Methods.TransferAllOwnership = function(cell, playerCurrentName, playerToName, save)
	local placed = getPlacedTable()
	
	if not placed[cell] then
		return false
	end
	
	for refIndex, info in pairs(placed[cell]) do
		if not playerCurrentName or info.owner == playerCurrentName then
			placed[cell][refIndex].owner = playerToName
		end
	end
	
	if save then
		WorldInstance:Save()
	end
	
	--Unset the current player's selected item, just in case they had any of the furniture as their selected item
	if playerCurrentName and logicHandler.IsPlayerNameLoggedIn(playerCurrentName) then
		decorateHelp.SetSelectedObject(logicHandler.GetPlayerByName(playerCurrentName).pid, "")
	end
end

--New Release 2 Methods:
Methods.GetSellBackPrice = function(value)
	return getSellValue(value)
end

Methods.GetFurnitureDataByRefId = function(refId)
	return getFurnitureData(refId)
end

Methods.GetPlacedInCell = function(cell)
	return getPlaced(cell)
end


-- ====
--  GUI
-- ====

-- VIEW (OPTIONS)
showViewOptionsGUI = function(pid, loc)
	local message = ""
	local choice = playerViewOptions[getName(pid)][loc]
	local fdata = getFurnitureData(choice.refId)
	
	message = message .. "Item Name: " .. fdata.name .. " (RefIndex: " .. choice.refIndex .. "). Price: " .. fdata.price .. " (Sell price: " .. getSellValue(fdata.price) .. ")"
	
	playerViewChoice[getName(pid)] = choice
	tes3mp.CustomMessageBox(pid, config.ViewOptionsGUI, message, "Select;Put Away;Sell;Close")
end

local function onViewOptionSelect(pid)
	local pname = getName(pid)
	local choice = playerViewChoice[pname]
	local cell = tes3mp.GetCell(pid)
	
	if getObject(choice.refIndex, cell) then
		decorateHelp.SetSelectedObject(pid, choice.refIndex)
		tes3mp.MessageBox(pid, -1, "Object selected, use /dh to move.")
	else
		tes3mp.MessageBox(pid, -1, "The object seems to have been removed.")
	end
end

local function onViewOptionPutAway(pid)
	local pname = getName(pid)
	local choice = playerViewChoice[pname]
	local cell = tes3mp.GetCell(pid)
	
	if getObject(choice.refIndex, cell) then
		removeFurniture(choice.refIndex, cell)
		removePlaced(choice.refIndex, cell, true)
		
		addFurnitureItem(pname, choice.refId, 1, true)
		tes3mp.MessageBox(pid, -1, getFurnitureData(choice.refId).name .. " has been added to your furniture inventory.")
	else
		tes3mp.MessageBox(pid, -1, "The object seems to have been removed.")
	end
end

local function onViewOptionSell(pid)
	local pname = getName(pid)
	local choice = playerViewChoice[pname]
	local cell = tes3mp.GetCell(pid)
	
	if getObject(choice.refIndex, cell) then
		local saleGold = getSellValue(getFurnitureData(choice.refId).price)
		
		--Add gold to inventory
		addGold(pid, saleGold)
		
		--Remove the item from the cell
		removeFurniture(choice.refIndex, cell)
		removePlaced(choice.refIndex, cell, true)
		
		--Inform the player
		tes3mp.MessageBox(pid, -1, saleGold .. " Gold has been added to your inventory and the furniture has been removed from the cell.")
	else
		tes3mp.MessageBox(pid, -1, "The object seems to have been removed.")
	end
end

-- VIEW (MAIN)
showViewGUI = function(pid)
	local pname = getName(pid)
	local cell = tes3mp.GetCell(pid)
	local options = getPlayerPlacedInCell(pname, cell)
	
	local list = "* CLOSE *\n"
	local newOptions = {}
	
	if options and #options > 0 then
		for i = 1, #options do
			--Make sure the object still exists, and get its data
			local object = getObject(options[i], cell)
			
			if object then
				local furnData = getFurnitureData(object.refId)
				
				list = list .. furnData.name .. " (at " .. math.floor(object.location.posX + 0.5) .. ", "  ..  math.floor(object.location.posY + 0.5) .. ", " .. math.floor(object.location.posZ + 0.5) .. ")"
				if not(i == #options) then
					list = list .. "\n"
				end
				
				table.insert(newOptions, {refIndex = options[i], refId = object.refId})
			end
		end
	end
	
	playerViewOptions[pname] = newOptions
	tes3mp.ListBox(pid, config.ViewGUI, "Select a piece of furniture you've placed in this cell. Note: The contents of containers will be lost if removed.", list)
	--getPlayerPlacedInCell(pname, cell)
end

local function onViewChoice(pid, loc)
	showViewOptionsGUI(pid, loc)
end

-- INVENTORY (OPTIONS)
showInventoryOptionsGUI = function(pid, loc)
	local message = ""
	local choice = playerInventoryOptions[getName(pid)][loc]
	local fdata = getFurnitureData(choice.refId)
	
	message = message .. "Item Name: " .. choice.name .. ". Price: " .. fdata.price .. " (Sell price: " .. getSellValue(fdata.price) .. ")"
	
	playerInventoryChoice[getName(pid)] = choice
	tes3mp.CustomMessageBox(pid, config.InventoryOptionsGUI, message, "Place;Sell;Close")
end

local function onInventoryOptionPlace(pid)
	local pname = getName(pid)
	local curCell = tes3mp.GetCell(pid)
	local choice = playerInventoryChoice[pname]
	
	--First check the player is allowed to place items where they are currently
	if config.whitelist and not hasPlacePermission(pname, curCell) then
		--Player isn't allowed
		tes3mp.MessageBox(pid, -1, "You don't have permission to place furniture here.")
		return false
	end
	
	--Remove 1 instance of the item from the player's inventory
	addFurnitureItem(pname, choice.refId, -1, true)
	
	--Place the furniture in the world
	local pPos = {x = tes3mp.GetPosX(pid), y = tes3mp.GetPosY(pid), z = tes3mp.GetPosZ(pid)}
	local furnRefIndex = placeFurniture(choice.refId, pPos, curCell)
	
	--Update the database of all placed furniture
	addPlaced(furnRefIndex, curCell, pname, choice.refId, true)
	--Set the placed item as the player's active object for decorateHelp to use
	decorateHelp.SetSelectedObject(pid, furnRefIndex)
end

local function onInventoryOptionSell(pid)
	local pname = getName(pid)
	local choice = playerInventoryChoice[pname]
	
	local saleGold = getSellValue(getFurnitureData(choice.refId).price)
	
	--Add gold to inventory
	addGold(pid, saleGold)
	
	--Remove 1 instance of the item from the player's inventory
	addFurnitureItem(pname, choice.refId, -1, true)
	
	--Inform the player
	tes3mp.MessageBox(pid, -1, saleGold .. " Gold has been added to your inventory.")
end

-- INVENTORY (MAIN)
showInventoryGUI = function(pid)
	local options = getSortedPlayerFurnitureInventory(pid)
	local list = "* CLOSE *\n"
	
	for i = 1, #options do
		list = list .. options[i].name .. " (" .. options[i].count .. ")"
		if not(i == #options) then
			list = list .. "\n"
		end
	end
	
	playerInventoryOptions[getName(pid)] = options
	tes3mp.ListBox(pid, config.InventoryGUI, "Select the piece of furniture from your inventory that you wish to do something with", list)
end

local function onInventoryChoice(pid, loc)
	showInventoryOptionsGUI(pid, loc)
end

-- BUY (MAIN)
showBuyGUI = function(pid)
	local options = getAvailableFurnitureStock(pid)
	local list = "* CLOSE *\n"
	
	for i = 1, #options do
		list = list .. options[i].name .. " (" .. options[i].price .. " Gold)"
		if not(i == #options) then
			list = list .. "\n"
		end
	end
	
	playerBuyOptions[getName(pid)] = options
	tes3mp.ListBox(pid, config.BuyGUI, "Select an item you wish to buy", list)
end

local function onBuyChoice(pid, loc)
	local pgold = getPlayerGold(pid)
	local choice = playerBuyOptions[getName(pid)][loc]
	
	if pgold < choice.price then
		tes3mp.MessageBox(pid, -1, "You can't afford to buy a " .. choice.name .. ".")
		return false
	end
	
	addGold(pid, -choice.price)
	addFurnitureItem(getName(pid), choice.refId, 1, true)
	
	tes3mp.MessageBox(pid, -1, "A " .. choice.name .. " has been added to your furniture inventory.")
	return true
end

-- MAIN
showMainGUI = function(pid)
	local message = "Welcome to the furniture menu. Use 'Buy' to purchase furniture for your furniture inventory, 'Inventory' to view the furniture items you own, 'View' to display a list of all the furniture that you own in the cell you're currently in.\n\nNote: The current version of tes3mp doesn't really like when lots of items are added to a cell, so try to restrain yourself from complete home renovations."
	tes3mp.CustomMessageBox(pid, config.MainGUI, message, "Buy;Inventory;View;Close")
end

local function onMainBuy(pid)
	showBuyGUI(pid)
end

local function onMainInventory(pid)
	showInventoryGUI(pid)
end

local function onMainView(pid)
	showViewGUI(pid)
end

-- GENERAL
Methods.OnGUIAction = function(pid, idGui, data)
	
	if idGui == config.MainGUI then -- Main
		if tonumber(data) == 0 then --Buy
			onMainBuy(pid)
			return true
		elseif tonumber(data) == 1 then -- Inventory
			onMainInventory(pid)
			return true
		elseif tonumber(data) == 2 then -- View
			onMainView(pid)
			return true
		elseif tonumber(data) == 3 then -- Close
			--Do nothing
			return true
		end
	elseif idGui == config.BuyGUI then -- Buy
		if tonumber(data) == 0 or tonumber(data) == 18446744073709551615 then --Close/Nothing Selected
			--Do nothing
			return true
		else
			onBuyChoice(pid, tonumber(data))
			return true
		end
	elseif idGui == config.InventoryGUI then --Inventory main
		if tonumber(data) == 0 or tonumber(data) == 18446744073709551615 then --Close/Nothing Selected
			--Do nothing
			return true
		else
			onInventoryChoice(pid, tonumber(data))
			return true
		end
	elseif idGui == config.InventoryOptionsGUI then --Inventory options
		if tonumber(data) == 0 then --Place
			onInventoryOptionPlace(pid)
			return true
		elseif tonumber(data) == 1 then --Sell
			onInventoryOptionSell(pid)
			return true
		else --Close
			--Do nothing
			return true
		end
	elseif idGui == config.ViewGUI then --View
		if tonumber(data) == 0 or tonumber(data) == 18446744073709551615 then --Close/Nothing Selected
			--Do nothing
			return true
		else
			onViewChoice(pid, tonumber(data))
			return true
		end
	elseif idGui == config.ViewOptionsGUI then -- View Options
		if tonumber(data) == 0 then --Select
			onViewOptionSelect(pid)
			return true
		elseif tonumber(data) == 1 then --Put away
			onViewOptionPutAway(pid)
		elseif tonumber(data) == 2 then --Sell
			onViewOptionSell(pid)
		else --Close
			--Do nothing
			return true
		end
	end
end

Methods.OnCommand = function(pid)
	showMainGUI(pid)
end

customCommandHooks.registerCommand("furniture", Methods.OnCommand)
customCommandHooks.registerCommand("furn", Methods.OnCommand)

customEventHooks.registerHandler("OnGUIAction", function(eventStatus, pid, idGui, data)
	if Methods.OnGUIAction(pid, idGui, data) then
		return
	end
end)

customEventHooks.registerHandler("OnServerPostInit", function(eventStatus)
	Methods.OnServerPostInit()
end)

return Methods