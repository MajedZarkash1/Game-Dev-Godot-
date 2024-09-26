extends CharacterBody2D


const SPEED = 260.0
const JUMP_VELOCITY = -400.0
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta: float) -> void:
	if (velocity.x > 1 || velocity.x < -1):
		sprite_2d.animation = "walking animation"
	else:
		sprite_2d.animation = "default"
	if not is_on_floor():
		velocity.y += gravity * delta
		sprite_2d.animation = "jumping animation"

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, 20)

	move_and_slide()
	
	
	
	var isLeft = velocity.x < 0
	sprite_2d.flip_h = isLeft
