extends Node2D


#--------------------------------------------------------important
@onready var player: CharacterBody2D = get_node("/root/Level 1/player")



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.DirectionChanged.connect(UpdateDirection)  # ✅ Correctly connecting the signal

# Function to update position based on direction
func UpdateDirection(new_direction: Vector2) -> void:
	match new_direction:
		Vector2.LEFT:
			position.x = -100
		Vector2.RIGHT:
			position.x = 0
