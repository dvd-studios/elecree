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


func get_current_tile(which: String = ""):
	var modifier: Vector2 = Vector2(0, 0)
	match which:
		"upper":
			modifier += Vector2(0, -8)
		"lower":
			modifier += Vector2(0, 8)
	return get_cellv(world_to_map(get_parent().get_node("Player/Sprite").global_position + modifier))

func _process(delta):
	if get_cellv(world_to_map(get_parent().get_node("Player/Sprite").global_position)) == 33: # tall grass
		randomEncounter = int(rand_range(1, int(2 / delta)))
		if get_parent().get_node("Player").isMoving && !global.cutscenePlaying:
			how_many_tries += 1
			if randomEncounter == 1:
				print("Tries: " + String(how_many_tries))
				how_many_tries = 0
				var current_scene: String = get_tree().current_scene.filename
				var level_and_species: Array = get_random_level_and_species(current_scene)
				global.start_wild_battle(ElecreeTemplate.make_random_elecree(level_and_species[0], level_and_species[1]), get_parent().get_node("Player").global_position, current_scene)
				#global.start_wild_battle(3,3,0,3,3,3,0,get_parent().get_node("Player").global_position,get_tree().current_scene.filename)

func get_random_level_and_species(scene: String) -> Array:
	print("Scene name on generation: " + scene)
	var output: Array = [int(rand_range(2, 5)), 16]
	match scene:
		"res://road1.tscn":
			output = [int(rand_range(2, 5)), 16]
		"res://Joejoe/Road2/overworld.tscn":
			output = [int(rand_range(3, 7)), get_random_item([16, 16, 16, 16, 16, 16, 16, 16, 16, 25])]
	return output

func get_random_item(input: Array):
	return input[rand_range(0, input.size())]
