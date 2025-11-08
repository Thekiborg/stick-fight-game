class_name BehaviorSequence extends BehaviorLogic

func do(character: Character) -> void:
	for b: Behavior in behaviors:
		if b.can_run(character):
			b.do(character)
			break;
