extends KinematicBody2D
class_name StartingCutscene

var step: int = -1
var velocity: Vector2 = Vector2.ZERO
var friend_name: String = "Ice"
onready var anim: AnimationPlayer = get_node("Sprite/AnimationPlayer")
onready var player_anim: AnimationPlayer = get_tree().current_scene.get_node("Player/Sprite/AnimationPlayer")

func _ready():
	if !GLOBAL_VARS.get_flag("rebirth_town:starting_cutscene"):
		step = 0
		GLOBAL_VARS.cutscenePlaying = true
		visible = true
		get_node("CollisionShape2D").disabled = false
		if GLOBAL_VARS.playing_as_ice:
			friend_name = "Fire"
			get_node("Sprite").texture = load("res://OverSprites/sheet_fire.png")
		anim.play("walk_w")
		velocity = Vector2(-1, 0)

func _process(delta: float):
	var conditions_for_advance: Array = [
		step == 0 && position.x <= 352,
		step >= 1 && step <= 8 && Input.is_action_just_pressed("ui_accept"),
		step == 9 && position.x >= 432
		]
	if conditions_for_advance.has(true):
		advance()


func _physics_process(delta: float):
	move_and_collide(velocity)

func advance():
	match step:
		0:
			anim.play("idle_w")
			velocity = Vector2.ZERO
			player_anim.lastdir = "e"
			TEXTBOX.show_text(friend_name + ": " + GLOBAL_VARS.player_name + "! " + GLOBAL_VARS.player_name + "! " + GLOBAL_VARS.player_name + "! ")
		1:
			TEXTBOX.show_text(friend_name + ": I can't believe it! We're finally getting our Elecree today!")
		2:
			TEXTBOX.show_text(friend_name + ": I wonder which one I'll get...")
		3:
			TEXTBOX.show_text(friend_name + ": Perhaps Dracospark, maybe Watty... ooh! What about Earthle?")
		4:
			TEXTBOX.show_text(friend_name + ": I really don't know, I'm just so excited! Just imagine this: ")
		5:
			TEXTBOX.show_text(friend_name + ": " + GLOBAL_VARS.player_name + " and " + friend_name + ", standing on top of the world with 10 Medallions!")
		6:
			TEXTBOX.show_text(friend_name + ": But that can't happen by just sitting around, so c'mon! Whatcha waiting for?")
		7:
			TEXTBOX.show_text(friend_name + ": Let's get to the Elecree Building already!")
		8:
			TEXTBOX.hide_text()
			anim.play("walk_e")
			velocity = Vector2(1, 0)
		9:
			GLOBAL_VARS.set_flag("rebirth_town:starting_cutscene", true)
			velocity = Vector2(0, 0)
			visible = false
			get_node("CollisionShape2D").disabled = true
			GLOBAL_VARS.cutscenePlaying = false
	step += 1
