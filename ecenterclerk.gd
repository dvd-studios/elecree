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
	print("Initialized ecenterclerk.gd")
	cubes = [$Cube1, $Cube2, $Cube3, $Cube4, $Cube5, $Cube6, $Cube7]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept") && !asking:
		print(interactNumber)
		if global.closestInteractable == "ecenterclerk":
			if interactNumber == 0 && !global.cutscenePlaying:
				global.cutscenePlaying = true
				textbox.visible = true
				textboxlabel1.text = "Welcome to the Elecree"
				textboxlabel2.text = "Building!"
				textboxlabel3.text = ""
				interactNumber += 1
			elif interactNumber == 1:
				print("Interact is 1 and started")
				asking = true
				Yesno.get_node("CanvasLayer/QuestionLabel").ask_question("Would you like me to heal your creatures?")
				healing = yield(Yesno.get_node("CanvasLayer/QuestionLabel"), "answer")
				yield(get_tree(), "idle_frame")
				print("Healing:" + str(healing))
				interactNumber += 1
				if healing:
					textbox.visible = false
					get_node("Sprite").frame = 6
					for elc in team.team.size():
						if team.team[elc] != null:
							team.team[elc].heal()
							cubes[elc].visible = true
						yield(get_tree().create_timer(0.5), "timeout")
					yield(get_tree().create_timer(0.5), "timeout")
					for i in 2:
						for cube in cubes:
							cube.texture = load("res://MiscSprites/ecentercubeheal.png")
						yield(get_tree().create_timer(0.5), "timeout")
						for cube in cubes:
							cube.texture = load("res://MiscSprites/ecentercube.png")
						yield(get_tree().create_timer(0.5), "timeout")
					for cube in cubes:
						cube.visible = false
					asking = false
					textbox.visible = true
					get_node("Sprite").frame = 0
					textboxlabel1.text = "Thank you for waiting!"
					textboxlabel2.text = ""
					textboxlabel3.text = ""
					print("How often is this being called? Anyways the interact number is " + str(interactNumber))
				else:
					asking = false
					interactNumber = 0
					textbox.visible = false
					GlobalVars.cutscenePlaying = false
			elif interactNumber == 2:
				textboxlabel1.text = "Your creatures have been"
				textboxlabel2.text = "healed to full health."
				textboxlabel3.text = ""
				interactNumber += 1
			elif interactNumber == 3:
				textboxlabel1.text = "Have a nice day!"
				textboxlabel2.text = ""
				textboxlabel3.text = ""
				interactNumber += 1
			elif interactNumber == 4:
				textbox.visible = false
				global.cutscenePlaying = false
				interactNumber = 0
				
	if Input.is_action_just_pressed("ui_cancel"):
		print("Closest Interactable:" + global.closestInteractable)



func _on_ECenterClerk_body_entered(body):
	print(body)
	if body.name == "Player":
		global.closestInteractable = "ecenterclerk"
	
func _on_ECenterClerk_body_exited(body):
	global.closestInteractable = "null"
