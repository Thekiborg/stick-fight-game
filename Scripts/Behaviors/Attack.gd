class_name Attack extends Behavior
var frame:int = Engine.get_physics_frames()

func _get_name() -> String: return "Attack"
func do(character: Character) -> void:
	var targetC: Character = character.find_target() as Character
	if targetC:
		targetC.receive_damage(1, character.position)
	super(character)
	
func can_run(character: Character) -> bool:
	print(character.name)
	if Engine.get_physics_frames() - frame < 5:
		return false;
	
	frame = Engine.get_physics_frames()
	var target: Character = character.find_target()
	var hitbox: Area2D = character.attack_hitbox
	
	if !target || !hitbox:
		return false
	
	if hitbox.overlaps_body(target):
		character.set_wanted_pos(character.position)
		return true
	
	return false;
