extends CharacterBody2D

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_body: CollisionShape2D = $CollisionShape2D
@onready var collision_shape_2d_body_: CollisionShape2D = $"CollisionShape2D(body)"
@onready var collision_shape_2d_hitbox_: CollisionShape2D = $"AttackArea/CollisionShape2D(hitbox)"

@export var attack_damage: int = 10
@export var attack_range: float = 50
@export var attack_cooldown: float = 0.5

@onready var attack_timer: Timer = $AttackTimer


var can_attack = true

const SPEED = 100.0
const CROUCH_SPEED = 50.0
const JUMP_FORCE = -300.0
const GRAVITY = 600.0

# Dash settings
const DASH_SPEED = 300.0
const DASH_TIME = 0.2
const DASH_COOLDOWN = 0.5

# Jump improvements
const COYOTE_TIME = 0.1      # Allows jump shortly after falling
const JUMP_BUFFER_TIME = 0.15 # Buffer jump input

var coyote_timer = 0.0
var jump_buffer_timer = 0.0
var is_dashing = false
var dash_timer = 0.0
var dash_cooldown_timer = 0.0
var dash_direction = 0
var is_crouching = false

# Define reset position
var start_position = Vector2(27, 497)  # Set reset position

func _input(event):
	if event.is_action_pressed("attack") and can_attack:
		animation.play("attacking")
		attack()

func attack():
	can_attack = false
	$AttackTimer.start()  # Start cooldown timer


	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		if global_position.distance_to(enemy.global_position) <= attack_range:
			enemy.take_damage(attack_damage)

func _on_AttackTimer_timeout():
	can_attack = true


func _physics_process(delta: float) -> void:
	# Apply gravity if not on the floor
	if not is_on_floor() and not is_dashing:
		velocity.y += GRAVITY * delta
		coyote_timer -= delta  
	else:
		coyote_timer = COYOTE_TIME  # Reset coyote timer when on the floor

	# Handle jump buffering
	if jump_buffer_timer > 0:
		jump_buffer_timer -= delta

	# Store jump input for buffering
	if Input.is_action_just_pressed("ui_accept"):
		jump_buffer_timer = JUMP_BUFFER_TIME  

	# Handle jumping with coyote time
	if jump_buffer_timer > 0 and coyote_timer > 0 and not is_crouching:
		velocity.y = JUMP_FORCE
		jump_buffer_timer = 0  
		coyote_timer = 0  
		animation.play("jump")

	# Variable jump height (shorter jump if key released early)
	if Input.is_action_just_released("ui_accept") and velocity.y < 0:
		velocity.y *= 0.5  

	# Handle crouching
	if Input.is_action_pressed("down") and is_on_floor():
		is_crouching = true
		animation.play("crouch")
		velocity.x = move_toward(velocity.x, 0, CROUCH_SPEED)  # Slow down when crouching
	else:
		is_crouching = false

	# Handle dashing
	if dash_cooldown_timer > 0:
		dash_cooldown_timer -= delta  

	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false  
			dash_cooldown_timer = DASH_COOLDOWN  
	else:
		var direction = 0
		if Input.is_action_pressed("right"):
			direction = 1
		elif Input.is_action_pressed("left"):
			direction = -1

		if not is_crouching:
			velocity.x = direction * SPEED

		# Start dashing
		if Input.is_action_just_pressed("dash") and dash_cooldown_timer <= 0 and direction != 0:
			is_dashing = true
			dash_timer = DASH_TIME
			dash_direction = direction
			velocity.x = dash_direction * DASH_SPEED
			animation.play("dash")

	# Check if the player falls outside the world (below the screen or floor level)
	if position.y > 520:  # If the player falls too far, reset position
		reset_player()

	move_and_slide()

	# Handle animations
	if is_dashing:
		animation.play("dash")
		animation.flip_h = velocity.x < 0
	elif is_crouching:
		animation.play("crouch")
		animation.flip_h = velocity.x < 0
	elif velocity.y < 0:
		animation.play("jump")
		animation.flip_h = velocity.x < 0
	elif velocity.x != 0:
		animation.play("running")
		animation.flip_h = velocity.x < 0
	else:
		animation.play("idle")

# Function to reset player position
func reset_player() -> void:
	var start_position = Vector2(27, 479)
	position = start_position  # Reset the player's position to the starting point
	velocity = Vector2.ZERO  # Reset the velocity
	animation.play("idle")  # Set the animation to idle when the player is reset
