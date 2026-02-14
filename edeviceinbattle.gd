extends TileMap
class_name BattleEDevice

var select: int = 1
var offset: int = 0
const one_to_four = [1,2,3,4]
onready var nodes: Array = [$Scroller/Label1, $Scroller/Label2, $Scroller/Label3, $Scroller/Label4]

func _ready():
	get_node("Scroller/Label2").add_color_override("font_color", Color8(0xff, 0xff, 0xff))
	get_node("Scroller/Label3").add_color_override("font_color", Color8(0xff, 0xff, 0xff))
	get_node("Scroller/Label4").add_color_override("font_color", Color8(0xff, 0xff, 0xff))
	get_node("Scroller/Label1").add_color_override("font_color", Color8(0x55, 0xe1, 0xff))

func _process(delta: float):
	if visible:
		
		for n in nodes.size():
			var one_based: int = n + 1
			if select == one_based:
				nodes[n].add_color_override("font_color", Color8(0x55, 0xe1, 0xff))
			else:
				nodes[n].add_color_override("font_color", Color8(0xff, 0xff, 0xff))
		
		# REPLACE WITH BETTER CODE ONCE ALL CREATURES HAVE BEEN MADE
		get_node("Deets/Name").text = (Creatures.data[offset + select]["name"] + " (#" + str(Creatures.data[offset + select]["edeviceid"]) + ")") if GLOBAL_VARS.e_device_caught.has(offset + select) else "---"
		get_node("Deets/Descriptor").text = (Creatures.data[offset + select]["edevicedescriptor"] + " Elecree") if GLOBAL_VARS.e_device_caught.has(offset + select) else "---"
		get_node("Deets/HTWT").text = ("HT: " + str(Creatures.data[offset + select]["edeviceheight"]) + " m, WT: " + str(Creatures.data[offset + select]["edeviceweight"]) + " kg") if GLOBAL_VARS.e_device_caught.has(offset + select) else "HT: --, WT: --" # LOCALIZE THIS ON RELEASE
		get_node("Deets/Element").text = ("ELEMENT: " + Creatures.element_names[Creatures.data[offset + select]["element"]]) if GLOBAL_VARS.e_device_caught.has(offset + select) else "ELEMENT: --"
		get_node("FlavorText").text = (Creatures.data[offset + select]["edeviceentry"]) if GLOBAL_VARS.e_device_caught.has(offset + select) else "---"
		
		for i in one_to_four:
			#print("Offset + Select = " + str(offset+select))
			get_node("Scroller/Label" + str(i)).text = Creatures.data[offset + i]["name"] if GLOBAL_VARS.e_device_caught.has(offset + i) else "---"

func set_number(number: int):
	if number >= 67:
		offset = 66
		select = number - 66
	else:
		offset = number - 1
		select = 1
