extends Sprite2D  # Change this to Node2D if you want

# Movement parameters
var speed = 20 # Speed of the cloud movement
var direction = 1  # 1 for right, -1 for left
var movement_range = 150  # Range of movement in pixels
var start_position = Vector2.ZERO  # Starting position

func _ready():
	# Store the initial position of the cloud
	start_position = position

func _process(delta):
	# Move the cloud
	position.x += direction * speed * delta

	# Check if the cloud has reached the movement range
	if position.x > start_position.x + movement_range:
		direction = -1  # Change direction to left
	elif position.x < start_position.x - movement_range:
		direction = 1  # Change direction to right
