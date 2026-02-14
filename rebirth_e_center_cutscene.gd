extends KinematicBody2D
class_name RebirthElecreeBuildingCutscene

var step: int = -1
var velocity: Vector2 = Vector2.ZERO
var pete_velocity: Vector2 = Vector2.ZERO
var friend_name: String = "Ice"
onready var anim: AnimationPlayer = get_node("Sprite/AnimationPlayer")
onready var player_anim: AnimationPlayer = get_tree().current_scene.get_node("Player/Sprite/AnimationPlayer")
onready var pete: KinematicBody2D = get_parent().get_node("Pete")
onready var pete_anim: AnimationPlayer = pete.get_node("Sprite/AnimationPlayer")
var starter_species: int = 0
var species_name: String
var opponent_species: int
var advancing_to_step_9: bool = false
var opponent_elecree: Elecree
var last_collision: KinematicCollision2D
var last_pete_collision: KinematicCollision2D

func _ready():
	if !GLOBAL_VARS.get_flag("rebirth_town:e_center_cutscene"):
		STARTER_SELECTOR.connect("emit_species", self, "receive_starter_signal")
		step = 0
		GLOBAL_VARS.cutscenePlaying = true
		visible = true
		pete.visible = true
		get_node("CollisionShape2D").disabled = false
		pete.get_node("CollisionShape2D").disabled = false
		if GLOBAL_VARS.playing_as_ice:
			friend_name = "Fire"
			get_node("Sprite").texture = load("res://OverSprites/sheet_fire.png")
		player_anim.lastdir = "n"
		TEXTBOX.show_text(friend_name + ": " + GLOBAL_VARS.player_name + "! You made it!")
	elif !GLOBAL_VARS.get_flag("rebirth_town:post_battle_cutscene"):
		step = 100
		GLOBAL_VARS.cutscenePlaying = true
		visible = true
		pete.visible = true
		get_node("CollisionShape2D").disabled = false
		pete.get_node("CollisionShape2D").disabled = false
		if GLOBAL_VARS.playing_as_ice:
			friend_name = "Fire"
			get_node("Sprite").texture = load("res://OverSprites/sheet_fire.png")
		player_anim.lastdir = "n"
		TEXTBOX.show_text(friend_name + ": Dragons, that was amazing!")

func _process(delta: float):
	var conditions_for_advance: Array = [
		step >= 0 && step <= 8 && Input.is_action_just_pressed("ui_accept"),
		step == 8 && starter_species != 0,
		step == 9 && advancing_to_step_9,
		step >= 10 && step <= 116 && Input.is_action_just_pressed("ui_accept"),
		step == 117 && last_collision != null && abs(last_collision.remainder.x) < 1,
		step == 118 && last_collision != null && abs(last_collision.remainder.y) < 1,
		step == 119 && last_pete_collision != null && abs(last_pete_collision.remainder.x) < 1,
		step == 120 && last_pete_collision != null && abs(last_pete_collision.remainder.y) < 1 
		]
	if conditions_for_advance.has(true):
		advance()


func _physics_process(delta: float):
	last_collision = move_and_collide(velocity)
	last_pete_collision = pete.move_and_collide(pete_velocity)

