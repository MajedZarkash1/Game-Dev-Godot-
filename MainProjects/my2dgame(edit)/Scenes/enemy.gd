extends CharacterBody2D

@export var health: int = 3

func take_damage(amount):
	health -= amount
	if health <= 0:
		queue_free()  # Remove enemy when health reaches 0
 
