extends Resource
class_name Creatures

const attack_list = [ "Tackle", "Defend", "Leer"]
const stamina_cost = [ 3,        0      ,  1    ]

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
		"attacks": ["Tackle", "", "Leer"]
}}

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
