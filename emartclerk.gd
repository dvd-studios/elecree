extends Area2D
var interactNumber: int
onready var global = get_node("/root/GlobalVars")
onready var textbox = get_node("/root/Textbox/TextBox")
onready var textboxlabel1 = get_node("/root/Textbox/TextBox/VBoxContainer/Label")
onready var textboxlabel2 = get_node("/root/Textbox/TextBox/VBoxContainer/HBoxContainer/Label")
onready var textboxlabel3 = get_node("/root/Textbox/TextBox/VBoxContainer/HBoxContainer2/Label")
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
				textboxlabel1.text = "Welcome to the E-Mart!"
				textboxlabel2.text = ""
				textboxlabel3.text = ""
				interactNumber += 1
			elif interactNumber == 1:
				textbox.visible = false
				Mart.wait_and_show()
				interactNumber = 0

				
	if Input.is_action_just_pressed("ui_cancel"):
		print("Closest Interactable:" + global.closestInteractable)



func _on_ECenterClerk_body_entered(body):
	print(body)
	if body.name == "Player":
		global.closestInteractable = "emartclerk"
	
func _on_ECenterClerk_body_exited(body):
	global.closestInteractable = "null"
