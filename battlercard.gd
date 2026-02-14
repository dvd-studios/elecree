extends Label
class_name BattlerCard

func _process(delta: float):
	text = "NAME: " + GLOBAL_VARS.player_name + "\nCREDITS: " + str(GLOBAL_VARS.credits) + "\nE-DEVICE: " + str(GLOBAL_VARS.e_device_caught.size()) + "/70\nTIME: " + GLOBAL_VARS.time
	if Input.is_action_just_pressed("ui_cancel") && get_parent().visible == true:
		get_parent().get_node("TileMap").visible = false
		get_parent().visible = false
		GLOBAL_VARS.cutscenePlaying = false
