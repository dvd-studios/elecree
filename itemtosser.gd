extends CanvasLayer

var tossable: int
var how_many_items: int = 0
var max_items: int
var which_item: String

func _process(delta: float):
	get_node("TileMap").visible = visible
	if visible:
		if Input.is_action_just_pressed("ui_up"):
			if how_many_items < max_items:
				how_many_items += 1
		if Input.is_action_just_pressed("ui_down"):
			if how_many_items > 0:
				how_many_items -= 1
		if Input.is_action_just_pressed("ui_accept"):
			for i in how_many_items:
				print("Popping at " + str(get_parent().item_bag.find_last(which_item)))
				get_parent().item_bag.pop_at(get_parent().item_bag.find_last(which_item))
			get_parent().refresh()
			visible = false
		if Input.is_action_just_pressed("ui_cancel"):
			visible = false
		get_node("Label").text = which_item + "\nToss how many?"
		get_node("Number").text = str(how_many_items)

func toss_how_many(item: String, maximum: int):
	yield(get_tree(), "idle_frame")
	visible = true
	print("Visible: " + str(visible))
	which_item = item
	max_items = maximum
	how_many_items = 0
