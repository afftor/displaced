extends Node

var backgrounds = {
	castle = load("res://assets/images/backgrounds/castle.png"),
	castleroom = load('res://assets/images/backgrounds/castleroom.png'),
	desert = load("res://assets/images/backgrounds/desert.png"),
	villageday = load("res://assets/images/backgrounds/villageday.png"),
	villagnight = load("res://assets/images/backgrounds/villagenight.png"),
	dungeon = load("res://assets/images/backgrounds/dungeon.png"),
	dungeon1 = load("res://assets/images/backgrounds/dungeoncircle.png"),
	forge = load("res://assets/images/backgrounds/forge.png"),
	market = load("res://assets/images/backgrounds/market.png"),
	hall = load("res://assets/images/backgrounds/townhall.png"),
	}

var sprites = {
	empty = null,
	Arron = load("res://assets/images/sprites/Arron.png"),
	Rose = load("res://assets/images/sprites/rose.png"),
	goblin = load("res://assets/images/sprites/goblin.png"),
	goblincmerc = load("res://assets/images/sprites/goblinmerc.png"),
	emberhappy = load("res://assets/images/sprites/EmberHappy.png"),
	embershock = load("res://assets/images/sprites/EmberSurprise.png"),
	erica = load("res://assets/images/sprites/erica.png"),
	erica_n = load("res://assets/images/sprites/ericanaked.png")
	}

var portraits = {
	Null = null,
	ArronSmile = load("res://assets/images/portraits/ArronSmile.png"),
	ArronNeutral = load("res://assets/images/portraits/ArronNeutral.png"),
	ArronShock = load("res://assets/images/portraits/ArronShock.png"),
	EmberFriendly = load("res://assets/images/portraits/EmberFriendly.png"),
	EmberHappy = load("res://assets/images/portraits/EmberHappy.png"),
	EMberTired = load("res://assets/images/portraits/EmberTired.png"),
	RoseHappy = load("res://assets/images/portraits/RoseHappy.png"),
	RoseNormal = load("res://assets/images/portraits/RoseNormal.png"),
	RoseSad = load("res://assets/images/portraits/RoseSad.png"),
	RoseSarcastic = load("res://assets/images/portraits/RoseSarcastic.png"),
	RoseShock = load("res://assets/images/portraits/RoseShocked.png"),
	RoseTalk = load("res://assets/images/portraits/RoseTalk.png"),
	ErikaAnnoyed = load("res://assets/images/portraits/ErikaAnnoyed.png"),
	ErikaHappy = load("res://assets/images/portraits/ErikaHappy.png"),
	ErikaNormal = load("res://assets/images/portraits/ErikaNormal.png"),
	goblin = load("res://assets/images/portraits/GoblinPeasant.png"),
	Flak = load("res://assets/images/portraits/GoblinTrader.png"),
	Guard = load("res://assets/images/portraits/guard.png"),
	Lyra = load("res://assets/images/portraits/Lyra.png"),
	NorbertNormal = load("res://assets/images/portraits/NorbertNormal.png"),
	NorbertRage = load("res://assets/images/portraits/NorbertRage.png"),
}

var combatportraits = {
	arron = load("res://assets/images/combatportraits/arronfull.png"),
	rose = load("res://assets/images/combatportraits/rosefull.png"),
	ember = load("res://assets/images/combatportraits/emberfull.png"),
	erika = load("res://assets/images/combatportraits/erikafull.png"),
	
	##enemies
	rat = load("res://assets/images/enemies/RatIcon2.png"),
	ent = load("res://assets/images/enemies/EntIcon.png"),
	}

var circleportraits = {
	arron = load("res://assets/images/combatportraits/arroncircle.png"),
	rose = load("res://assets/images/combatportraits/rosecircle.png"),
	ember = load("res://assets/images/combatportraits/embercircle.png"),
	erika = load("res://assets/images/combatportraits/erikacircle.png"),
	
	
}

var GFX = {
	slash = load("res://assets/images/gfx/slash-effect.png"),
	
}

