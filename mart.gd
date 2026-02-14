extends Node2D
class_name Mart

var select: int = 0
var offset: int = 0
var asking: bool = false

var items: Array = [
	[MartItem.new("Capture Cube"), MartItem.new("Health Potion"), MartItem.new("Stamina Potion")] # Items for sale at start of game
	
	
]

onready var labels: Array = [$CanvasLayer/VBoxContainer/Label1, $CanvasLayer/VBoxContainer/Label2, $CanvasLayer/VBoxContainer/Label3, $CanvasLayer/VBoxContainer/Label4, $CanvasLayer/VBoxContainer/Label5]

var current_items: Array
var quantities: Array

class MartItem:
	
	var prices: Dictionary = {
	
	"Capture Cube": 30,
	"Health Potion": 20,
	"Stamina Potion": 20
	}
	func get_price() -> int:
		if prices.has(name):
			return prices[name]
		else:
			return 0
	
	var name: String
	
	func _init(name: String):
		self.name = name
	

func _ready():
	generate_current_items()

func generate_current_items():
	current_items = []
	quantities = []
	for item in items[0]:
		current_items.push_back(item)
		quantities.push_back(0)
	for i in 10: # Final amount of medallions 
		if GLOBAL_VARS.get_flag("passed_gate_" + str(i)):
			for item in items[i]:
				current_items.push_back(item)
				quantities.push_back(0)
		else:
			break
	current_items.sort_custom(self, "a_comes_first")

func a_comes_first(a: MartItem, b: MartItem):
	return a.name < b.name

func get_total_due() -> int:
	var total_due: int = 0
	for i in current_items.size():
		total_due += current_items[i].get_price() * quantities[i]
	return total_due

func _process(delta: float):
	get_node("CanvasLayer").visible = visible
	get_node("CanvasLayer/TileMap").visible = visible
	
	if visible && !asking:
		
		var total: int = select + offset
		
		if Input.is_action_just_pressed("ui_down"):
			if total + 1 < current_items.size():
				if select >= 5:
					offset += 1
				else:
					select += 1
					
		if Input.is_action_just_pressed("ui_up"):
			if total - 1 >= 0:
				if select <= 0:
					offset -= 1
				else:
					select -= 1
		
		if Input.is_action_just_pressed("ui_right"):
			quantities[total] += 1
		
		if Input.is_action_just_pressed("ui_left"):
			if quantities[total] > 0:
				quantities[total] -= 1
		
		if Input.is_action_just_pressed("ui_accept"):
			if get_total_due() > GLOBAL_VARS.credits:
				get_node("CanvasLayer/VBoxContainer/YourMoney").add_color_override("font_color", Color(1, 0, 0))
				yield(get_tree().create_timer(5), "timeout")
				get_node("CanvasLayer/VBoxContainer/YourMoney").add_color_override("font_color", Color(0, 0, 0))
			else:
				asking = true
				YES_NO.get_node("CanvasLayer/QuestionLabel").ask_question("TOTAL DUE: Cr" + str(get_total_due()) + "\nAccept?")
				var approved: bool = yield(YES_NO.get_node("CanvasLayer/QuestionLabel"), "answer")
				asking = false
				if approved:
					GLOBAL_VARS.credits -= get_total_due()
					for i in current_items.size():
						var current_item: MartItem = current_items[i]
						for j in quantities[i]:
							BAG.item_bag.push_back(current_item.name)
					generate_current_items()
		
		if Input.is_action_just_pressed("ui_cancel"):
			visible = false
			GLOBAL_VARS.cutscenePlaying = false
		
		for l in labels.size():
			if current_items.size() > l + offset:
				labels[l].text = current_items[l + offset].name + ": Cr" + str(current_items[l + offset].get_price()) + " (x" + str(quantities[l + offset]) + ")"
			else:
				labels[l].text = ""
			
			if select == l:
				labels[l].add_color_override("font_color", Color(1, 1, 1))
			else:
				labels[l].add_color_override("font_color", Color(0, 0, 0))
		
		get_node("CanvasLayer/VBoxContainer/TotalDue").text = "TOTAL DUE: Cr" + str(get_total_due())
		get_node("CanvasLayer/VBoxContainer/YourMoney").text = "YOUR MONEY: Cr" + str(GLOBAL_VARS.credits)
		
func wait_and_show():
	yield(get_tree(), "idle_frame")
	visible = true
	generate_current_items()
