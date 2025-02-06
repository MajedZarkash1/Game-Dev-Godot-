extends CharacterBody2D

@export var health: int = 5  # Enemy health
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func take_damage():
	anim.play("idle")
	
	health -= 1
	anim.play("hurt")
	print("Enemy took damage! Health:", health)
	
	
	if health <= 0:
		queue_free()  # Destroy the enemy when health reaches 0


func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("hurtbox"):
		var enemy = area.get_parent()
		if enemy.has_method("take_damage"):
			enemy.take_damage()
		
	pass # Replace with function body.
