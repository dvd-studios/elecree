extends KinematicBody2D
class_name PlayerMove

onready var global = get_node("/root/GLOBAL_VARS")
var isMoving
var velocity = Vector2.ZERO
var current_tile: int
var current_upper_tile: int
var current_lower_tile: int
var tilemap: GetTileType

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	print("Initialized playermove.gd")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
# warning-ignore:unused_argument
func _physics_process(delta):
	tilemap = get_parent().get_node("TileMap") as GetTileType
	current_tile = tilemap.get_current_tile()
	current_upper_tile = tilemap.get_current_tile("upper")
	current_lower_tile = tilemap.get_current_tile("lower")
	if !global.cutscenePlaying:
		if [current_upper_tile, current_lower_tile].has(127):
			position += Vector2(0, 1)
		elif [current_upper_tile, current_lower_tile].has(128):
			position += Vector2(1, 0)
		elif [current_upper_tile, current_lower_tile].has(129):
			position += Vector2(-1, 0)
		elif [current_upper_tile, current_lower_tile].has(130):
			position += Vector2(0, -1)
		else:
			if Input.is_action_pressed("ui_left"):
				velocity.x = -1
				
			elif Input.is_action_pressed("ui_right"):
				velocity.x = 1
			
			else:
				velocity.x = 0
		
			if Input.is_action_pressed("ui_up"):
				velocity.y = -1
	
			elif Input.is_action_pressed("ui_down"):
				velocity.y = 1
			else:
				velocity.y = 0
	# MOTION!
# warning-ignore:return_value_discarded
			move_and_collide(velocity)

func _process(delta):
	if Input.is_action_pressed("ui_left"):
		isMoving = true
		
	elif Input.is_action_pressed("ui_right"):
		isMoving = true
	
	elif Input.is_action_pressed("ui_up"):
		isMoving = true
	
	elif Input.is_action_pressed("ui_down"):
		isMoving = true
	
	else:
		isMoving = false


