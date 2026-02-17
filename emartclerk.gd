extends Area2D
class_name EMartClerk

var interactNumber: int
onready var global = get_node("/root/GLOBAL_VARS")
onready var textbox = get_node("/root/TEXTBOX/TextBox")
onready var textboxlabel = get_node("/root/TEXTBOX/TextBox/VBoxContainer/Label")
var cubes: Array
var healing: bool
var asking: bool

func _ready():
	interactNumber = 0
	print("Initialized emartclerk.gd")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept") && !asking:
		print(interactNumber)
		if global.closestInteractable == "emartclerk":
			if interactNumber == 0 && !global.cutscenePlaying:
				global.cutscenePlaying = true
				textbox.visible = true
				textboxlabel.text = "Welcome to the E-Mart!"
				interactNumber += 1
			elif interactNumber == 1:
				textbox.visible = false
				MART.wait_and_show()
				interactNumber = 0

				
	if Input.is_action_just_pressed("ui_cancel"):
		print("Closest Interactable:" + global.closestInteractable)



func _on_ECenterClerk_body_entered(body):
	print(body)
	if body.name == "Player":
		global.closestInteractable = "emartclerk"
	
func _on_ECenterClerk_body_exited(body):
	if body.name == "Player":
		if global.closestInteractable == "emartclerk":
			while interactNumber != 0:
				yield(get_tree(), "idle_frame")
			global.closestInteractable = "null"
