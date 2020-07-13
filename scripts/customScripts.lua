-- Load up your custom scripts here! Ideally, your custom scripts will be placed in the scripts/custom folder and then get loaded like this:
--
-- require("custom/yourScript")
--
-- Refer to the Tutorial.md file for information on how to use various event and command hooks in your scripts.

-- https://github.com/tes3mp-scripts
DataManager = require("custom.urm.DataManager.main")
require("custom.urm.QuickKeyCleaner.main")
require("custom.urm.VisualHarvesting.main")

-- https://github.com/Atkana/tes3mp-scripts
kanaRevive = require("custom.atkana.kanaRevive")
kanaBank = require("custom.atkana.kanaBank")
decorateHelp = require("custom.atkana.decorateHelp")
kanaFurniture = require("custom.atkana.kanaFurniture")
kanaHousing = require("custom.atkana.kanaHousing")
CellReset = require("custom.atkana.CellReset")

-- https://github.com/Learwolf/tes3mp-Scripts
require("custom.lear.objectSpawnSystem")
require("custom.lear.modActionMenu")

-- https://gitlab.com/rendeko/tes3mp-scripts/
require("custom.rendeko.jrpStatus")
require("custom.rendeko.lastLogin")
require("custom.rendeko.portableBedroll")

-- https://github.com/Boyos999/Boyos-Tes3mp-Scripts/
require("custom.boyos999.starterEquipment")

-- https://steamcommunity.com/groups/mwmulti/discussions/1/1640926712945926690/
require("custom.adul.time")

-- https://github.com/estoro/starwind
require("custom.estoro.starwind_doors")
require("custom.estoro.starwind_questfix")
require("custom.estoro.starwind_vehicle")