extends Resource

class_name Elecree

var dict = preload("res://creatures.tres").data
var atk_list = preload("res://creatures.tres").attack_list
var stamina_cost = preload("res://creatures.tres").stamina_cost

enum StatusEffect {OK, Burn, Poison, Defend}

export(int) var stathp: int
export(int) var statat: int
export(int) var statdf: int
export(int) var statsp: int
export(int) var statst: int
export(int) var species: int
export(int) var currenthp: int
export(int) var currentat: int; var floatat: float
export(int) var currentdf: int; var floatdf: float
export(int) var currentsp: int; var floatsp: float
export(int) var currentst: int
export(int) var status: int
export(int) var level: int
export(float) var recharge: float
export(Array) var attacks: Array
export(String) var nickname: String = ""
export(int) var experience: int
var dna_hp: int
var dna_at: int
var dna_df: int
var dna_sp: int
var dna_st: int
var last_status: int

func serialize() -> String:
	var mid_stage: Dictionary = {}
	mid_stage["stathp"] = stathp
	mid_stage["statat"] = statat
	mid_stage["statdf"] = statdf
	mid_stage["statsp"] = statsp
	mid_stage["statst"] = statst
	mid_stage["species"] = species
	mid_stage["currenthp"] = currenthp
	mid_stage["currentst"] = currentst
	mid_stage["status"] = status
	mid_stage["level"] = level
	mid_stage["attacks"] = attacks
	mid_stage["dna_hp"] = dna_hp
	mid_stage["dna_at"] = dna_at
	mid_stage["dna_df"] = dna_df
	mid_stage["dna_sp"] = dna_sp
	mid_stage["dna_st"] = dna_st
	mid_stage["nickname"] = nickname
	mid_stage["experience"] = experience
	return to_json(mid_stage)

func deserialize(json: String):
	var mid_stage: Dictionary = parse_json(json)
	stathp = mid_stage["stathp"]
	statat = mid_stage["statat"]
	statdf = mid_stage["statdf"]
	statsp = mid_stage["statsp"]
	statst = mid_stage["statst"]
	species = mid_stage["species"]
	currenthp = mid_stage["currenthp"]
	currentat = statat
	floatat = currentat
	currentdf = statdf
	floatdf = currentdf
	currentsp = statsp
	floatsp = currentsp
	currentst = mid_stage["currentst"]
	status = mid_stage["status"]
	level = mid_stage["level"]
	attacks = mid_stage["attacks"]
	dna_hp = mid_stage["dna_hp"]
	dna_at = mid_stage["dna_at"]
	dna_df = mid_stage["dna_df"]
	dna_sp = mid_stage["dna_sp"]
	dna_st = mid_stage["dna_st"]
	nickname = mid_stage["nickname"]
	experience = mid_stage["experience"]

func burn():
	if status == StatusEffect.OK:
		status = StatusEffect.Burn

func poison():
	if status == StatusEffect.OK:
		status = StatusEffect.Poison

func _init(dnahp: int, dnaat: int, dnadf: int, dnasp: int, dnast: int, lv: int, id: int, deser: String = ""):
	if deser == "":
		stathp = int ((dict[id].basehp * lv) / 10) + ( dnahp * lv )
		statat = int ((dict[id].baseat * lv) / 10) + ( dnaat * lv )
		statdf = int ((dict[id].basedf * lv) / 10) + ( dnadf * lv )
		statsp = int ((dict[id].basesp * lv) / 10) + ( dnasp * lv )
		statst = int ((dict[id].basest * lv) / 10) + ( dnast * lv )
		dna_hp = dnahp
		dna_at = dnaat
		dna_df = dnadf
		dna_sp = dnasp
		dna_st = dnast
		species = id
		currenthp = stathp
		currentat = statat
		floatat = currentat
		currentdf = statdf
		floatdf = currentdf
		currentsp = statsp
		floatsp = currentsp
		currentst = statst
		recharge = 0
		status = StatusEffect.OK
		level = lv
		experience = Creatures.exp_to_next_level(lv - 1)
	#print("Generating attacks with level " + str(lv))
		attacks = generate_attacks(lv, id)
	else:
		deserialize(deser)

func get_stamina(attack: String):
	return stamina_cost[atk_list.find(attack)]

