extends KinematicBody2D
class_name RebirthTownFalseStart

var step: int = -1
var velocity: Vector2 = Vector2.ZERO
var friend_name: String = "Ice"
onready var anim: AnimationPlayer = get_node("Sprite/AnimationPlayer")
onready var playeranim: CharMove = get_tree().current_scene.get_node("Player/Sprite/AnimationPlayer")

func _ready():
	if !GLOBAL_VARS.get_flag("rebirth_town:post_battle_cutscene"):
		step = 0
		if GLOBAL_VARS.playing_as_ice:
			friend_name = "Fire"
			get_node("Sprite").texture = load("res://OverSprites/sheet_fire.png")

func _process(delta: float):
	var conditions_for_advance: Array = [
		step == 0 && get_parent().get_node("Player").global_position.x >= 400,
		step == 1 && global_position.x >= 320,
		step >= 2 && step <= 4 && Input.is_action_just_pressed("ui_accept"),
		step == 5 && global_position.x <= 224
		]
	if conditions_for_advance.has(true):
		advance()


func _physics_process(delta: float):
	move_and_collide(velocity)

func advance():
	match step:
		0:
			get_parent().get_node("Player").global_position.x = 399
			GLOBAL_VARS.cutscenePlaying = true
			visible = true
			get_node("CollisionShape2D").disabled = false
			anim.play("walk_e")
			velocity.x = 1
		1:
			velocity.x = 0
			anim.play("idle_e")
			playeranim.lastdir = "w"
			TEXTBOX.show_text(friend_name + ": Hey " + GLOBAL_VARS.player_name + "!")
		2:
			TEXTBOX.show_text(friend_name + ": Come on, let's go get our Elecree already!")
		3:
			TEXTBOX.show_text(friend_name + ": We can't go on our adventure just yet!")
		4:
			TEXTBOX.hide_text()
			anim.play("walk_w")
			velocity.x = -1
		5:
			step = -1
			velocity.x = 0
			get_node("CollisionShape2D").disabled = true
			visible = false
			GLOBAL_VARS.cutscenePlaying = false
	step += 1
