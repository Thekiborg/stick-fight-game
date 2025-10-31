extends Sprite2D

var movement_speed: float = 300.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity: Vector2 = Vector2.ZERO;
	
	if Input.is_key_pressed(KEY_A):
		velocity.x = -1;
	if Input.is_key_pressed(KEY_D):
		velocity.x = 1;
	if Input.is_key_pressed(KEY_W):
		velocity.y = -1;
	if Input.is_key_pressed(KEY_S):
		velocity.y = 1;
		
	position.x += movement_speed * velocity.x * delta;
	position.y += movement_speed * velocity.y * delta;	
	pass
