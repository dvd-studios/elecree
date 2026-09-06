extends Area2D
class_name DevLOper

onready var global = get_node("/root/GLOBAL_VARS")
onready var textbox = get_node("/root/TEXTBOX/TextBox")
onready var textboxlabel = get_node("/root/TEXTBOX/TextBox/VBoxContainer/Label")
var interactNumber: int
export var id: String = "devloper"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	interactNumber = 0
	print("Initialized road1.devloper.gd")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		print(interactNumber)
		if global.closestInteractable == id:
			if interactNumber == 0 && !global.cutscenePlaying:
				global.cutscenePlaying = true
				textbox.visible = true
				textboxlabel.text = "Dev L. Oper:\nThis area is under construction."
				interactNumber += 1
			elif interactNumber == 1:
				textboxlabel.text = ""
				textbox.visible = false
				global.cutscenePlaying = false
				interactNumber = 0
	if Input.is_action_just_pressed("ui_cancel"):
		print("Closest Interactable:" + global.closestInteractable)
		



func _on_Area2D_body_entered(body):
	print(body)
	if body.name == "Player":
		global.closestInteractable = id
	
func _on_Area2D_body_exited(body):
	global.closestInteractable = "null"
