extends Area2D
class_name Player

@export var speed: float = 100

var velocity: Vector2 = Vector2()

func _process(delta: float) -> void:
	velocity = Vector2.ZERO
	
	if Input.is_action_pressed("right"):
		velocity.x += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	
	velocity = velocity.normalized() * speed
	
	move_and_slide(velocity)
