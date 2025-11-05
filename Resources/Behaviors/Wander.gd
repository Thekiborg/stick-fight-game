class_name Wander extends Behavior

@export var wander_radius:float = 5;

func Do(character: Character) -> void:
	var distance: float = randf_range(0, wander_radius)	
	var dir: float = randf_range(-PI, PI);
	
	var dirVector: Vector2 = Vector2(cos(dir), sin(dir)).normalized()

	var dest:Vector2 = character.position + dirVector * distance;
	character.set_wanted_pos(dest)
	character.navigation_agent.get_next_path_position()
