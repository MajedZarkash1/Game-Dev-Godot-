extends CharacterBody2D

@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var health_bar: ProgressBar = $HealthBar

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
	# Store the starting position
	start_position = position
	sprite_2d.play("enemy's walking")
	
	
func take_damage(amount: int ):
	current_health -= amount
	current_health = clamp(current_health, 0, max_health)
	
	health_bar.value = current_health
	
	if current_health <= 0:
		die()
		
func die():
	# Handle death (play animation, remove node)
	# Optionally play a death animation here
	queue_free()

func _physics_process(delta):
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
		if sprite_2d.is_playing():
			sprite_2d.play("enem's walking")
		
		


#for attacking the player
func enemy():
	pass
