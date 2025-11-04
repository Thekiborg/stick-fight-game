extends CharacterBody2D

class_name Character

var healthPoints: int = 10;
var movement_speed: float = 60.0
var movement_target_position: Vector2 = Vector2(500.0,300.0)
var target: CharacterBody2D;

@onready var health_bar: ProgressBar = $HealthBar

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

func _ready():
	health_bar.value = healthPoints
	
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0
	
	target = find_target();
	if (target != null):
		movement_target_position = target.global_position
		# Make sure to not await during _ready.
		actor_setup.call_deferred()
	
func find_target() -> Node2D:
	var tempT: Node2D = null;
	for node in get_tree().get_nodes_in_group("CharactersThatFight"):
		var character = node as Node2D;
		if self == character: continue;
		
		if tempT == null:
			tempT = character;
		elif (character.position.distance_to(self.position) < tempT.position.distance_to(self.position)):
			tempT = character;
	return tempT

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# Now that the navigation map is no longer empty, set the movement target.
	set_movement_target(movement_target_position)

func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target

func _physics_process(delta):
	if movement_target_position == position:
		return
	
	if target != null:
		movement_target_position = target.global_position
		set_movement_target(movement_target_position)

		var current_agent_position: Vector2 = global_position
		var next_path_position: Vector2 = navigation_agent.get_next_path_position()

		velocity = current_agent_position.direction_to(next_path_position) * movement_speed
		var collided = move_and_slide()
		if collided:
			var collider = get_last_slide_collision().get_collider();
			if collider is Character:
				collider.receive_damage(1)
			#movement_target_position = position;
			#set_movement_target(movement_target_position)
	elif target == null:
		movement_target_position = position
		set_movement_target(movement_target_position)

func receive_damage(damage: int):
	healthPoints -= damage;
	health_bar.value = healthPoints
	if healthPoints <= 0:
		die()

func die():
		queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
