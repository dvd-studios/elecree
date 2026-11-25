extends Sprite
class_name AlternatorFrontend

export var towards_player: Texture
export var away_from_player: Texture

func _process(delta: float):
	if GIMMICKS.alternator == 0:
		texture = towards_player
	else:
		texture = away_from_player
