extends Area2D
var interactNumber: int
onready var global = get_node("/root/GlobalVars")
onready var textbox = get_node("/root/Textbox/TextBox")
onready var textboxlabel = get_node("/root/Textbox/TextBox/VBoxContainer/Label")


func _ready():
	interactNumber = 0
	print("Initialized loresign.gd")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		print(interactNumber)
		if global.closestInteractable == "loresign":
			if interactNumber == 0 && !global.cutscenePlaying:
				global.cutscenePlaying = true
				textbox.visible = true
				textboxlabel.text = "In the year 22, we were at war. It was clear that we"
				interactNumber += 1
			elif interactNumber == 1:
				print(global.cutscenePlaying)
				textboxlabel.text = "were not going to win. However, our enemy, Rubia, had a powerful weapon:"
				interactNumber += 1
			elif interactNumber == 2:
				print(global.cutscenePlaying)
				textboxlabel.text = "The legendary Elecree, Victorium. Through Victorium, they"
				interactNumber += 1
			elif interactNumber == 3:
				textboxlabel.text = "dropped two power spheres on this country. One here, and one in New Life City,"
				interactNumber += 1
			elif interactNumber == 4:
				textboxlabel.text = "then known as Wide Isle City. The spheres left enormous craters, that are unsafe"
				interactNumber += 1
			elif interactNumber == 5:
				textboxlabel.text = "to enter, even today."
				interactNumber += 1
			elif interactNumber == 6:
				textbox.visible = false
				global.cutscenePlaying = false
				interactNumber = 0
	if Input.is_action_just_pressed("ui_cancel"):
		print("Closest Interactable:" + global.closestInteractable)
		



func _on_Area2D_body_entered(body):
	print(body)
	if body.name == "Player":
		global.closestInteractable = "loresign"
	
func _on_Area2D_body_exited(body):
	global.closestInteractable = "null"

