extends Node

var TranslationDict = {
	#Buildings
	WORKERMARKET = "Market",
	PURCHASE = "Purchase",
	TASKS = "Tasks",
	UPGRADES = "Upgrades",
	TOWNHALL = "Town Hall",
	FOODCONV = "Food Conversion",
	HARVESTMETAL = "Harvest Ore",
	HARVESTPLANT = "Harvest Plants",
	GOBLINWORKER = "Goblin Worker",
	ELVENWORKER = "Elven Worker",
	
	
	#Materials
	MATERIALWOOD = "Wood",
	MATERIALWOODDESCRIPT = "Sturdy wood for general building and furnishing purposes.",
	WOODADJ = "wooden",
	MATERIALSTONE = "Stone",
	MATERIALSTONEDESCRIPT = "Stone comes in many forms and shapes, but might serve as good building material or even poor instrumentum.",
	STONEADJ = 'stone',
	MATERIALELVENWOOD = "Elven Wood",
	MATERIALELVENWOODDESCRIPT = "An unusual wood with additional magic properties. ",
	ELVENWOODADJ = "Elven",
	MATERIALGOBLINMETAL = "Goblin Metal",
	METARIALGOBLINGMETALDESCRIPT = "Rusty looking metal, still decent for some work. Can be used for a heavy armor. ",
	GOBLINMETALADJ = "Goblin",
	MATERIALELVENMETAL = "Elven Metal",
	METARIALELVENMETALDESCRIPT = "Soft, but strong alloy storing some magic properties. ",
	ELVENMETALADJ = "Elven",
	MATERIALLETHER = "Leather",
	MATERIALLETHERDESCRIPT = "A common animal leather. Can be used for a light armor.",
	LEATHERADJ = "Leather",
	MATERIALBONE = "Bone",
	MATERIALBONEDESCRIPT = "A common animal bone. With right approach can provide some interesting properties. ",
	BONEADJ = "Bone",
	MATERIALCLOTH = "Cloth",
	MATERIALCLOTHDESCRIPT = "A simple cotton fibre for simple clothes. Can be used for cloth armor. ",
	CLOTHADJ = "Cotton",
	
	
	#Items
	WEAPONAXENAME = "Axe",
	WEAPONPICKAXENAME = "Pickaxe",
	WEAPONSWORDNAME = 'Sword',
	WEAPONBOWNAME = "Bow",
	WEAPONSTAFFNAME = "Staff",
	
	
	WEAPONAXEDESCRIPT = 'Axe can be used for wood cutting and combat.',
	WEAPONSWORDDESCRIPT = "Good damage vs unarmored enemies.",
	
	ARMORBASICCHEST = "Chestplate",
	
	#Stats
	DAMAGE = 'Damage',
	ARMOR = 'Armor',
	MDEF = "Magic Armor",
	EVASION = 'Evasion',
	HITRATE = 'Hit Chance',
	HEALTH = 'Health',
	DURABILITY = "Durability",
	DURABILITYMOD = "Dur. Factor",
	ARMORPENETRATION = "Armor Pen.",
	RESISTFIRE = "Fire Res.",
	RESISTEARTH = "Earth Res.",
	RESISTAIR = "Air Res.",
	RESISTWATER = "Water Res.",
	HEALTHPERCENT = "Max. Health",
	MANAPERCENT = "Max. Mana",
	
	
	
	#Item Parts
	TOOLHANDLE = 'Handle',
	BLADE = 'Blade',
	BLUNT = 'Head',
	ROD = 'Knub',
	BOW = 'Bow Limb',
	ARMORBASE = 'Base',
	ARMORPLATE = 'Plate',
	ARMORTRIM = 'Trim',
	JEWELRYGEM = 'Gem',
	
	
	#Material Effects
	NATURAL = "Natural",
	BRITTLE = "Brittle",
	NATURALEFFECTDESCRIPT = "Repairing costs are reduced",
	BRITTELEFFECTDESCRIPT = "Can't be repaired",
	
	#Menu
	NEWGAME = "New Game",
	LOAD = 'Load',
	OPTIONS = 'Options',
	QUIT = 'Quit',
	
	SOUND = "Sound",
	MUSIC = "Music",
	MASTERSOUND = "Master Volume",
	MUTE = "Mute",
	AUDIO = "Audio",
	
	TEXTSPEED = "Text Speed",
	SKIPREAD = "Skip Read",
	
	
	#System
	CONFIRM = "Confirm",
	CANCEL = "Cancel",
	NONE = "None",
	SPEED = "Speed",
	DAY = "Day",
	ENERGY = "Energy",
	TIME = "Time",
	CRAFT = "Craft",
	BLACKSMITH = "Blacksmith",
	REPAIR = "Repair",
	REPAIRALL = "Repair All",
	WORKERNOENERGY = " has no energy left and stopped working.",
	TOOLBROKEN = " has broken.",
	CURRENTTASK = "Current Task",
	REQUIREDMATERIAL = "Required Material",
	REQUIREDMATERIALS = "Required Materials",
	SELECTREPAIR = "Select Item(s) to Repair",
	TOTALPRICE = "Total Price",
	SELECTMATERIAL = "Select materials for all parts.",
	INPOSESSION = "In Possession",
	BASECHANCE = "Base Chance",
	CANTREPAIREFFECT = "This item can't be repaired.",
	NOTENOUGH = "Not enough",
	ITEMCREATED = "Item Created",
	UPGRADEUNLOCKED = "Upgrade Unlocked",
	
	SELECTTOOL = "Select Tool",
	SELECTWORKER = "Select Worker",
	WORKERLIMITREACHER = "Worker Limit Reached: Upgrade Houses to increase",
	TOTALWORKERS = "Total Workers",
	
	TUTORIAL = "Tutorial",
	
	INVENTORY = "Inventory",
	WORKERLIST = "Worker List",
	HEROLIST = "Hero List",
	OPTIONMENU = "Options",
	
	INVENTORYALL = "All items",
	INVENTORYWEAPON = "Weapons",
	INVENTORYARMOR = "Armor",
	INVENTORYMATERIAL = "Materials",
	INVENTORYUSE = "Usables",
	INVENTORYQUEST = "Misc",
	SELLCONFIRM = "Sell",
	RAWPRICE = "Raw Price",
	FOODDESCRIPT = "Food is used to feed workers. ",
	MONEYDESCRIPT = "Money are used to purchase goods and workers.",
	
	#Confirms
	
	LEAVECONFIRM = "Leave to Main Menu? Unsaved progress will be lost. ",
	LOADCONFIRM = "Load this save file?",
	OVERWRITECONFIRM = "Overwrite this save file?",
	DELETECONFIRM = "Delete this save file?",
	STOPTASKCONFIRM = "Stop this job?",
	SLAVEREMOVECONFIRM = "Expel this worker?",
	
	
	#Inbuilt Tooltips
	PAUSEBUTTONTOOLTIP = 'Pause\nHotkey: 1',
	NORMALBUTTONTOOLTIP = 'Normal Speed\nHotkey: 2',
	FASTBUTTONTOOLTIP = 'Fast Speed\nHotkey: 3',
	
	
	#Tasks
	HARVESTWOOD = "Harvest Lumber",
	WOODCUTTINGTASKDESCRIPTION = "Harvest lumber from nearest vegetation",
	
	
	#Names
	ARRON = 'Arron',
	ROSE = 'Rose',
	EMBER = 'Ember',
	GOBLIN = 'Goblin',
	GUARD1 = 'Guard1',
	GUARD2 = 'Guard2',
	GUARD3 = 'Guard3',
	NORBERT = 'Norbert',
	LYRA = "Lyra",
	
	#Skills
	ATTACK = "Attack",
	ATTACKDESCRIPT = "Attacks target with equipped weapon. ",
	
	#Upgrades
	UPGRADEPREVBONUS = "Current bonus",
	UPGRADENEXTBONUS = "Unlock bonus",
	BRIDGEUPGRADE = "Bridge",
	UPGRADEBRIDGEDESCRIPT = "Reinforce the bridge leading to the outer lands. Currently it barely allows locals move in and out, but you are afraid it might prove to dangerous for you to cross as is.",
	UPGRADEBRIDGEBONUS = "Unlocks exploration",
	MINEUPGRADE = "Mine",
	UPGRADEMINEDESCRIPT = "The old mine should still be rich in resources, but will require some work on it. ",
	UPGRADEMINEBONUS = "Allows production of ores.",
	FARMUPGRADE = "Farm",
	UPGRADEFARMDESCRIPT = "The farm allows cultivation of various plant fibers, useful for crafting. ",
	UPGRADEFARMBONUS = "Allows production of cloth",
	HOUSESUPGRADE = "Worker Barracks",
	UPGRADEHOUSESDESCRIPT = "Living quarters for your workers. ",
	UPGRADHOUSEBONUS1 = "Hosts up to 4 workers",
	UPGRADHOUSEBONUS2 = "Hosts up to 8 workers",
	BLACKSMITHUPGRADE = "Blacksmith",
	UPGRADEBLACKSMITHDESCRIPT = "Upgrade of Ember's forge will allow the production of new gear.",
	UPGRADEBLACKSMITHBONUS1 = "Unlocks Headgear",
	UPGRADEBLACKSMITHBONUS2 = "Unlocks footgear",
	LUMBERMILLUPGRADE = "Lumber mill",
	UPGRADELUMBERMILLDESCRIPT = "Improves the quality of Lumber Mill building.",
	UPGRADELUMBERMILLBONUS = "Increases the number of workers allowed in same time to 4. ",
}