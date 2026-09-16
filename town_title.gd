extends CanvasLayer
class_name TownTitle

func _ready():
	while offset.y < 16:
		offset.y += 1
		yield(get_tree(), "physics_frame")
	yield(get_tree().create_timer(1.5), "timeout")
	while offset.y > 0:
		offset.y -= 1
		yield(get_tree(), "physics_frame")
	hide()
	get_node("TileMap").hide()
