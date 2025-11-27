extends Area2D
var interactNumber: int
onready var global = get_node("/root/GlobalVars")
onready var textbox = get_node("/root/Textbox/TextBox")
onready var textboxlabel1 = get_node("/root/Textbox/TextBox/VBoxContainer/Label")
onready var textboxlabel2 = get_node("/root/Textbox/TextBox/VBoxContainer/HBoxContainer/Label")
onready var textboxlabel3 = get_node("/root/Textbox/TextBox/VBoxContainer/HBoxContainer2/Label")


func _ready():
	interactNumber = 0
	print("Initialized loresign.gd")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		print(interactNumber)
		if global.closestInteractable == "boxterm":
			if interactNumber == 0 && !global.cutscenePlaying:
				global.cutscenePlaying = true
				textbox.visible = true
				textboxlabel1.text = "Welcome to the"
				textboxlabel2.text = "Creature Box Terminal!"
				textboxlabel3.text = ""
				interactNumber += 1
			elif interactNumber == 1:
				textboxlabel1.text = ""
				textboxlabel2.text = ""
				textboxlabel3.text = ""
				textbox.visible = false
				Creaturebox.wait_and_show()
				interactNumber = 0
	if Input.is_action_just_pressed("ui_cancel"):
		print("Closest Interactable:" + global.closestInteractable)
		



func _on_Area2D_body_entered(body):
	print(body)
	if body.name == "Player":
		global.closestInteractable = "boxterm"
	
func _on_Area2D_body_exited(body):
	global.closestInteractable = "null"