func advance(): # CUTSCENE INCOMPLETE
	match step:
		0:
			TEXTBOX.show_text("Coach: So you're " + GLOBAL_VARS.player_name + ", right?")
		1:
			TEXTBOX.show_text(friend_name + ": The one and only!")
		2:
			TEXTBOX.show_text("Coach: My name's Pete, and I'll be your coach for the Elecree League here.")
		3: 
			TEXTBOX.show_text(friend_name + ": " + GLOBAL_VARS.player_name + "! I can't believe this is finally happening!")
		4:
			TEXTBOX.show_text(friend_name + ": " + "This is the day I've dreamed of since I watched the first Gate Battle on TV!")
		5:
			TEXTBOX.show_text("Pete: So, you're ready to see your options?")
		6:
			TEXTBOX.show_text("Pete: Then, behold!")
		7:
			STARTER_SELECTOR.wait_and_show()
		8:
			TEAM.team[0] = ElecreeTemplate.make_random_elecree(5, starter_species)
			GLOBAL_VARS.e_device_caught.push_back(starter_species)
			step = -1
			species_name = TEAM.team[0].get_name()
			YES_NO.get_node("CanvasLayer/QuestionLabel").ask_question("Would you like to give a nickname to " + species_name + "?")
			var answer: bool = yield(YES_NO.get_node("CanvasLayer/QuestionLabel"), "answer")
			if answer:
				NICKNAMING.get_a_nickname(species_name + "'s nickname?")
				TEAM.team[0].nickname = yield(NICKNAMING, "send_msg")
			step = 8
			advancing_to_step_9 = true
		9:
			TEXTBOX.show_text(friend_name + ": " + species_name + ", huh?")
		10:
			TEXTBOX.show_text(friend_name + ": Then how about I choose...")
		11:
			opponent_elecree = ElecreeTemplate.make_random_elecree(5, get_opposing_species())
			TEXTBOX.show_text(friend_name + ": " + opponent_elecree.get_name() + "!")
		12:
			TEXTBOX.hide_text()
			GLOBAL_VARS.set_flag("rebirth_town:e_center_cutscene", true)
			GLOBAL_VARS.start_battler_battle(
				[opponent_elecree, null, null, null, null, null, null], 
				get_parent().get_node("Player").position, 
				"res://rebirthECenter.tscn", 
				"rebirth_town:battler:ice", 
				"Elecree Battler " + friend_name
			)
		100:
			TEXTBOX.show_text(friend_name + ": If this is what a regular battle feels like, I can't IMAGINE what a Gate Battle feels like!")
		101:
			TEXTBOX.show_text("Pete: Oh yeah, the Gates. As you know, Nio has ten Gates spread around the region.")
		102:
			TEXTBOX.show_text("Pete: In fact, there's one pretty close to here in Gladridge.")
		103:
			TEXTBOX.show_text(friend_name + ": Oh yeah, that's Voma's Gate, right?")
		104:
			TEXTBOX.show_text("Pete: Exactly! Someone's been doing their homework!")
		105:
			TEXTBOX.show_text(friend_name + ": Nah, I've just been watchin' Gate Battles on TV.")
		106:
			TEXTBOX.show_text("Pete: Oh, before you leave, I'd like to give both of you these!")
		107:
			TEXTBOX.show_text("You got an E-Device!")
			GLOBAL_VARS.set_flag("edevice", true)
		108:
			TEXTBOX.show_text("Pete: This is an E-Device! We give these out to every new Battler.")
		109:
			TEXTBOX.show_text("Pete: It contains data on every known Elecree in Nio!")
		110:
			TEXTBOX.show_text(friend_name + ": Alright! Gladridge, huh?")
		111:
			TEXTBOX.show_text(friend_name + ": That's just two towns down!")
		112:
			TEXTBOX.show_text("Pete: Hey, when ya get there, just talk to me over the video chat box!")
		113:
			TEXTBOX.show_text("Pete: I'll be able to give you the details about all the Gatekeepers.")
		114:
			TEXTBOX.show_text(friend_name + ": Hey " + GLOBAL_VARS.player_name + "! I bet I'll get the Medallion before you do!")
		115:
			TEXTBOX.show_text(friend_name + ": I'll see ya up there!")
		116:
			TEXTBOX.hide_text()
			velocity.x = 1
			anim.play("walk_e")
		117:
			velocity.x = 0
			velocity.y = 1
			step = -1
			yield(get_tree(), "physics_frame")
			step = 117
			anim.play("walk_s")
		118:
			hide()
			get_node("CollisionShape2D").disabled = true
			pete_velocity.x = -1
			pete_anim.play("walk_w")
		119:
			pete_velocity.y = 1
			pete_velocity.x = 0
			step = -1
			yield(get_tree(), "physics_frame")
			step = 119
			pete_anim.play("walk_s")
		120:
			pete.hide()
			pete.get_node("CollisionShape2D").disabled = true
			step = -2
			GLOBAL_VARS.set_flag("rebirth_town:post_battle_cutscene", true)
			GLOBAL_VARS.cutscenePlaying = false
	step += 1
	
func receive_starter_signal(value: int):
	starter_species = value

func get_opposing_species() -> int:
	match TEAM.team[0].species:
		1:
			return 4
		4:
			return 7
		7:
			return 10
		10:
			return 13
		13:
			return 1
		_:
			return 0
