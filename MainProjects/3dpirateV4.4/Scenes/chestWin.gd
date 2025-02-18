extends Area3D


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.get_tree().change_scene_to_file("res://Scenes/map_2.tscn")
	pass # Replace with function body.
