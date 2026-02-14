extends Node2D
class_name PlayerElecree

var data: Elecree

func _ready():
	var team = get_node("/root/TEAM")
	#data = Elecree.new(3,3,3,3,3,3,0)
	var first_alive_creature: int = 0
	while TEAM.team[first_alive_creature].currenthp <= 0:
		first_alive_creature += 1
	data = TEAM.team[first_alive_creature]
	print(TEAM.team)

func _process(delta: float):
	data.currentat = ceil(data.floatat)
	data.currentdf = ceil(data.floatdf)
	data.currentsp = ceil(data.floatsp)

func attack(target: Elecree, attack: String):
	yield(get_parent().display_text([data.get_name() + " used " + attack + "!"]), "completed")
	var result = get_parent().display_text(data.attack(target, attack))
	if result is Object:
		yield(result, "completed")

func defend():
	yield(get_parent().display_text([data.get_name() + " defended!"]), "completed")
	data.defend()

func switch_creature(creature: int):
	yield(get_parent().display_text([data.get_name() + ", come back!"]), "completed")
	data.recharge = 0
	data = TEAM.team[creature]
	get_parent().refresh_creatures()
	if !(get_parent().creatures_that_will_gain_exp.has(data)):
		get_parent().creatures_that_will_gain_exp.push_back(data)
	yield(get_parent().display_text(["Go! " + data.get_name() + "!"]), "completed")
