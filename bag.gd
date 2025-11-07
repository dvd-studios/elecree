extends Node2D

var item_bag: Array = ["Capture Cube", "Capture Cube", "Super Capture Cube", "Stamina Potion"]
var key_items: Array = ["Grappling Hook"]
var bag_ui: Array
var offset: int
var select: int
var precolor: String
var first_frame: bool = false
var page: int = 0

var usable_items: Dictionary = { # 0: Unusable, 1: Usable out of battle only, 2: Usable in battle only, 3: Usable in or out of battle
	"Capture Cube": 2,
	"Super Capture Cube": 2
}

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
		if i < offset:
			continue
		output += str(from[i])
		if i - offset >= 8:
			break
		if i != from.size() - 1:
			output += "\n"
	return output

func _ready():
	refresh()

func refresh():
	bag_ui = generate_bag_ui()
	precolor = get_nine_items(bag_ui)
	get_node("CanvasLayer/RichTextLabel").bbcode_text = color_selection()

func color_selection() -> String:
	var splitted_string: Array = precolor.split("\n")
	splitted_string[select] = "[color=white]" + splitted_string[select] + "[/color]"
	var postcolor: String = "\n".join(splitted_string)
	return postcolor
	
func _process(delta: float):
	get_node("CanvasLayer").visible = visible
	
	get_node("CanvasLayer/HBoxContainer/USE").add_color_override("font_color", Color(0,0,0))
	get_node("CanvasLayer/HBoxContainer/TOSS").add_color_override("font_color", Color(0,0,0))
	get_node("CanvasLayer/HBoxContainer/KEY").add_color_override("font_color", Color(0,0,0))
	
	match page:
		0:
			get_node("CanvasLayer/HBoxContainer/USE").add_color_override("font_color", Color(1,1,1))
		1:
			get_node("CanvasLayer/HBoxContainer/TOSS").add_color_override("font_color", Color(1,1,1))
		2:
			get_node("CanvasLayer/HBoxContainer/KEY").add_color_override("font_color", Color(1,1,1))
	
	if visible && !get_node("TosserLayer").visible && !get_node("UseOnCreature").visible:
		if Input.is_action_just_pressed("ui_down") && select + offset < bag_ui.size() - 1:
			if select >= 8:
				offset += 1
			else:
				select += 1
			refresh()
			print("New select: " + str(select + offset))
		if Input.is_action_just_pressed("ui_up") && select + offset >= 1:
			if select <= 0:
				offset -= 1
			else:
				select -= 1
			refresh()
			print("New select: " + str(select + offset))
		if Input.is_action_just_pressed("ui_right"):
			if page < 2:
				page += 1
				if page == 2:
					select = 0
				refresh()
		if Input.is_action_just_pressed("ui_left"):
			if page > 0:
				page -= 1
				if page == 1:
					select = 0
				refresh()
		if Input.is_action_just_pressed("ui_accept") && !first_frame:
			match page:
				0:
					var item: String = get_node("CanvasLayer/RichTextLabel").text.split("\n")[select].split(" (")[0]
					print("Usability:" + str(GlobalVars.get_usability_for_item(item)))
					if GlobalVars.get_usability_for_item(item) & 5 == 5:
						get_node("UseOnCreature").show_items(item)
				1:
					get_node("TosserLayer").toss_how_many(get_node("CanvasLayer/RichTextLabel").text.split("\n")[select].split(" (")[0], int(get_node("CanvasLayer/RichTextLabel").text.split("\n")[select].split("(")[1].substr(1).split(")")[0]))
		if Input.is_action_just_pressed("ui_cancel"):
			visible = false
			GlobalVars.cutscenePlaying = false
	if visible == first_frame:
		page = 0
		first_frame = !visible
