extends Node2D
class_name CharSelector

signal char_selected()

func _process(delta: float):
	if visible:
		if Input.is_action_just_pressed("ui_left"):
			GLOBAL_VARS.playing_as_ice = false
			get_node("HBoxContainer/VBoxContainer/Label").add_color_override("font_color", Color(1,1,1))
			get_node("HBoxContainer/VBoxContainer2/Label").add_color_override("font_color", Color(0,0,0))
		if Input.is_action_just_pressed("ui_right"):
			GLOBAL_VARS.playing_as_ice = true
			get_node("HBoxContainer/VBoxContainer2/Label").add_color_override("font_color", Color(1,1,1))
			get_node("HBoxContainer/VBoxContainer/Label").add_color_override("font_color", Color(0,0,0))
		if Input.is_action_just_pressed("ui_accept"):
			if GLOBAL_VARS.playing_as_ice:
				BATTLER_CARD.get_node("CanvasLayer/Sprite").texture = load("res://OverSprites/sheet_ice.png")
			hide()
			emit_signal("char_selected")

func wait_and_show():
	yield(get_tree(), "idle_frame")
	show()
