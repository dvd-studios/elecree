extends Node2D
class_name BattleManager

signal z_press()
var lock: int = 0
var lock_cache: int = 0
var flavortext: bool = false
var battler_name: String
var win_flag: String
var prize_credits: int
onready var team = get_node("/root/TEAM")
onready var dict = load("res://creatures.tres").data
onready var player = $PlayerElecree.data
onready var opponent = $OpposingElecree.data
var creatures_that_will_gain_exp: Array = []
var winning_sequence: bool = false

func _ready():
	creatures_that_will_gain_exp.push_back(player)
	if GLOBAL_VARS.wild:
		yield(display_text(["A wild " + opponent.get_name() + " appeared!"]), "completed")
	else:
		battler_name = GLOBAL_VARS.battler_name
		win_flag = GLOBAL_VARS.win_flag
		prize_credits = GLOBAL_VARS.prize_credits
		yield(display_text([battler_name + " is initiating a battle!", opponent.get_name() + " was sent out!"]), "completed")
	yield(display_text(["Go, " + player.get_name() + "!"]), "completed")

func _process(delta):
	if lock_cache != lock:
		print("Lock changed to " + str(lock))
		lock_cache = lock
	
	if Input.is_action_just_pressed("ui_accept"):
		emit_signal("z_press")
	
	if lock == 0 && !flavortext:
		player.recharge += player.currentsp * delta
		player.recharge = 100 if player.recharge > 100 else player.recharge
		opponent.recharge += opponent.currentsp * delta
		opponent.recharge = 100 if opponent.recharge > 100 else opponent.recharge
		
		if player.status == 0 && float(player.currenthp) / player.stathp <= .2:
			player.change_status(5) # Limit
			print("Limit on Player")
		
		if opponent.status == 0 && float(opponent.currenthp) / opponent.stathp <= .2:
			opponent.change_status(5) # Limit
			print("Limit on Opponent")
		
		if player.status == 5 && float(player.currenthp) / player.stathp > .2:
			player.change_status(0)
		
		if opponent.status == 5 && float(opponent.currenthp) / opponent.stathp > .2:
			opponent.change_status(0) # Limit
	
	if lock == 1 && Input.is_action_just_pressed("ui_accept"):
		lock = 3
		get_node("MoveSelector").wait_and_show()
	
	#if lock == 2:
	
	
	if get_node("PlayerElecree").data.currentst < 0:
		get_node("PlayerElecree").data.currenthp += get_node("PlayerElecree").data.currentst
		get_node("PlayerElecree").data.currentst = 0
	
	if get_node("OpposingElecree").data.currentst < 0:
		get_node("OpposingElecree").data.currenthp += get_node("OpposingElecree").data.currentst
		get_node("OpposingElecree").data.currentst = 0
	
	if player.currenthp <= 0 && !flavortext && lock != 2:
		yield(display_text([player.get_name() + " is defeated!"]), "completed")
		if is_player_defeated():
			yield(display_text([GLOBAL_VARS.player_name + " has no more usable Elecree!", GLOBAL_VARS.player_name + " lost the battle!"]), "completed")
			player.recharge = 0
			for elc in TEAM.team:
				if elc != null:
					elc.heal()
			GLOBAL_VARS.cutscenePlaying = false
			#TEAM.TEAM[0] = player.duplicate(true)
			GLOBAL_VARS._warpPlayer(Vector2(64, 88), GLOBAL_VARS.last_e_center)
		else:
			lock = 2
			get_node("CreatureSwitcher").wait_and_show()
	
