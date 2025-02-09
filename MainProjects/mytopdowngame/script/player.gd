extends CharacterBody2D

const SPEED = 300.0
var health: int = 5

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $AnimatedSprite2D
@onready var hurt_box: hurtbox = $interactions/hurt_box

signal DirectionChanged(new_direction: Vector2)  # ✅ Signal defined inside this script

var attack = false  # Prevents animation interruption

func _physics_process(delta: float) -> void:
	var direction = Vector2.ZERO
	
	hurt_box.monitoring = false
	
	# Prevent movement if attacking
	if not attack:
		if Input.is_action_pressed("right"):
			direction.x = 1
			sprite.scale.x = 1
		if Input.is_action_pressed("left"):
			direction.x = -1
			sprite.scale.x = -1
		if Input.is_action_pressed("up"):
			direction.y = -1  # Y is inverted in Godot
		if Input.is_action_pressed("down"):
			direction.y = 1

		DirectionChanged.emit(direction)  # ✅ Emit signal

		# Normalize Direction to Prevent Diagonal Speed Boost
		direction = direction.normalized()

		# Apply Velocity
		velocity = direction * SPEED
		move_and_slide()

		# Animation Handling (Only play movement animations if not attacking)
		if direction != Vector2.ZERO:
			animation_player.play("run")
		else:
			animation_player.play("idle")
	
	# Attacking
	if Input.is_action_just_pressed("attack") and not attack:
		attack = true
		animation_player.play("attack")
		hurt_box.monitoring = true
		await animation_player.animation_finished  # Wait for attack to finish
		attack = false  # Allow movement again
	
	
