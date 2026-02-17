extends TileMap
class_name GetTileType

var currentTile
var randomEncounter
var cdata = load("creatures.tres")
onready var global = get_node("/root/GLOBAL_VARS")
var how_many_tries: int = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	print("Initialized getTileType.gd")


# Called every frame. 'delta' is the elapsed time since the previous frame.


func _process(delta):
	
	if get_cellv(world_to_map(get_parent().get_node("Player/Sprite").global_position)) == 33: # tall grass
		randomEncounter = int(rand_range(1, int(2 / delta)))
		if get_parent().get_node("Player").isMoving && !global.cutscenePlaying:
			how_many_tries += 1
			if randomEncounter == 1:
				print("Tries: " + String(how_many_tries))
				how_many_tries = 0
				global.start_wild_battle(ElecreeTemplate.make_random_elecree(int(rand_range(2, 5)), 16), get_parent().get_node("Player").global_position,get_tree().current_scene.filename)
				#global.start_wild_battle(3,3,0,3,3,3,0,get_parent().get_node("Player").global_position,get_tree().current_scene.filename)

