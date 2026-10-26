extends Area2D
class_name NPC

var interact_number: int
var max_interact: int


export var npc_name: String
export var texts: Array
export var active: bool = true


func _ready():
	interact_number = 0
	max_interact = texts.size()
	connect("body_entered", self, "_on_NPC_body_entered")
	connect("body_exited", self, "_on_NPC_body_exited")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if active && Input.is_action_just_pressed("ui_accept"):
		print(interact_number)
		if GLOBAL_VARS.closestInteractable == npc_name:
			if interact_number == 0 && !GLOBAL_VARS.cutscenePlaying:
				GLOBAL_VARS.cutscenePlaying = true
				TEXTBOX.show_text(texts[0])
				interact_number += 1
			elif interact_number < max_interact:
				TEXTBOX.show_text(texts[interact_number])
				interact_number += 1
			else:
				TEXTBOX.hide_text()
				GLOBAL_VARS.cutscenePlaying = false
				interact_number = 0
	if Input.is_action_just_pressed("ui_cancel"):
		print("Closest Interactable:" + GLOBAL_VARS.closestInteractable)
		



func _on_NPC_body_entered(body):
	print(body)
	if body.name == "Player":
		GLOBAL_VARS.closestInteractable = npc_name
	
func _on_NPC_body_exited(body):
	if body.name == "Player":
		if GLOBAL_VARS.closestInteractable == npc_name:
			while interact_number != 0:
				yield(get_tree(), "idle_frame")
			GLOBAL_VARS.closestInteractable = "null"


