extends CharacterBody2D
@onready var character_body_2d: CharacterBody2D = $"."

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 160.0
const JUMP_VELOCITY = -380.0


func _physics_process(delta: float) -> void:
	
	
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta


		if velocity.y > 0:
			animated_sprite_2d.play("falling")
		else:
			animated_sprite_2d.play("jumping")
	else:
		if velocity.x != 0:
			animated_sprite_2d.play("runing")
		else:
			animated_sprite_2d.play("idle")

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	
	#flip the sprite
	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true
	
	
	if direction:
		velocity.x = direction * SPEED
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	
	
		
	move_and_slide()