#	if opponent.currenthp <= 0 && !flavortext:
#		player.recharge = 0
#		#TEAM.TEAM[0] = player.duplicate()
#		print(TEAM.TEAM[0].currenthp)
#		global.cutscenePlaying = false
#		global._warpPlayer(global.last_pos, global.last_loc)
	
	if [0, 1].has(lock):
		if player.recharge >= 100:
			if player.status != 3:
				lock = 1
			else:
				player.change_status(-1)
				player.recharge = 0
		elif opponent.recharge >= 100:
			if opponent.status != 3 && opponent.currenthp > 0: # Assertation that currenthp > 0 (opponent is not KO) cuz im not gonna bother rewriting this just so this method doesn't get called lol
				lock = -1
				var attack = get_node("OpposingElecree").enemy_ai()
				yield(get_node("OpposingElecree").attack(get_node("PlayerElecree").data, attack), "completed")
				lock = 0
			else:
				opponent.change_status(-1)
				opponent.recharge = 0
	
	if lock == 1:
		get_node("CanvasLayer/InfoBox/HBoxContainer/Name").add_color_override("font_color", Color(1.0, 1.0, 1.0))
		get_node("CanvasLayer/InfoBox/HBoxContainer/Level").add_color_override("font_color", Color(1.0, 1.0, 1.0))
		get_node("CanvasLayer/InfoBox/HBoxContainer/Status").add_color_override("font_color", Color(1.0, 1.0, 1.0))
		get_node("CanvasLayer/InfoBox/HBoxContainer/Recharge").add_color_override("font_color", Color(1.0, 1.0, 1.0))
	else:
		get_node("CanvasLayer/InfoBox/HBoxContainer/Name").add_color_override("font_color", Color(0.0, 0.0, 0.0))
		get_node("CanvasLayer/InfoBox/HBoxContainer/Level").add_color_override("font_color", Color(0.0, 0.0, 0.0))
		get_node("CanvasLayer/InfoBox/HBoxContainer/Status").add_color_override("font_color", Color(0.0, 0.0, 0.0))
		get_node("CanvasLayer/InfoBox/HBoxContainer/Recharge").add_color_override("font_color", Color(0.0, 0.0, 0.0))
	
	get_node("CanvasLayer/OpponentInfoBox/Name").text = opponent.get_name() if !GLOBAL_VARS.wild else dict[opponent.species]["name"]
	get_node("CanvasLayer/OpponentInfoBox/Level").text = ":L" + str(opponent.level)
	get_node("CanvasLayer/OpponentInfoBox/Status").text = Creatures.status_to_string(opponent.status)
	get_node("CanvasLayer/OpponentInfoBox/Recharge").text = str(int(opponent.recharge))
	get_node("CanvasLayer/OpponentHPBox/HP").text = "H: " + str(opponent.currenthp)
	get_node("CanvasLayer/OpponentHPBox/SP").text = "S: " + str(opponent.currentst)
	
	if !flavortext:
		get_node("CanvasLayer/InfoBox/HBoxContainer/Name").text = player.get_name()
		get_node("CanvasLayer/InfoBox/HBoxContainer/Level").text = ":L" + str(player.level)
		get_node("CanvasLayer/InfoBox/HBoxContainer/Status").text = Creatures.status_to_string(player.status)
		get_node("CanvasLayer/InfoBox/HBoxContainer/Recharge").text = str(int(player.recharge))
		get_node("CanvasLayer/PlayerHPBox/HP").text = "H: " + str(player.currenthp)
		get_node("CanvasLayer/PlayerHPBox/SP").text = "S: " + str(player.currentst)

func refresh_creatures():
	player = $PlayerElecree.data
	opponent = $OpposingElecree.data


func display_text(text: Array):
	print("text should be displaying: " + text[0])
	flavortext = true
	get_node("CanvasLayer/InfoBox/HBoxContainer").hide()
	get_node("CanvasLayer/InfoBox/FullBox").show()
	for x in text:
		if x != "":
			get_node("CanvasLayer/InfoBox/FullBox").text = x
			yield(get_tree(), "idle_frame")
			yield(self, "z_press")
	get_node("CanvasLayer/InfoBox/FullBox").hide()
	get_node("CanvasLayer/InfoBox/HBoxContainer").show()
	flavortext = false

func is_player_defeated() -> bool:
	for e in TEAM.team:
		if e != null && e.currenthp > 0:
			return false
	return true

func win_battle():
	winning_sequence = true
	if !GLOBAL_VARS.wild:
		yield(display_text(["You defeated " + battler_name + "!"]), "completed")
		GLOBAL_VARS.set_flag(win_flag, true)
		yield(display_text(["You won Cr" + str(prize_credits) + "!"]), "completed")
		GLOBAL_VARS.credits += prize_credits
	for i in TEAM.team:
		if i != null:
			i.recharge = 0
			i.partheal()
			if i.status == 3:
				i.change_status(-1)
	#TEAM.TEAM[0] = player.duplicate()
	#print(TEAM.TEAM[0].currenthp)
	GLOBAL_VARS.cutscenePlaying = false
	GLOBAL_VARS._warpPlayer(GLOBAL_VARS.last_pos, GLOBAL_VARS.last_loc)
