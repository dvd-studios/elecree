extends Node2D
class_name BoxUI

var box_offset: int = 0
var select: int = 0
var in_box: bool = false
var in_details: bool = false

var party_labels: Array
var box_labels: Array
var transfer: bool = true

func _ready():
	party_labels = [
		$CanvasLayer/TileMap/CreaturesInParty/Label,
		$CanvasLayer/TileMap/CreaturesInParty/Label2,
		$CanvasLayer/TileMap/CreaturesInParty/Label3,
		$CanvasLayer/TileMap/CreaturesInParty/Label4,
		$CanvasLayer/TileMap/CreaturesInParty/Label5,
		$CanvasLayer/TileMap/CreaturesInParty/Label6,
		$CanvasLayer/TileMap/CreaturesInParty/Label7
	]
	
	box_labels = [
		$CanvasLayer/TileMap/CreaturesInBox/Label,
		$CanvasLayer/TileMap/CreaturesInBox/Label2,
		$CanvasLayer/TileMap/CreaturesInBox/Label3,
		$CanvasLayer/TileMap/CreaturesInBox/Label4,
		$CanvasLayer/TileMap/CreaturesInBox/Label5,
		$CanvasLayer/TileMap/CreaturesInBox/Label6,
		$CanvasLayer/TileMap/CreaturesInBox/Label7
	]

func get_item_or_null(array: Array, where: int):
	if array.size() > where && where >= 0:
		return array[where]
	else:
		return null

func deposit_creature(which: int):
	TEAM.creature_box.push_back(TEAM.team[which])
	TEAM.team[which] = null
	TEAM.move_all_nulls_back()

func withdraw_creature(which: int):
	var where_to_place: int = TEAM.get_team_size()
	if where_to_place < 7:
		TEAM.team[where_to_place] = TEAM.creature_box[which]
		TEAM.creature_box.pop_at(which)

func get_current_array():
	if in_box:
		return TEAM.creature_box
	else:
		return TEAM.team

func wait_and_show():
	yield(get_tree(), "idle_frame")
	box_offset = 0
	select = 0
	in_box = false
	transfer = true
	show()

func get_non_null_creature_text(creature: Elecree) -> String:
	if creature != null:
		var text: String = ""
		text += creature.get_name()
		return text
	else:
		return ""

func box_offset_if_in_box() -> int:
	if in_box:
		return box_offset
	else:
		return 0

func _process(delta: float):
	get_node("CanvasLayer").visible = visible
	get_node("CanvasLayer/TileMap").visible = visible
	if visible:
		get_node("CanvasLayer/TileMap/Label").text = ("TRANSFER" if transfer else "DETAILS") + " : ENTER=CHANGE MODE"
		for i in 7:
			party_labels[i].text = get_non_null_creature_text(get_item_or_null(TEAM.team, i))
			party_labels[i].add_color_override("font_color", Color(0,0,0))
			box_labels[i].text = get_non_null_creature_text(get_item_or_null(TEAM.creature_box, i + box_offset))
			box_labels[i].add_color_override("font_color", Color(0,0,0))
		if in_box:
			box_labels[select].add_color_override("font_color", Color(1, 1, 1))
		else:
			party_labels[select].add_color_override("font_color", Color(1, 1, 1))
		
		if !in_details:
			if Input.is_action_just_pressed("ui_down"):
				if get_non_null_creature_text(get_item_or_null(get_current_array(), select + box_offset_if_in_box() + 1)) != "":
					if select < 6:
						select += 1
					elif in_box:
						box_offset += 1
			if Input.is_action_just_pressed("ui_up"):
				if get_non_null_creature_text(get_item_or_null(get_current_array(), select + box_offset_if_in_box() - 1)) != "":
					if select > 0:
						select -= 1
					elif in_box:
						box_offset -= 1
			if Input.is_action_just_pressed("ui_left"):
				if get_non_null_creature_text(get_item_or_null(TEAM.team, select)) != "":
					in_box = false
			if Input.is_action_just_pressed("ui_right"):
				if get_non_null_creature_text(get_item_or_null(TEAM.creature_box, select + box_offset)) != "":
					in_box = true
			if Input.is_action_just_pressed("ui_accept"):
				if transfer:
					if in_box:
						withdraw_creature(select + box_offset)
						if TEAM.creature_box.size() == 0:
							in_box = false
						else:
							while get_non_null_creature_text(get_item_or_null(get_current_array(), select + box_offset)) == "":
								select -= 1
							while select < 0:
								box_offset -= 1
								select += 1
					else:
						if TEAM.get_team_size() > 1:
							deposit_creature(select)
							if select >= TEAM.get_team_size():
								select = TEAM.get_team_size() - 1
				else:
					get_node("CanvasLayer2/CreatureDetails").visible = true
					in_details = true
					if in_box:
						get_node("CanvasLayer2/CreatureDetails").creature_changed(get_item_or_null(TEAM.creature_box, select + box_offset))
					else:
						get_node("CanvasLayer2/CreatureDetails").creature_changed(get_item_or_null(TEAM.team, select))
			if Input.is_action_just_pressed("ui_select"):
				print(TEAM.creature_box)
				transfer = !transfer
			if Input.is_action_just_pressed("ui_cancel"):
				visible = false
				GLOBAL_VARS.cutscenePlaying = false
