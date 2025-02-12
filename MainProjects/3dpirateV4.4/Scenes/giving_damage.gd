

extends Node3D


signal damage_to_player



func _on_taking_damage_body_entered(body: Node3D) -> void:
	if body.has_method("player"):
		var damage = 1
		emit_signal("damage_to_player", damage)
