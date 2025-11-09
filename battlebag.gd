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
		if Input.is_action_just_pressed("ui_cancel"):
			visible = false
			get_parent().lock = 1
	if visible == first_frame:
		page = 0
		first_frame = !visible
