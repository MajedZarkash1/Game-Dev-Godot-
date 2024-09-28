extends CharacterBody2D


const SPEED = 260.0
const JUMP_VELOCITY = -400.0
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var health_bar: ProgressBar = $HealthBar



#       Health
var max_health : int =100
var current_health: int = max_health
#       Health



func _ready():
	health_bar.max_value = max_health
	health_bar.value = current_health
	
	
func take_damage(amount: int):
	current_health -= amount
	current_health = clamp(current_health, 0, max_health)
	
	#update health bar
	health_bar.value = current_health
	
	
	if current_health <= 0:
		die()
		
		
func die():
		# I can add animation for dying here
		
	queue_free()
	
	
	
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
