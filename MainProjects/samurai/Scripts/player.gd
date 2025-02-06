extends CharacterBody2D

@export var speed: float = 100.0
@export var jump_force: float = -200.0
@export var gravity: float = 500.0
@export var health: int = 3

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $HitboxPivot/hitbox  # Updated to use pivot
@onready var hitbox_pivot: Node2D = $HitboxPivot  # Pivot for flipping

var is_attacking = false

func _ready():
	hitbox.monitoring = false 


func _physics_process(delta):
	if is_attacking:  # Prevent movement during attack
		return

	# Attack
	if Input.is_action_just_pressed("attack"):
		is_attacking = true
		hitbox.monitoring = true
		anim.play("attack")
		await anim.animation_finished  # Wait for animation to finish
		hitbox.monitoring = false
		is_attacking = false  # Allow movement again
		
		
	#quit the game
	if Input.is_action_pressed("quit"):
		get_tree().quit()


	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Movement
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * speed
		anim.play("run")
		anim.flip_h = direction < 0
		hitbox_pivot.scale.x = -1 if direction < 0 else 1  # Flip hitbox
	else:
		velocity.x = 0
		anim.play("idle")

	# Jumping
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force

	# Jump animation
	if velocity.y != 0:
		anim.play("jump")

	move_and_slide()

# Detect attack hits
func _on_hitbox_area_entered(area: Area2D):
	if area.is_in_group("hurtbox"):
		var player = area.get_parent()
		if player.has_method("take_damage"):
			player.take_damage()
		
	pass # Replace with function body.



# Taking damage from enemies
func _on_hurtbox_area_entered(area: Area2D):
	if area.is_in_group("hitbox"):  # If hit by an enemy
		take_damage()



func take_damage():
	anim.play("hurt")
	health -= 1
	print("Player took damage! Health:", health)

	if health <= 0:
		queue_free()  # Destroy the player when health reaches 0
 # Destroy player when health reaches 0
