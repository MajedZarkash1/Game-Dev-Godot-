class_name player
extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D



var direction: Vector2 = Vector2.ZERO
var move_speed : float = 200.0
var state : String = "idle"



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = Vector2.ZERO
	if Input.is_action_pressed("right"):
		velocity.x += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if Input.is_action_pressed("up"):
		velocity.y -= 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * move_speed
		$AnimatedSprite2D.play("walking animation")
	else:
		$AnimatedSprite2D.play("default")
	
	velocity = direction * move_speed
	
	pass
	
	
func _physics_process(delta):
	move_and_slide()
	
	
	
	
	
func SetDirection() -> bool:
	
	
	return true


func SetState() -> bool:
	
	
	return true
	
	
func UpdateAnimation() -> void:
	pass