func attack(target: Elecree, attack: String, from_opponent: bool = false) -> Array:
	currentst -= stamina_cost[atk_list.find(attack)]
	recharge = 0
	var array_to_return: Array = []
	match attack:
		"Dust Cloud":
			if target.floatsp < (float(target.statsp) / (pow(1.3, 5.5))):
				array_to_return.push_back("But it failed!")
			else:
				target.floatsp /= 1.3
				array_to_return.push_back(("" if from_opponent else "The opposing ") + target.get_name() + "'s speed down!")
		"Flare":
			array_to_return.push_back(damage(target, 30, 1))
			array_to_return.push_back("")
		"Gust":
			array_to_return.push_back(damage(target, 30, 5))
			array_to_return.push_back("")
		"Growl":
			if target.floatat < (float(target.statat) / (pow(1.3, 5.5))):
				array_to_return.push_back("But it failed!")
			else:
				target.floatat /= 1.3
				array_to_return.push_back(("" if from_opponent else "The opposing ") + target.get_name() + "'s attack down!")
		"Leer":
			if target.floatdf < (float(target.statdf) / (pow(1.3, 5.5))):
				array_to_return.push_back("But it failed!")
			else:
				target.floatdf /= 1.3
				array_to_return.push_back(("" if from_opponent else "The opposing ") + target.get_name() + "'s defense down!")
		"Peck":
			array_to_return.push_back(damage(target, 25, 5))
			array_to_return.push_back("")
		"Scratch":
			array_to_return.push_back(damage(target, 30))
			array_to_return.push_back("")
		"Splash":
			array_to_return.push_back(damage(target, 30, 2))
			array_to_return.push_back("")
		"Tackle":
			array_to_return.push_back(damage(target, 30))
			array_to_return.push_back("")
		"Tremor":
			array_to_return.push_back(damage(target, 30, 4))
			array_to_return.push_back("")
		"Zap":
			array_to_return.push_back(damage(target, 30, 3))
			array_to_return.push_back("")
		_:
			array_to_return.push_back("")
	return array_to_return

func defend():
	currentst = statst
	recharge = 0
	last_status = status
	status = 3

func damage(target: Elecree, power: int, element: int = 0) -> String:
	var effectiveness_text: String = ""
	var effectiveness: float = Creatures.multiplier(element, Creatures.data[target.species]["element"])
	var effectiveness_log = log(effectiveness) / log(1.5)
	if effectiveness_log < -2.5:
		effectiveness_text = "It's barely effective..."
	elif effectiveness_log < -1.5:
		effectiveness_text = "It's somewhat effective..."
	elif effectiveness_log < -0.5:
		effectiveness_text = "It's not very effective..."
	elif effectiveness_log < .5:
		effectiveness_text = ""
	elif effectiveness_log < 1.5:
		effectiveness_text = "It's super effective!"
	elif effectiveness_log < 2.5:
		effectiveness_text = "It's hyper effective!"
	else:
		effectiveness_text = "It's EXTREMELY effective!"
	var dmg: int = (power * (float(currentat) / float(target.currentdf)) * effectiveness) / 10
	if target.status == 3:
		dmg /= 1.5
	#print("Power" + str(power) + "Level" + str(level) + "Attack" + str(currentat) + "Defense" + str(target.currentdf))
	target.currenthp -= dmg
	if target.currenthp < 0:
		target.currenthp = 0
	return effectiveness_text
	
func generate_attacks(lv: int, id: int) -> Array:
	var attacks: Array
	for i in range(0, lv):
		var new_attack: String = get_attack(i + 1, id)
		#print("Adding new attack " + new_attack)
		if new_attack != "":
			attacks.push_back(new_attack)
	#print("Attacks" + str(attacks))
	return attacks


func get_attack(lv: int, id: int) -> String:
		if dict[id].attacks.size() < lv:
			return ""
		else:
			return dict[id].attacks[lv - 1]

func heal():
	currenthp = stathp
	currentat = statat
	floatat = currentat
	currentdf = statdf
	floatdf = currentdf
	currentsp = statsp
	floatsp = currentsp
	currentst = statst
	status = StatusEffect.OK

func partheal():
	floatat = statat
	floatdf = statdf
	floatsp = statsp

func not_an_init_but_a_dictionary_because_godot_3_is_dumb_and_doesnt_allow_cyclic_class_reference(dnahp: int, dnaat: int, dnadf: int, dnasp: int, dnast: int, lv: int, id: int) -> Dictionary:
	var not_an_elecree: Dictionary = {}
	not_an_elecree["stathp"] = int ((dict[id].basehp * lv) / 10) + ( dnahp * lv )
	not_an_elecree["statat"] = int ((dict[id].baseat * lv) / 10) + ( dnaat * lv )
	not_an_elecree["statdf"] = int ((dict[id].basedf * lv) / 10) + ( dnadf * lv )
	not_an_elecree["statsp"] = int ((dict[id].basesp * lv) / 10) + ( dnasp * lv )
	not_an_elecree["statst"] = int ((dict[id].basest * lv) / 10) + ( dnast * lv )
	return not_an_elecree

func level_up():
	level += 1
	var fully_healed = not_an_init_but_a_dictionary_because_godot_3_is_dumb_and_doesnt_allow_cyclic_class_reference(dna_hp, dna_at, dna_df, dna_sp, dna_st, level, species)
	if currenthp == stathp:
		stathp = fully_healed["stathp"]
		currenthp = stathp
	else:
		stathp = fully_healed["stathp"]
	statat = fully_healed["statat"]
	statdf = fully_healed["statdf"]
	statsp = fully_healed["statsp"]
	statst = fully_healed["statst"]

func get_name() -> String:
	if nickname == "":
		return dict[species].name
	return nickname
