extends CharacterBody2D

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 100.0
const JUMP_FORCE = -300.0
const GRAVITY = 600.0  

# Dash settings
const DASH_SPEED = 300.0  
const DASH_TIME = 0.2  # Duration of the dash in seconds
const DASH_COOLDOWN = 0.5  # Cooldown before dashing again

var coyote_timer = 0.0
var jump_buffer_timer = 0.0
var is_dashing = false
var dash_timer = 0.0
var dash_cooldown_timer = 0.0
var dash_direction = 0

func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor() and not is_dashing:
		velocity.y += GRAVITY * delta
		coyote_timer -= delta  
	else:
		coyote_timer = 0.1  

	# Handle jump buffering
	if jump_buffer_timer > 0:
		jump_buffer_timer -= delta

	# Handle jump input
	if Input.is_action_just_pressed("ui_accept"):
		jump_buffer_timer = 0.15  

	if jump_buffer_timer > 0 and coyote_timer > 0:
		velocity.y = JUMP_FORCE
		jump_buffer_timer = 0  
		coyote_timer = 0  
		animation.play("jump")

	# Variable jump height
	if Input.is_action_just_released("ui_accept") and velocity.y < 0:
		velocity.y *= 0.5  

	# Handle dashing
	if dash_cooldown_timer > 0:
		dash_cooldown_timer -= delta  

	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false  # End dash
			dash_cooldown_timer = DASH_COOLDOWN  # Start cooldown
	else:
		var direction = 0
		if Input.is_action_pressed("right"):
			direction = 1
		elif Input.is_action_pressed("left"):
			direction = -1

		# Move normally
		velocity.x = direction * SPEED

		# Start dashing when pressing "dash" key (e.g., Shift or X)
		if Input.is_action_just_pressed("dash") and dash_cooldown_timer <= 0 and direction != 0:
			is_dashing = true
			dash_timer = DASH_TIME
			dash_direction = direction
			velocity.x = dash_direction * DASH_SPEED
			animation.play("dash")  # Play dash animation

	move_and_slide()

	# Handle animations
	if is_dashing:
		animation.play("dash")
		animation.flip_h = velocity.x < 0
	elif not is_on_floor():  
		animation.play("jump")  
		animation.flip_h = velocity.x < 0
	elif velocity.x != 0:  
		animation.play("running")
		animation.flip_h = velocity.x < 0  
	else:  
		animation.play("idle")

	
