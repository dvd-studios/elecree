extends BattleManager
class_name Gate1Battle

var total_time: float

func _process(delta: float):
	._process(delta)
	if lock == 0 && !flavortext:
		total_time += delta
		if total_time >= 1.0 / 60.0:
			GIMMICKS.alternator += 1
			GIMMICKS.alternator %= 2
			total_time -= 1.0 / 60.0
