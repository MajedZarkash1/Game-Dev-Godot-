extends CharacterBody2D

@export var max_speed: float = 800.0
@export var acceleration: float = 50.0
@export var friction: float = 20.0
@export var jump_force: float = -300.0
@export var gravity: float = 900.0
@export var turn_speed_loss: float = 0.6  # Lose 40% of speed when turning
@export var stop_duration: float = 2.0  # Time to fully stop when no input

@onready var sprite = $AnimatedSprite2D  # Reference to AnimatedSprite2D

var speed: float = 0.0
var direction: int = 1  # 1 for right, -1 for left
var stop_timer: float = 0.0  # Timer for stopping

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Movement input
	var move_input = Input.get_axis("ui_left", "ui_right")

	if move_input != 0:
		# Reset stop timer when moving
		stop_timer = stop_duration  

		# Check if the player is turning around
		if move_input != direction and speed > 10:
			speed *= turn_speed_loss  # Reduce speed when changing direction

		direction = move_input
		var collision = move_and_collide(Vector2.ZERO)  # Check for collision
		
		if collision == null:  # No collision, build up speed
			speed = min(speed + acceleration * delta, max_speed)
		else:  # Collision detected, apply friction
			speed = max(speed - friction * delta, 0)

	else:
		# No input: Start reducing speed over 2 seconds
		if stop_timer > 0:
			stop_timer -= delta
			speed = max(speed - (max_speed / stop_duration) * delta, 0)  # Reduce speed gradually
		else:
			speed = 0  # Fully stop after 2 seconds

	# Jumping
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_force
		speed *= 0.5  # Reduce speed to half when jumping

	velocity.x = speed * direction  # Apply movement

	# Handle animations based on speed
	if speed >= 500:  
		sprite.play("run even faster")
	elif speed >= 200:  
		sprite.play("run faster")
	elif speed > 10:  
		sprite.play("run")
	else:  
		sprite.play("idle")

	sprite.flip_h = direction < 0  # Flip sprite based on direction

	move_and_slide()
