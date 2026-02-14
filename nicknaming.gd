extends Node2D
class_name NicknamingScript

const texts: Array = [
	["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
	["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"],
	["a", "s", "d", "f", "g", "h", "j", "k", "l"],
	["z", "x", "c", "v", "b", "n", "m"],
	["UPPER", "ENTER", "BKSP"]
]

const texts_shifted: Array = [
	["!", "@", "#", "$", "%", "^", "&", "*", "(", ")"],
	["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"],
	["A", "S", "D", "F", "G", "H", "J", "K", "L"],
	["Z", "X", "C", "V", "B", "N", "M"],
	["LOWER", "ENTER", "BKSP"]
]

signal send_msg(message)

var shifted: bool = false

var row: int = 0
var col: int = 0

func _ready():
	get_node("CanvasLayer").layer = 101

var text: String = ""

func get_a_nickname(question: String):
	get_node("CanvasLayer/TileMap/VBoxContainer/Question").text = question
	visible = true
	row = 0
	col = 0


func get_mutable_texts_array():
	if shifted:
		return texts_shifted.duplicate()
	
	else:
		return texts.duplicate()

func get_ui() -> String:
	var ui: String = "\n[center]"
	var chars: Array = get_mutable_texts_array()
	for line in chars.size():
		for entry in chars[line].size():
			if row == line && col == entry:
				ui += "[color=white]" + chars[line][entry] + "[/color] "
			else:
				ui += chars[line][entry] + " "
		ui = ui.substr(0, ui.length() - 1)
		ui += "\n"
	ui = ui.substr(0, ui.length() - 1)
	return ui


func _process(delta: float):
	get_node("CanvasLayer").visible = visible
	get_node("CanvasLayer/TileMap").visible = visible
	if visible:
		get_node("CanvasLayer/TileMap/RichTextLabel").bbcode_text = get_ui()
		var mutable: Array = get_mutable_texts_array()
		if Input.is_action_just_pressed("ui_right"):
			if col < mutable[row].size() - 1:
				col += 1
		if Input.is_action_just_pressed("ui_left"):
			if col > 0:
				col -= 1
		if Input.is_action_just_pressed("ui_up"):
			if row > 0:
				row -= 1
				col = min(mutable[row].size() - 1, col)
		if Input.is_action_just_pressed("ui_down"):
			if row < mutable.size() - 1:
				row += 1
				col = min(mutable[row].size() - 1, col)
		if Input.is_action_just_pressed("ui_accept"):
			if mutable[row][col].length() == 1:
				if text.length() < 10:
					text += mutable[row][col]
			else:
				match col:
					0:
						shifted = !shifted
					1:
						emit_signal("send_msg", text)
						text = ""
						visible = false
					2:
						text = text.substr(0, text.length() - 1)
		
		get_node("CanvasLayer/TileMap/VBoxContainer/Answer").text = text
		for i in 10 - text.length():
			get_node("CanvasLayer/TileMap/VBoxContainer/Answer").text += "_"
