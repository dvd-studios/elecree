extends CanvasLayer

var item_bag: Array = bag.item_bag
var key_items: Array = bag.key_items
var bag_ui: Array
var bag_offset: int
var select: int
var precolor: String
var first_frame: bool = false
var page: int = 0
var selecting_creature: int = 0

var usable_items: Dictionary = bag.usable_items

func generate_bag_ui() -> Array:
	var items: Array
	var amounts: Array
	var ui: Array
	if page != 2:
		for s in item_bag:
			if items.has(s):
				amounts[items.find(s)] += 1
			else:
				items.push_back(s)
				amounts.push_back(1)
		for i in items.size():
			ui.push_back(items[i] + " (x" + str(amounts[i]) + ")")
	else:
		for s in key_items:
			ui.push_back(s)
	return ui

func return_string_or_blank(array: Array, position: int) -> String:
	if array[position] is String && position >= 0 && position < array.size():
		return array[position]
	else:
		return ""

func get_nine_items(from: Array) -> String:
	var output: String = ""
	for i in from.size():
		if i < bag_offset:
			continue
		output += str(from[i])
		if i - bag_offset >= 8:
			break
		if i != from.size() - 1:
			output += "\n"
	return output

func _ready():
	refresh()

func refresh():
	bag_ui = generate_bag_ui()
	precolor = get_nine_items(bag_ui)
	get_node("RichTextLabel").bbcode_text = color_selection()

func color_selection() -> String:
	var splitted_string: Array = precolor.split("\n")
	splitted_string[select] = "[color=white]" + splitted_string[select] + "[/color]"
	var postcolor: String = "\n".join(splitted_string)
	return postcolor
	
