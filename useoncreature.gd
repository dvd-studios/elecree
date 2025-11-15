extends CanvasLayer

var creature: int
var labels: Array
var creatures: int
var dictionaries: Dictionary
var team_of_creatures: Array
var in_details: bool = false
var first_frame: bool = true
var use_cycle: int = 0
var current_item: String = ""

func hide_items():
	hide()
	get_node("TileMap").hide()


func show_items(which_item: String):
	reboot()
	current_item = which_item
	show()
	get_node("TileMap").show()

func _ready():
	connect("visibility_changed", self, "on_hide")
	reboot()

func on_hide():
	if !visible:
		print("On hide")
		first_frame = true

func reboot():
	hide_items()
	labels = [get_node("VBoxContainer/Label"), get_node("VBoxContainer/Label2"), get_node("VBoxContainer/Label3"), get_node("VBoxContainer/Label4"), get_node("VBoxContainer/Label5"), get_node("VBoxContainer/Label6"), get_node("VBoxContainer/Label7")]
	dictionaries = load("res://creatures.tres").data
	set_texts(team.team)
	creatures = get_length_of_creature_list(get_texts(labels))

func better_modulus(value: int, modulus: int) -> int:
	return (value % modulus) if value >= 0 || modulus == 1 else (value % modulus) + modulus

func set_texts(array: Array):
	print(labels.size())
	for creature in array.size():
		if array[creature] == null:
			labels[creature].text = ""
		else:
			labels[creature].text = get_name_of_creature(array[creature])

func get_texts(array: Array) -> Array:
	var ret: Array = []
	for s in array:
		ret.push_back(s.text)
	return ret

func get_length_of_creature_list(array: Array) -> int:
	var num: int = 0
	for s in array:
		if s != "":
			num += 1
	return num

func get_names_of_creatures(array: Array) -> Array: # deprecated
	var arr: Array = []
	for e in array:
		var text: String = ""
		text += dictionaries[e.species].name
		text += " :L"
		text += str(e.level)
		if e.currenthp <= 0:
			text += " KO"
		else:
			text += Creatures.status_to_string(e.status)
		arr.push_back(text)
	return arr
	
func get_name_of_creature(elecree: Elecree) -> String:
	var text: String = ""
	text += dictionaries[elecree.species].name
	text += " :L"
	text += str(elecree.level)
	return text
	

func size_without_nulls(arr: Array) -> int:
	var i: int = 0
	for a in arr:
		if a != null:
			i += 1
	return i

func _process(delta: float):
	if visible && !in_details && !first_frame:
		if use_cycle == 0:
			if Input.is_action_just_pressed("ui_down"):
				creature += 1
				creature = better_modulus(creature, size_without_nulls(team.team))
			if Input.is_action_just_pressed("ui_up"):
				creature -= 1
				creature = better_modulus(creature, size_without_nulls(team.team))
			if Input.is_action_just_pressed("ui_cancel"):
				hide_items()
				GlobalVars.cutscenePlaying = false
				first_frame = true
		if Input.is_action_just_pressed("ui_accept"):
			match use_cycle:
				0:
					get_node("VBoxContainer/Label8").text = "Used " + current_item + " on " + team.team[creature].get_name() + "!"
					use_cycle += 1
				1:
					get_node("VBoxContainer/Label8").text = use_on_creature(current_item, team.team[creature])
					use_cycle += 1
				2:
					get_node("VBoxContainer/Label8").text = "Use on what Elecree?"
					hide_items()
					use_cycle = 0
		
	if visible:
		first_frame = false
	
	for l in labels.size():
		if l == creature:
			labels[l].add_color_override("font_color", Color(1, 1, 1))
		else:
			labels[l].add_color_override("font_color", Color(0, 0, 0))

func use_on_creature(item: String, elecree: Elecree) -> String:
	get_parent().item_bag.pop_at(get_parent().item_bag.find_last(item))
	get_parent().select = 0
	get_parent().refresh()
	match item:
		"Health Potion":
			elecree.currenthp += 10
			if elecree.currenthp > elecree.stathp:
				elecree.currenthp = elecree.stathp
			return elecree.get_name() + " restored 10 HP."
		"Stamina Potion":
			elecree.currentst += 10
			if elecree.currentst > elecree.statst:
				elecree.currentst = elecree.statst
			return elecree.get_name() + " restored 10 stamina."
	return ""
	
