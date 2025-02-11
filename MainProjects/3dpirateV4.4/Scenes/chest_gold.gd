extends Node3D

# Reference to the chest and area_3d node
@onready var chest_gold: Node3D = $"."  # Assuming this is the chest's reference (adjust path if needed)
@onready var area_3d: Area3D = $Area3D  # Reference to the Area3D node

# Signal to notify when the player enters the area
signal player_entered

func _ready():
	# Connect the area_entered signal to the callback method
	area_3d.area_entered.connect(_on_area_3d_area_entered)


# This method is triggered when an area enters this Area3D node
func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.is_in_group("player"):  # Ensure the player is in the correct group
		get_tree().change_scene_to_file("res://Scenes/map_2.tscn")
