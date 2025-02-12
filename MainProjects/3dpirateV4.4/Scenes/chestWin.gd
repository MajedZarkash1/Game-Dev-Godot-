extends Area3D


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.get_tree().reload_current_scene()
	pass # Replace with function body.
