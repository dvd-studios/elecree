extends Resource
class_name ElecreeTemplate

export var dnahp: int
export var dnaat: int
export var dnadf: int
export var dnasp: int
export var dnast: int
export var level: int
export var species: int

func _init(hp: int, at: int, df: int, sp: int, st: int, lv: int, id: int):
	dnahp = hp
	dnaat = at
	dnadf = df
	dnasp = sp
	dnast = st
	level = lv
	species = id

func to_elecree() -> Elecree:
	var hp: int = dnahp
	if dnahp == -1:
		hp = int(rand_range(0, 5))
	var at: int = dnaat
	if dnaat == -1:
		at = int(rand_range(0, 5))
	var df: int = dnadf
	if dnadf == -1:
		df = int(rand_range(0, 5))
	var sp: int = dnasp
	if dnasp == -1:
		sp = int(rand_range(0, 5))
	var st: int = dnast
	if dnast == -1:
		st = int(rand_range(0, 5))
	return Elecree.new(hp, at, df, sp, st, level, species)

static func make_random_elecree(lv: int, id: int) -> Elecree:
	return Elecree.new(int(rand_range(0, 5)), int(rand_range(0, 5)), int(rand_range(0, 5)), int(rand_range(0, 5)), int(rand_range(0, 5)), lv, id)
