extends CharacterBody2D

class_name Character

var target: Node2D
var cur_behavior: Behavior;

@export var healthPoints: int = 10;
@export var movement_speed: float = 60.0
@export var logic_behavior: Behavior;

@onready var health_bar: ProgressBar = $HealthBar
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var attack_hitbox: Area2D = $AttackHitbox

func _ready() -> void:
	health_bar.max_value = healthPoints
	health_bar.value = healthPoints
	
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0
	
	# Make sure to not await during _ready.
	actor_setup.call_deferred()
	evaluate_behavior.call_deferred()
	
func find_target() -> Node2D:
	if !is_instance_valid(target):
		target = null;
		
	if target != null:
		return target
	
	var tempT: Node2D = null;
	for character: Node2D in get_tree().get_nodes_in_group("CharactersThatFight"):
		if self == character: continue;
		if !is_instance_valid(character): continue;
		if tempT == null:
			tempT = character;
		elif (character.position.distance_to(self.position) < tempT.position.distance_to(self.position)):
			tempT = character;
	target = tempT
	return target

func actor_setup() -> void:
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame
	# Now that the navigation map is no longer empty, set the movement target.

func set_wanted_pos(new_pos: Vector2) -> void:
	navigation_agent.target_position = new_pos;

func _physics_process(delta: float) -> void:
	if cur_behavior:
		cur_behavior.do(self)

func receive_damage(damage: int, source: Vector2) -> void:
	healthPoints -= damage;
	health_bar.value = healthPoints
	
	velocity = source.direction_to(position) * (1000 * damage)
	move_and_slide()
	
	if healthPoints <= 0:
		die()

func die() -> void:
		queue_free()

func evaluate_behavior() -> void:
	logic_behavior.do(self)
	# behavior should be giving me a cur_behavior
	# therefore behavior should be a logic behavior

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
