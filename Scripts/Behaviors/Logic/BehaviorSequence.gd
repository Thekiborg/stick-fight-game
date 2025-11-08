class_name BehaviorSequence extends BehaviorLogic

func do(character: Character) -> void:
	for b: Behavior in behaviors:
		if b.can_run(character):
			character.cur_behavior = b.duplicate(true)
			break;
