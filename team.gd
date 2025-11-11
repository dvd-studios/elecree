extends Node2D

var team: Array = [Elecree.new(3,3,3,3,3,3,0), Elecree.new(3,3,3,3,3,3,0), null, null, null, null, null ]
var creature_box: Array = []

func _init():
	print("test")

func get_team_size() -> int:
	var size: int = 0
	for i in self.team:
		if i != null:
			size += 1
	return size
