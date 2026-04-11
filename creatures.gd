extends Resource
class_name Creatures

const attack_list =  ["Defend", "Dust Cloud", "Flare", "Growl", "Gust", "Leer", "Peck", "Scratch", "Splash", "Tackle", "Tremor", "Zap"]
const stamina_cost = [ 0,        1,            6,       1,       6,      1,      3,      3,         6,        3,        6,        6   ]

const data = {
	0: {
		"name": "TestMonster",
		"edevicedescriptor": "Test", 
		"edeviceid": 00,
		"edeviceentry": "This is a test monster used for debugging. It should not be seen in the final release",
		"edeviceheight": 1.0,
		"edeviceweight": 10.0,
		"basehp": 30,
		"baseat": 30,
		"basedf": 30,
		"basesp": 30,
		"basest": 30,
		"basexp": 50,
		"captureability": .5,
		"attacks": ["Tackle", "", "Leer"],
		"element": 0
	},
	1: {
		"name": "Dracospark",
		"edevicedescriptor": "Drake", 
		"edeviceid": 01,
		"edeviceentry": "Dracosparks can be chaotic, but are fiercely protective of what they hold dear.",
		"edeviceheight": .6,
		"edeviceweight": 9.6,
		"basehp": 30,
		"baseat": 40,
		"basedf": 20,
		"basesp": 40,
		"basest": 20,
		"basexp": 35,
		"captureability": .45,
		"attacks": ["Scratch", "", "Growl", "", "", "Flare"],
		"element": 1
	},
	4: {
		"name": "Mizukoi",
		"edevicedescriptor": "Fish", 
		"edeviceid": 04,
		"edeviceentry": "Mizukoi are very common Elecree, able to be found in every river in Nio.",
		"edeviceheight": .3,
		"edeviceweight": 1.5,
		"basehp": 30,
		"baseat": 25,
		"basedf": 25,
		"basesp": 35,
		"basest": 35,
		"basexp": 35,
		"captureability": .45,
		"attacks": ["Tackle", "", "Leer", "", "", "Splash"],
		"element": 2
	},
	7: {
		"name": "Watty",
		"edevicedescriptor": "Static", 
		"edeviceid": 07,
		"edeviceentry": "When a Watty is scared, it will jump high and give an electric shock.",
		"edeviceheight": .15,
		"edeviceweight": .5,
		"basehp": 30,
		"baseat": 40,
		"basedf": 20,
		"basesp": 40,
		"basest": 20,
		"basexp": 35,
		"captureability": .45,
		"attacks": ["Scratch", "", "Leer", "", "", "Zap"],
		"element": 3
	},
	10: {
		"name": "Earthle",
		"edevicedescriptor": "Tortoise", 
		"edeviceid": 10,
		"edeviceentry": "Earthles send tremors through the ground to ward off threats.",
		"edeviceheight": .75,
		"edeviceweight": 10.0,
		"basehp": 40,
		"baseat": 30,
		"basedf": 40,
		"basesp": 20,
		"basest": 20,
		"basexp": 35,
		"captureability": .45,
		"attacks": ["Tackle", "", "Growl", "", "", "Tremor"],
		"element": 4
	},
	13: {
		"name": "Futori",
		"edevicedescriptor": "Sparrow", 
		"edeviceid": 13,
		"edeviceentry": "Futori, known for their outstanding stamina, can fly to the peak of Pear Mountain.",
		"edeviceheight": .3,
		"edeviceweight": 1.5,
		"basehp": 30,
		"baseat": 20,
		"basedf": 20,
		"basesp": 40,
		"basest": 40,
		"basexp": 35,
		"captureability": .45,
		"attacks": ["Peck", "", "Leer", "", "", "Gust"],
		"element": 5
	},
	16: {
		"name": "Yanemi",
		"edevicedescriptor": "Vole", 
		"edeviceid": 16,
		"edeviceentry": "Yanemi can be found hiding in Nioan grasses. When one gets scared, it kicks up dust.",
		"edeviceheight": .2,
		"edeviceweight": .75,
		"basehp": 30,
		"baseat": 25,
		"basedf": 20,
		"basesp": 30,
		"basest": 25,
		"basexp": 25,
		"captureability": .5,
		"attacks": ["Tackle", "", "Dust Cloud"],
		"element": 0
	},
	25: {
		"name": "Sparkel",
		"edevicedescriptor": "Squirrel", 
		"edeviceid": 25,
		"edeviceentry": "Rumor has it that new Battlers who are late to receive their first Elecree get a Sparkel.",
		"edeviceheight": .65,
		"edeviceweight": 7.5,
		"basehp": 33,
		"baseat": 35,
		"basedf": 30,
		"basesp": 40,
		"basest": 30,
		"basexp": 29,
		"captureability": .3,
		"attacks": ["Tackle", "", "Zap", "Growl"],
		"element": 3
	}
}

