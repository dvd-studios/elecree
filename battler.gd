extends StaticBody2D
class_name Battler

export var flavor_text: String
export var team: Array
export var battler_name: String
export var prize_money: int
export var win_flag: String

signal z_press()

func _process(delta: float):
	if Input.is_action_just_pressed("ui_accept"):
		emit_signal("z_press")

func _on_Area2D_body_entered(body: Node):
	if body.name == "Player" && !GLOBAL_VARS.get_flag(win_flag):
		GLOBAL_VARS.cutscenePlaying = true
		TEXTBOX.show_text(flavor_text)
		yield(self, "z_press")
		TEXTBOX.hide_text()
		var eteam: Array = []
		for si in team:
			eteam.push_back(ElecreeTemplate.make_random_elecree(si.a, si.b))
		GLOBAL_VARS.start_battler_battle(
			eteam,
			get_parent().get_node("Player").position,
			get_tree().current_scene.filename,
			win_flag,
			battler_name,
			prize_money
		)
