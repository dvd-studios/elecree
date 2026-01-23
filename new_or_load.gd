extends Node2D

var option: int = 1
var file_exists: bool = false
var save_file: File

onready var labels: Array = [$VBoxContainer/Label, $VBoxContainer/Label2]

func _ready():
	save_file = File.new()
	file_exists = save_file.file_exists("user://savefile.dat")
	get_node("VBoxContainer/Label").visible = file_exists
	if file_exists:
		option = 0
		save_file.open("user://savefile.dat", File.READ)
		var deserialized: Dictionary = parse_json(save_file.get_line())
		var seconds: int = int(deserialized["real_time"])
		get_node("VBoxContainer/Label").text = "Continue (" + deserialized["player_name"] + "/" + str(seconds / 60) + ":" + leading_zero(str(seconds % 60)) + ")"

func leading_zero(input: String) -> String:
	if input.length() == 1:
		return "0" + input
	else:
		return input

func _process(delta: float):
	if Input.is_action_just_pressed("ui_up") && file_exists:
		option = 0
	if Input.is_action_just_pressed("ui_down"):
		option = 1
	if Input.is_action_just_pressed("ui_accept"):
		if option == 0:
			GlobalVars.cutscenePlaying = false
			GlobalVars.deserialize_save()
		else:
			if file_exists && get_node("VBoxContainer/Label3").visible == false:
				get_node("VBoxContainer/Label3").visible = true
			else:
				GlobalVars.cutscenePlaying = false
				get_tree().change_scene("res://charcreator.tscn")
	labels[option].add_color_override("font_color", Color(1, 1, 1))
	labels[abs(option - 1)].add_color_override("font_color", Color(0, 0, 0))