const element_names = {
	0: "NEUTRAL",
	1: "FIRE",
	2: "WATER",
	3: "THUNDER",
	4: "EARTH",
	5: "WIND",
	8: "STEAM",
	9: "PLASMA",
	10: "LAVA",
	11: "SOLAR",
	15: "STORM",
	16: "WOOD",
	17: "ICE",
	22: "EXPLODE",
	23: "MAGNET",
	29: "CRYSTAL"
}

const element_names_short = {
	0: "NEUT",
	1: "FIRE",
	2: "WATR",
	3: "TNDR",
	4: "ERTH",
	5: "WIND",
	8: "STEA",
	9: "PLSM",
	10: "LAVA",
	11: "SOLR",
	15: "STRM",
	16: "WOOD",
	17: "ICE",
	22: "XPLD",
	23: "MGNT",
	29: "CRYS"
}

func _ready():
	print("Initialized creatures.gd")

func _calculateStats(dnahp,dnaat,dnadf,dnasp,dnast,level,creature):
# warning-ignore:unused_variable
	var totalhp
	var totalat
# warning-ignore:unused_variable
	var totaldf
# warning-ignore:unused_variable
	var totalsp
# warning-ignore:unused_variable
	var totalst
	var hpstr
	var atstr
	var dfstr
	var spstr
	var ststr
	totalhp = int ((data[creature].basehp * level) / 10) + ( dnahp * level )
	totalat = int ((data[creature].baseat * level) / 10) + ( dnaat * level )
	totaldf = int ((data[creature].basehp * level) / 10) + ( dnadf * level )
	totalsp = int ((data[creature].basesp * level) / 10) + ( dnasp * level )
	totalst = int ((data[creature].basest * level) / 10) + ( dnast * level )
	hpstr = str(totalhp)
	atstr = str(totalat)
	dfstr = str(totaldf)
	spstr = str(totalsp)
	ststr = str(totalst)
	
	
	return "HP: " + hpstr + " AT: " + atstr + " DF: " + dfstr + " SP: " + spstr + " ST: " + ststr

static func status_to_string(status: int) -> String:
	match status:
		0:
			return "OK"
		1:
			return "Burn"
		2:
			return "Poison"
		3:
			return "Defend"
		_:
			return ""

static func status_to_capture_mod(status: int) -> float:
	match status:
		1:
			return 1.3
		2:
			return 1.3
		3:
			return 0.7
		_:
			return 1.0
# func _input(ev):
	#var returnValue = _calculateStats(15,15,15,15,15,15,0)
	#if ev is InputEventKey and ev.scancode == KEY_K:
		#_calculateStats(15,15,15,15,15,15,0)
		#print(returnValue)
static func exp_to_next_level(level: int) -> int:
	return(int(100 * pow(level, 2)))


# 1 = Fire, 2 = Water, 3 = Thunder, 4 = Earth, 5 = Wind
static func primary_element_multiplier(attack: int, defense: int) -> float:
	if attack == 0 || defense == 0:
		return 1.0
	var multiplier: Array = [
		[1.0, .67, 1.5, .67, 1.5],
		[1.5, 1.0, .67, 1.5, .67],
		[.67, 1.5, 1.0, .67, 1.5],
		[1.5, .67, 1.5, 1.0, .67],
		[.67, 1.5, .67, 1.5, 1.0]
	]
	return multiplier[attack - 1][defense - 1]

# 8 = Steam, 9 = Blaze, 10 = Lava, 11 = Scorch, 15 = Storm, 16 = Wood, 17 = Ice, 22 = Explosion, 23 = Magnet, 29 = Crystal
static func multiplier(attack: int, defense: int) -> float:
	var attack_arr: Array = [attack % 6, attack / 6]
	var defense_arr: Array = [defense % 6, defense / 6]
	return primary_element_multiplier(attack_arr[0], defense_arr[0]) * primary_element_multiplier(attack_arr[1], defense_arr[0]) * primary_element_multiplier(attack_arr[0], defense_arr[1]) * primary_element_multiplier(attack_arr[1], defense_arr[1])

static func get_element(attack: String) -> int:
	match attack:
		"Dust Cloud":
			return 4
		"Flare":
			return 1
		"Growl":
			return 0
		"Gust":
			return 5
		"Leer":
			return 0
		"Peck":
			return 5
		"Scratch":
			return 0
		"Splash":
			return 2
		"Tackle":
			return 0
		"Tremor":
			return 4
		"Zap":
			return 3
		_:
			return 0
