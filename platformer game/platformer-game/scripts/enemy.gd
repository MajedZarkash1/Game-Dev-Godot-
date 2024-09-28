extends CharacterBody2D

@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var health_bar: ProgressBar = $HealthBar

# For attacking

var player_inattack_zone = false
var Player_current_attack = false
# Speed of the enemy
var speed = 100
# Gravity settings
var gravity = 400
# Health
var max_health: int = 100
var current_health: int = max_health
# Direction of movement
var moving_right = true

# Movement limits
var move_distance = 100  # Distance to move left and right
var start_position: Vector2

func _ready():
	health_bar.max_value = max_health
	health_bar.value = current_health
	start_position = position
	sprite_2d.play("enemy's walking")  # Ensure this animation name is correct

func take_damage(amount: int):
	current_health -= amount
	current_health = clamp(current_health, 0, max_health)
	health_bar.value = current_health
	
	# Update health bar
	health_bar.value = current_health
	
	if current_health <= 0:
		die()


func _physics_process(delta):
	deal_with_damage()
	
	# Apply gravity
	velocity.y += gravity * delta
	
	# Horizontal movement
	if moving_right:
		velocity.x = speed
		if position.x >= start_position.x + move_distance:
			moving_right = false  # Change direction to left
	else:
		velocity.x = -speed
		if position.x <= start_position.x - move_distance:
			moving_right = true  # Change direction to right

	# Move the character
	move_and_slide()

	var isLeft = velocity.x < 0
	sprite_2d.flip_h = isLeft
	
	if velocity.x != 0:
		if not sprite_2d.is_playing():
			sprite_2d.play("enemy's walking")  # Ensure this animation name is correct

func _on_enemy_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(20)  # Deal 20 damage to the player

func _on_enemy_hitbox_body_exited(body: Node2D) -> void:
	# Logic if needed when the enemy exits the player hitbox
	pass

func deal_with_damage():
	if player_inattack_zone and Global.Player_current_attack:
		take_damage(20)  # Apply damage using the take_damage method
		print("enemy health = ", current_health)  # Show current health
		
	if current_health <= 0:
		die()

func die():
	queue_free()  # Handle enemy death logic