func _process(delta: float):
	if selecting_creature == 1 && !get_node("UseOnCreature").visible:
		selecting_creature = 0
		visible = false
		get_parent().get_node("PlayerElecree").data.recharge = 0
		get_parent().lock = 0
	get_node("TileMap").visible = visible
	if visible && !get_node("UseOnCreature").visible:
		if Input.is_action_just_pressed("ui_down") && select + bag_offset < bag_ui.size() - 1:
			if select >= 8:
				bag_offset += 1
			else:
				select += 1
			refresh()
			print("New select: " + str(select + bag_offset))
		if Input.is_action_just_pressed("ui_up") && select + bag_offset >= 1:
			if select <= 0:
				bag_offset -= 1
			else:
				select -= 1
			refresh()
			print("New select: " + str(select + bag_offset))
		if Input.is_action_just_pressed("ui_accept") && !first_frame:
				var item: String = get_node("RichTextLabel").text.split("\n")[select].split(" (")[0]
				print("Usability:" + str(GlobalVars.get_usability_for_item(item)))
				if GlobalVars.get_usability_for_item(item) & 6 == 6:
					selecting_creature = 1
					get_node("UseOnCreature").show_items(item)
				elif GlobalVars.get_usability_for_item(item) & 2 == 2:
					hide()
					var text_to_display = ["You used a " + item + "!"]
					bag.item_bag.pop_at(bag.item_bag.find_last(item))
					select = 0
					refresh()
					match item:
						"Capture Cube":
							if GlobalVars.wild:
								var opponent: Elecree = get_parent().get_node("OpposingElecree").data
								var captureability: float = Creatures.data[opponent.species]["captureability"]
								captureability *= opponent.stathp / float(opponent.currenthp)
								captureability *= Creatures.status_to_capture_mod(opponent.status)
								var capture_attempt: float = randf()
								text_to_display.push_back("It shakes.")
								text_to_display.push_back("It shakes..")
								text_to_display.push_back("It shakes...")
								if capture_attempt <= captureability:
									text_to_display.push_back("Congratulations, " + opponent.get_name() + " was caught!")
									var team_size: int = team.get_team_size()
									if team_size < 7:
										team.team[team_size] = opponent
									else:
										team.creature_box.push_back(opponent)
									yield(get_parent().display_text(text_to_display), "completed")
									var player: Elecree = get_parent().get_node("PlayerElecree").data
									for player_creature in get_parent().creatures_that_will_gain_exp:
										if player_creature.currenthp >= 0:
											var player_exp: int = Creatures.data[opponent.species]["basexp"] * opponent.level
											player_creature.experience += player_exp
											yield(get_parent().display_text([player_creature.get_name() + " gained " + str(player_exp) + " EXP!"]), "completed")
											while player_creature.experience >= Creatures.exp_to_next_level(player.level):
												player_creature.level_up()
												yield(get_parent().display_text([player_creature.get_name() + "'s LV increased to " + str(player_creature.level) + "!"]), "completed")
												if ![null, ""].has(Creatures.data[player.species]["attacks"].duplicate().pop_at(player.level - 1)):
													yield(get_parent().display_text([player.get_name() + " learned " + Creatures.data[player.species]["attacks"].duplicate().pop_at(player.level - 1) + "!"]), "completed")
													player.attacks.push_back(Creatures.data[player.species]["attacks"].duplicate().pop_at(player.level - 1))
									get_parent().creatures_that_will_gain_exp = []
									if !GlobalVars.e_device_caught.has(opponent.species):
										yield(get_parent().display_text([str(opponent.get_name()) + "'s data will be added to the E-Device."]), "completed")
										GlobalVars.e_device_caught.push_back(opponent.species)
										get_parent().get_node("EDeviceLayer/TileMap").visible = true
										get_parent().get_node("EDeviceLayer/TileMap").set_number(opponent.species)
										yield(get_parent(), "z_press")
										get_parent().get_node("EDeviceLayer/TileMap").visible = false
										
									Yesno.get_node("CanvasLayer/QuestionLabel").ask_question("Would you like to give a nickname to " + opponent.get_name() + "?")
									var will_you_nickname: bool = yield(Yesno.get_node("CanvasLayer/QuestionLabel"), "answer")
									if will_you_nickname:
										Nicknaming.get_a_nickname(opponent.get_name() + "'s nickname?")
										opponent.nickname = yield(Nicknaming, "send_msg")
									if team.team.has(opponent):
										yield(get_parent().display_text([opponent.get_name() + " was added to the party."]), "completed")
									else:
										yield(get_parent().display_text([opponent.get_name() + " was placed in the Creature Box."]), "completed")
									get_parent().win_battle()
								else:
									text_to_display.push_back("The creature broke out of its cube!")
							else:
								text_to_display.push_back("But you can't use that on a Battler's Elecree, you thief!")
						"Super Capture Cube":
							if GlobalVars.wild:
								var opponent: Elecree = get_parent().get_node("OpposingElecree").data
								var captureability: float = Creatures.data[opponent.species]["captureability"]
								captureability *= opponent.stathp / float(opponent.currenthp)
								captureability *= Creatures.status_to_capture_mod(opponent.status)
								captureability *= 1.3
								var capture_attempt: float = randf()
								text_to_display.push_back("It shakes.")
								text_to_display.push_back("It shakes..")
								text_to_display.push_back("It shakes...")
								if capture_attempt <= captureability:
									text_to_display.push_back("Congratulations, " + opponent.get_name() + " was caught!")
									var team_size: int = team.get_team_size()
									if team_size < 7:
										team.team[team_size] = opponent
									else:
										team.creature_box.push_back(opponent)
									yield(get_parent().display_text(text_to_display), "completed")
									var player: Elecree = get_parent().get_node("PlayerElecree").data
									for player_creature in get_parent().creatures_that_will_gain_exp:
										if player_creature.currenthp >= 0:
											var player_exp: int = Creatures.data[opponent.species]["basexp"] * opponent.level
											player_creature.experience += player_exp
											yield(get_parent().display_text([player_creature.get_name() + " gained " + str(player_exp) + " EXP!"]), "completed")
											while player_creature.experience >= Creatures.exp_to_next_level(player.level):
												player_creature.level_up()
												yield(get_parent().display_text([player_creature.get_name() + "'s LV increased to " + str(player_creature.level) + "!"]), "completed")
												if ![null, ""].has(Creatures.data[player.species]["attacks"].duplicate().pop_at(player.level - 1)):
													yield(get_parent().display_text([player.get_name() + " learned " + Creatures.data[player.species]["attacks"].duplicate().pop_at(player.level + 1) - "!"]), "completed")
													player.attacks.push_back(Creatures.data[player.species]["attacks"].duplicate().pop_at(player.level - 1))
									get_parent().creatures_that_will_gain_exp = []
									if !GlobalVars.e_device_caught.has(opponent.species):
										yield(get_parent().display_text([str(opponent.get_name()) + "'s data will be added to the E-Device."]), "completed")
										GlobalVars.e_device_caught.push_back(opponent.species)
										get_parent().get_node("EDeviceLayer/TileMap").visible = true
										get_parent().get_node("EDeviceLayer/TileMap").set_number(opponent.species)
										yield(get_parent(), "z_press")
										get_parent().get_node("EDeviceLayer/TileMap").visible = false
									Yesno.get_node("CanvasLayer/QuestionLabel").ask_question("Would you like to give a nickname to " + opponent.get_name() + "?")
									var will_you_nickname: bool = yield(Yesno.get_node("CanvasLayer/QuestionLabel"), "answer")
									if will_you_nickname:
										Nicknaming.get_a_nickname(opponent.get_name() + "'s nickname?")
										opponent.nickname = yield(Nicknaming, "send_msg")
									if team.team.has(opponent):
										yield(get_parent().display_text([opponent.get_name() + " was added to the party."]), "completed")
									else:
										yield(get_parent().display_text([opponent.get_name() + " was placed in the Creature Box."]), "completed")
									get_parent().win_battle()
								else:
									text_to_display.push_back("The creature broke out of its cube!")
							else:
								text_to_display.push_back("But you can't use that on a Battler's Elecree, you thief!")
					yield(get_parent().display_text(text_to_display), "completed")
					get_parent().get_node("PlayerElecree").data.recharge = 0
					get_parent().lock = 0
	
		if Input.is_action_just_pressed("ui_cancel"):
			visible = false
			get_parent().lock = 1
	if visible == first_frame:
		page = 0
		first_frame = !visible
