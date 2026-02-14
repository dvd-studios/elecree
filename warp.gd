extends Node
class_name Warp

export var destination: String
export var coord: Vector2
export var relative: bool

onready var global = get_node("/root/GLOBAL_VARS")


# Called when the node enters the scene tree for the first time.
func _ready():
	print()





func _on_Area2D_body_entered(body):
	if body.name == "Player":
		print("Warping...")
		global._warpPlayer(coord, destination, relative)
