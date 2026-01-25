extends Node

signal z_press()

func _ready():
	var textbox = Textbox.get_node("TextBox")
	textbox.show()
	var textbox_label = textbox.get_node("VBoxContainer/Label")
	textbox_label.text = "Loading Elecree League Registration Terminal..."
	yield(get_tree().create_timer(3), "timeout")
	textbox_label.text = "To continue, upload an image."
	yield(self, "z_press")
	textbox.hide()
	get_node("CharSelector").wait_and_show()
	yield(get_node("CharSelector"), "char_selected")
	textbox.show()
	textbox_label.text = "Uploading."
	yield(get_tree().create_timer(1), "timeout")
	textbox_label.text = "Uploading.."
	yield(get_tree().create_timer(1), "timeout")
	textbox_label.text = "Uploading..."
	yield(get_tree().create_timer(2), "timeout")
	textbox_label.text = "Upload complete."
	yield(self, "z_press")
	textbox_label.text = "Please enter your name."
	yield(self, "z_press")
	textbox.hide()
	Nicknaming.get_a_nickname("Your name: ")
	var name: String = yield(Nicknaming, "send_msg")
	if name == "":
		if GlobalVars.playing_as_ice:
			GlobalVars.player_name = "Ice"
		else:
			GlobalVars.player_name = "Fire"
	else:
		GlobalVars.player_name = name
	textbox.show()
	textbox_label.text = "Processing."
	yield(get_tree().create_timer(1), "timeout")
	textbox_label.text = "Processing.."
	yield(get_tree().create_timer(1), "timeout")
	textbox_label.text = "Processing..."
	yield(get_tree().create_timer(2), "timeout")
	textbox_label.text = "Your data has been successfully processed."
	yield(self, "z_press")
	textbox_label.text = GlobalVars.player_name + ", You are now registered in the Elecree League for the year 100."
	yield(self, "z_press")
	textbox_label.text = "From the Nioan Elecree Association, good luck!"
	yield(self, "z_press")
	textbox.hide()
	GlobalVars.cutscenePlaying = false
	GlobalVars._warpPlayer(Vector2(304, 64), "rebirthHouse1")

func _process(delta: float):
	if Input.is_action_just_pressed("ui_accept"):
		emit_signal("z_press")
