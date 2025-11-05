extends CharacterBody2D

class_name Character

@export var healthPoints: int = 10;
@export var movement_speed: float = 60.0
@export var behavior: Behavior;

@onready var health_bar: ProgressBar = $HealthBar
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

func _ready() -> void:	
	health_bar.max_value = healthPoints
	health_bar.value = healthPoints
	
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0
	
	# Make sure to not await during _ready.
	actor_setup.call_deferred()
	
	if behavior != null:
		behavior.Do(self);
	
func find_target() -> Node2D:
	var tempT: Node2D = null;
	for character: Node2D in get_tree().get_nodes_in_group("CharactersThatFight"):
		if self == character: continue;
		
		if tempT == null:
			tempT = character;
		elif (character.position.distance_to(self.position) < tempT.position.distance_to(self.position)):
			tempT = character;
	return tempT

func actor_setup() -> void:
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame
	# Now that the navigation map is no longer empty, set the movement target.

func set_wanted_pos(new_pos: Vector2) -> void:
	navigation_agent.target_position = new_pos;

func _physics_process(delta: float) -> void:
	if navigation_agent.is_navigation_finished():
		if behavior != null:
			behavior.Do(self);
		return
		
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	
	velocity = global_position.direction_to(next_path_position) * movement_speed
	var collided: bool = move_and_slide()
	if collided:
		var collider: Object = get_last_slide_collision().get_collider();
		if collider is Character:
			(collider as Character).receive_damage(1)
		#movement_target_position = position;
		#set_movement_target(movement_target_position)

func receive_damage(damage: int) -> void:
	healthPoints -= damage;
	health_bar.value = healthPoints
	if healthPoints <= 0:
		die()

func die() -> void:
		queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
