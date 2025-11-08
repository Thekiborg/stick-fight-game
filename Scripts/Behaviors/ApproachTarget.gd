class_name ApproachTarget extends Behavior

func do(character: Character) -> void:
	if character.cur_behavior is Attack:
		stop_pather(character)
		return;
		
	if character.attack_hitbox.overlaps_body(character.find_target()):
		stop_pather(character)
		return;
	
	character.set_wanted_pos(character.find_target().position)
	
	if character.navigation_agent.is_navigation_finished():
		#behavior.on_end(self)
		return
	
	character.animation_player.play("Running")
	
	var next_path_position: Vector2 = character.navigation_agent.get_next_path_position()
	character.velocity = character.global_position.direction_to(next_path_position) * character.movement_speed
	var collided: bool = character.move_and_slide()
	
	if collided:
		stop_pather(character)
		
func stop_pather(character: Character) -> void:
	character.navigation_agent.velocity = Vector2.ZERO
	character.velocity = Vector2.ZERO
	character.set_wanted_pos(character.position)
	character.evaluate_behavior()

func can_run(character: Character) -> bool:
	var target: Character = character.find_target()

	if target && !character.attack_hitbox.overlaps_body(target):
		return true
	else:
		return false
