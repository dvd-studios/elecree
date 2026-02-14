extends Node2D
class_name StarterSelector

var row: int = 0
var column: int = 0

signal emit_species(species)

func _process(delta: float):
	get_node("CanvasLayer").visible = visible
	get_node("CanvasLayer/TileMap").visible = visible
	if visible:
		if Input.is_action_just_pressed("ui_down"):
			row = 1
			if column == 2:
				column = 1
	
		if Input.is_action_just_pressed("ui_up"):
			row = 0
	
		if Input.is_action_just_pressed("ui_left"):
			if column > 0:
				column -= 1
	
		if Input.is_action_just_pressed("ui_right"):
			if (row == 0 && column < 2) || (row == 1 && column < 1):
				column += 1
		
		if Input.is_action_just_pressed("ui_accept"):
			emit_signal("emit_species", return_species_number_and_set_flag())
			hide()
	
		color_labels()

func color_labels():
	get_node("CanvasLayer/Dracospark").add_color_override("font_color", Color(1, 1, 1))
	get_node("CanvasLayer/Mizukoi").add_color_override("font_color", Color(1, 1, 1))
	get_node("CanvasLayer/Watty").add_color_override("font_color", Color(1, 1, 1))
	get_node("CanvasLayer/Earthle").add_color_override("font_color", Color(1, 1, 1))
	get_node("CanvasLayer/Futori").add_color_override("font_color", Color(1, 1, 1))
	var rowcol: int = 3 * row + column
	match rowcol:
		0:
			get_node("CanvasLayer/Dracospark").add_color_override("font_color", Color8(0x55, 0xe1, 0xff))
		1:
			get_node("CanvasLayer/Watty").add_color_override("font_color", Color8(0x55, 0xe1, 0xff))
		2:
			get_node("CanvasLayer/Futori").add_color_override("font_color", Color8(0x55, 0xe1, 0xff))
		3:
			get_node("CanvasLayer/Mizukoi").add_color_override("font_color", Color8(0x55, 0xe1, 0xff))
		4:
			get_node("CanvasLayer/Earthle").add_color_override("font_color", Color8(0x55, 0xe1, 0xff))

func return_species_number_and_set_flag():
	var rowcol: int = 3 * row + column
	match rowcol:
		0:
			GLOBAL_VARS.set_flag("starter:dracospark", true)
			return 1
		1:
			GLOBAL_VARS.set_flag("starter:watty", true)
			return 7
		2:
			GLOBAL_VARS.set_flag("starter:futori", true)
			return 13
		3:
			GLOBAL_VARS.set_flag("starter:mizukoi", true)
			return 4
		4:
			GLOBAL_VARS.set_flag("starter:earthle", true)
			return 10
		_:
			return 0

func wait_and_show():
	yield(get_tree(), "idle_frame")
	show()
