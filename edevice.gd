extends TileMap

var select: int = 1
var offset: int = 0
const one_to_four = [1,2,3,4]

func _ready():
	for i in one_to_four:
			get_node("Scroller/Label" + str(select)).add_color_override("font_color", Color8(0xff, 0xff, 0xff))
	get_node("Scroller/Label1").add_color_override("font_color", Color8(0x55, 0xe1, 0xff))

func _process(delta: float):
	if visible:
		
		# REPLACE WITH BETTER CODE ONCE ALL CREATURES HAVE BEEN MADE
		get_node("Deets/Name").text = (Creatures.data[offset + select]["name"] + " (#" + str(Creatures.data[offset + select]["edeviceid"]) + ")") if GlobalVars.e_device_caught.has(offset + select) else "---"
		get_node("Deets/Descriptor").text = (Creatures.data[offset + select]["edevicedescriptor"] + " Elecree") if GlobalVars.e_device_caught.has(offset + select) else "---"
		get_node("Deets/HTWT").text = ("HT: " + str(Creatures.data[offset + select]["edeviceheight"]) + " m, WT: " + str(Creatures.data[offset + select]["edeviceweight"]) + " kg") if GlobalVars.e_device_caught.has(offset + select) else "HT: --, WT: --" # LOCALIZE THIS ON RELEASE
		get_node("Deets/Element").text = "ELEMENT: --" # CHANGE ONCE ELEMENTS ARE ADDED
		get_node("FlavorText").text = (Creatures.data[offset + select]["edeviceentry"]) if GlobalVars.e_device_caught.has(offset + select) else "---"
		
		for i in one_to_four:
			#print("Offset + Select = " + str(offset+select))
			get_node("Scroller/Label" + str(i)).text = Creatures.data[offset + i]["name"] if GlobalVars.e_device_caught.has(offset + i) else "---"
		if Input.is_action_just_pressed("ui_down") && select + offset <= 69:
			if select >= 4:
				offset += 1
			else:
				select += 1
				get_node("Scroller/Label" + str(select)).add_color_override("font_color", Color8(0x55, 0xe1, 0xff))
				get_node("Scroller/Label" + str(select - 1)).add_color_override("font_color", Color8(0xff, 0xff, 0xff))
			print("Down. Offset: " + str(offset) + " Select: " + str(select))
		if Input.is_action_just_pressed("ui_up") && select + offset >= (1 if GlobalVars.devMode else 2):
			if select <= 1:
				offset -= 1
			else:
				select -= 1
				get_node("Scroller/Label" + str(select)).add_color_override("font_color", Color8(0x55, 0xe1, 0xff))
				get_node("Scroller/Label" + str(select + 1)).add_color_override("font_color", Color8(0xff, 0xff, 0xff))
			print("Up. Offset: " + str(offset) + " Select: " + str(select))
	if Input.is_action_just_pressed("ui_cancel"):
		visible = false
		offset = 0
		select = 1
		_ready()
		GlobalVars.cutscenePlaying = false
