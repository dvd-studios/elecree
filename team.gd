extends Node2D

var team: Array = [Elecree.new(3,3,3,3,3,3,0), null, null, null, null, null, null]
var creature_box: Array = [Elecree.new(0,0,0,0,0,0,0,"{\"attacks\":[\"Tackle\"],\"currenthp\":9,\"currentst\":18,\"dna_at\":3,\"dna_df\":3,\"dna_hp\":3,\"dna_sp\":3,\"dna_st\":3,\"experience\":400,\"level\":3,\"nickname\":\"\",\"species\":0,\"statat\":18,\"statdf\":18,\"stathp\":18,\"statsp\":18,\"statst\":18,\"status\":0}")]

func _init():
	print("test")

func get_team_size() -> int:
	var size: int = 0
	for i in self.team:
		if i != null:
			size += 1
	return size

func move_all_nulls_back():
	while self.team.has(null):
		self.team.pop_at(self.team.find(null))
	while self.team.size() < 7:
		self.team.push_back(null)
