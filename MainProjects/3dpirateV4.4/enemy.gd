extends Node3D








func _on_damage_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.damage()
	pass # Replace with function body.
