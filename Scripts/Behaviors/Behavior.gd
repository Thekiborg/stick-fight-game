@abstract class_name Behavior extends Resource

func do(character: Character) -> void:
	on_end(character)

func can_run(_character: Character) -> bool:
	return true;

func on_end(character: Character) -> void:
	character.evaluate_behavior()
