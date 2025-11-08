class_name Stand extends Behavior

func _get_name() -> String: return "Stand"

@export var wait_time: float = 1.0
var _waited: float = 0

func do(character: Character) -> void:
	_waited += character.get_physics_process_delta_time()
	if _waited > wait_time:
		on_end(character)
