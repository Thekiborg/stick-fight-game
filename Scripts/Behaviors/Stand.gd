class_name Stand extends Behavior

func do(character: Character) -> void:
	var timer: Timer = Timer.new()
	timer.wait_time = 1.0
	timer.one_shot = true
	character.add_child(timer)
	timer.start()
	
	await timer.timeout
	on_end(character)
