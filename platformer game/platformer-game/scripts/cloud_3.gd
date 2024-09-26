extends Sprite2D

var speed = 25
var direction = 1
var movement_rang = 100
var start_position = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	
	start_position = position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	position.x += direction * speed * delta
	if position.x > start_position.x + movement_rang:
		direction = -1
	elif position.x < start_position.x - movement_rang:
		direction = 1
		
	
