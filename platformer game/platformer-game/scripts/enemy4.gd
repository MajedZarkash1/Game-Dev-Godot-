extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D




# Speed of the enemy
var speed = 100
# Gravity settings
var gravity = 400

# Direction of movement
var moving_right = true

# Movement limits
var move_distance = 100  # Distance to move left and right
var start_position: Vector2

func _ready():
	# Store the starting position
	start_position = position

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
	animated_sprite_2d.flip_h = isLeft
