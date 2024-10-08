extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
extends KinematicBody2D

# Signal for player death
signal player_died()

func _ready():
	# Connect the death signal to a function (if needed)
	connect("player_died", self, "_on_player_died")

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		# Call the player die function
		die()

func die():
	emit_signal("player_died")
	# Handle player death (e.g., reset position, reduce lives, etc.)
	queue_free()  # This will remove the player from the scene
