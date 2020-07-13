-- portableBedroll for tes3mp 0.7-prerelease. created by malic for JRP Roleplay
-- Players can pick up bedrolls, turning them into a custom record misc item.
-- When placed, they turn back into the vanilla bedroll object.
-- Under GPLv3
-- thanks to aelfkin for fixing pre-placed bedroll picking up

local portableBedroll = {}
local guiID = {}
guiID.pBedrollChoice = 31265

local function createRecord()
        local recordStore = RecordStores["miscellaneous"]
        recordStore.data.permanentRecords["portable_bedroll"] = {
                name = "Bedroll",
                value = 100,
                weight = 10,
                icon = "m\\Misc_Com_Pillow_01.tga",
                model = "f\\Active_De_Bedroll.nif"
        }
        recordStore:Save()
end

local function showPBedMenu(eventStatus,pid)
        tes3mp.CustomMessageBox(pid, guiID.pBedrollChoice, "[Bedroll]", "Pick up;Use;Cancel")
end

local function OnGUIAction(newStatus,pid,idGui,data)
        local cellDescription = tes3mp.GetCell(pid)

        if idGui == guiID.pBedrollChoice then
                if tonumber(data) == 0 then -- pickup
                        tes3mp.LogMessage(2, "[portableBedroll] Bedroll picked up by " .. Players[pid].name)

                        logicHandler.DeleteObjectForEveryone(cellDescription, Players[pid].objectUniqueIndex) -- removing the actual bedroll from the world
                        LoadedCells[cellDescription].data.objectData[Players[pid].objectUniqueIndex] = nil
                        LoadedCells[cellDescription]:Save()

                        inventoryHelper.addItem(Players[pid].data.inventory, "portable_bedroll", 1, -1, -1, "")
                        tes3mp.MessageBox(pid, 866005, "You picked up a bedroll.")

                        tes3mp.ClearInventoryChanges(pid)
                        tes3mp.SetInventoryChangesAction(pid, enumerations.inventory.ADD)
                        tes3mp.AddItemChange(pid, "portable_bedroll", 1, -1, -1, "")
                        tes3mp.SendInventoryChanges(pid)
                elseif tonumber(data) == 1 then -- use
                        logicHandler.ActivateObjectForPlayer(pid,cellDescription,Players[pid].objectUniqueIndex)
                end
        end
end

local function OnObjectActivate(eventStatus,pid,cellDescription,objects,players)
        for _, object in pairs(objects) do
                if object.refId == "active_de_bedroll" then
                        Players[pid].objectUniqueIndex = object.uniqueIndex -- storing the bedroll's index in a variable belonging to the player
                        tes3mp.LogMessage(2, "[portableBedroll] Bedroll activated by " .. Players[pid].name)
                        showPBedMenu(eventStatus,pid)
                        return customEventHooks.makeEventStatus(false, false)
                end
        end
end

local function OnObjectPlace(eventStatus,pid,cellDescription,objects)
        for uniqueIndex, object in pairs(LoadedCells[cellDescription].data.objectData) do
                if object.refId == "portable_bedroll" then
                        tes3mp.LogMessage(2, "[portableBedroll] Bedroll placed by " .. Players[pid].name)
                        logicHandler.CreateObjectAtLocation(cellDescription,object.location,"active_de_bedroll","place")
                        logicHandler.DeleteObjectForEveryone(cellDescription, uniqueIndex)
                        LoadedCells[cellDescription].data.objectData[uniqueIndex] = nil
                        LoadedCells[cellDescription]:Save()
                end
        end
end

local function OnServerPostInit(eventStatus)
        createRecord(request)
end

customEventHooks.registerValidator("OnGUIAction", OnGUIAction)
customEventHooks.registerValidator("OnObjectActivate", OnObjectActivate)
customEventHooks.registerHandler("OnObjectPlace", OnObjectPlace)
customEventHooks.registerHandler("OnServerPostInit", OnServerPostInit)