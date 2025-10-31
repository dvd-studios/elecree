extends Node2D

var data: Elecree

func _ready():
	var team = get_node("/root/team")
	#data = Elecree.new(3,3,3,3,3,3,0)
	var first_alive_creature: int = 0
	while team.team[first_alive_creature].currenthp <= 0:
		first_alive_creature += 1
	data = team.team[first_alive_creature]
	print(team.team)

func attack(target: Elecree, attack: String):
	yield(get_parent().display_text([data.get_name() + " used " + attack + "!"]), "completed")
	data.attack(target, attack)

func defend():
	yield(get_parent().display_text([data.get_name() + " defended!"]), "completed")
	data.defend()

func switch_creature(creature: int):
	yield(get_parent().display_text([data.get_name() + ", come back!"]), "completed")
	data.recharge = 0
	data = team.team[creature]
	get_parent().refresh_creatures()
	yield(get_parent().display_text(["Go! " + data.get_name() + "!"]), "completed")
