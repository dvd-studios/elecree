extends Area2D
class_name ECenterClerk

var interactNumber: int
onready var global = get_node("/root/GLOBAL_VARS")
onready var textbox = get_node("/root/TEXTBOX/TextBox")
onready var textboxlabel = get_node("/root/TEXTBOX/TextBox/VBoxContainer/Label")

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
				textboxlabel.text = "Welcome to the Elecree Building!"
				interactNumber += 1
			elif interactNumber == 1:
				print("Interact is 1 and started")
				asking = true
				YES_NO.get_node("CanvasLayer/QuestionLabel").ask_question("Would you like me to heal your creatures?")
				healing = yield(YES_NO.get_node("CanvasLayer/QuestionLabel"), "answer")
				yield(get_tree(), "idle_frame")
				print("Healing:" + str(healing))
				interactNumber += 1
				if healing:
					GLOBAL_VARS.last_e_center = get_tree().current_scene.filename
					textbox.visible = false
					get_node("Sprite").frame = 6
					for elc in TEAM.team.size():
						if TEAM.team[elc] != null:
							TEAM.team[elc].heal()
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
					textboxlabel.text = "Thank you for waiting!"
					print("How often is this being called? Anyways the interact number is " + str(interactNumber))
				else:
					asking = false
					interactNumber = 0
					textbox.visible = false
					GLOBAL_VARS.cutscenePlaying = false
			elif interactNumber == 2:
				textboxlabel.text = "Your creatures have been healed to full health."
				interactNumber += 1
			elif interactNumber == 3:
				textboxlabel.text = "Have a nice day!"
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
	if global.closestInteractable == "ecenterclerk":
		global.closestInteractable = "null"
