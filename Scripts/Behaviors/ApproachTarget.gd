class_name ApproachTarget extends Behavior

@export var distance_to_approach: float = 0.0

func do(character: Character) -> void:
	character.set_wanted_pos(character.find_target().position)

func can_run(character: Character) -> bool:
	var target: Character = character.find_target()

	if target && !character.attack_hitbox.overlaps_body(target):
		return true
	else:
		return true
