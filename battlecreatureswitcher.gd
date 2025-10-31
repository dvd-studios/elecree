extends CanvasLayer

var page: int = 0
var select: int = 1

func _ready():
	self.visible = false
	get_node("TileMap").visible = false

func get_attack(pg: int, number: int) -> String:
	var order: int = (pg * 3) + number
	if order <= 0:
		return ""
	else:
		if get_parent().get_node("PlayerElecree").data.attacks.size() < order:
			return ""
		else:
			return get_parent().get_node("PlayerElecree").data.attacks[order - 1]

func get_creature_and_deets(number: int) -> String:
	var creature: Elecree = team.team[number - 1]
	var status: String = ""

	if creature == null:
		return ""
	else:
		if creature.currenthp <= 0:
			return creature.get_name() + " :L" + str(creature.level) + " KO"
		match creature.status:
			0:
				status = "OK"
			1:
				status = "Burn"
			2:
				status = "Poison"
			3:
				status = "Defend"
		return creature.get_name() + " :L" + str(creature.level) + " " + status + " HP: " + str(creature.currenthp) + "/" + str(creature.stathp)

func _process(delta):
	get_node("VBoxContainer/Label").text = get_creature_and_deets(1)
	get_node("VBoxContainer/Label2").text = get_creature_and_deets(2)
	get_node("VBoxContainer/Label3").text = get_creature_and_deets(3)
	get_node("VBoxContainer/Label4").text = get_creature_and_deets(4)
	get_node("VBoxContainer/Label5").text = get_creature_and_deets(5)
	get_node("VBoxContainer/Label6").text = get_creature_and_deets(6)
	get_node("VBoxContainer/Label7").text = get_creature_and_deets(7)
	
	
	if self.visible && Input.is_action_just_pressed("ui_down"):
		select += 1 if select < 7 && (get_creature_and_deets(select + 1) != "") else 0
	
	if self.visible && Input.is_action_just_pressed("ui_up"):
		select -= 1 if select > 1 && (get_creature_and_deets(select - 1) != "") else 0
	
	if self.visible && Input.is_action_just_pressed("ui_accept") && get_parent().get_node("PlayerElecree").data != team.team[select - 1] && team.team[select - 1].currenthp > 0: # Do later: Summary before switching
		print("Running switching operation")
		visible = false
		get_node("TileMap").visible = false
		yield(get_parent().get_node("PlayerElecree").switch_creature(select - 1), "completed")
		#get_parent().get_node("PlayerElecree").data.attack(get_parent().get_node("OpposingElecree").data, get_attack(page, select))
		#get_node("TileMap").visible = false
		get_parent().lock = 0
	
	get_node("VBoxContainer/Label" ).add_color_override("font_color", Color(1, 1, 1) if select == 1 else Color(0, 0, 0))
	get_node("VBoxContainer/Label2").add_color_override("font_color", Color(1, 1, 1) if select == 2 else Color(0, 0, 0))
	get_node("VBoxContainer/Label3").add_color_override("font_color", Color(1, 1, 1) if select == 3 else Color(0, 0, 0))
	get_node("VBoxContainer/Label4").add_color_override("font_color", Color(1, 1, 1) if select == 4 else Color(0, 0, 0))
	get_node("VBoxContainer/Label5").add_color_override("font_color", Color(1, 1, 1) if select == 5 else Color(0, 0, 0))
	get_node("VBoxContainer/Label6").add_color_override("font_color", Color(1, 1, 1) if select == 6 else Color(0, 0, 0))
	get_node("VBoxContainer/Label7").add_color_override("font_color", Color(1, 1, 1) if select == 7 else Color(0, 0, 0))
	
func wait_and_show():
	yield(get_tree(), "idle_frame")
	visible = true
	get_node("TileMap").visible = true
