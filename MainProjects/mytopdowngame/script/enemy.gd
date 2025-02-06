class_name Enemy
extends CharacterBody2D

@onready var animation_enemy: AnimationPlayer = $AnimationPlayer
@onready var player: CharacterBody2D = get_node("/root/Level 1/player")  # Adjust path if needed
@onready var sprite_2d: Sprite2D = $Sprite2D

var health: int = 2
var speed: float = 100  # Adjust speed as needed
var detection_radius: float = 350  # Enemy follows if player is within this distance

func _ready() -> void:
	$hitbox.damaged.connect(takedamage)

func _physics_process(delta: float) -> void:
	if player == null:
		return  # Prevent errors if player is missing
	
	var direction = Vector2.ZERO
	var distance_to_player = global_position.distance_to(player.global_position)

	# Enemy follows the player if within detection radius
	if distance_to_player < detection_radius:
		direction = (player.global_position - global_position).normalized()

		# Flip the enemy based on movement direction
		if direction.x > 0:
			sprite_2d.scale.x = 1 # Face right
		elif direction.x < 0:
			sprite_2d.scale.x = -1 # Face left

	# Apply movement
	velocity = direction * speed
	move_and_slide()

	# Play animations based on movement
	if direction != Vector2.ZERO:
		animation_enemy.play("run")
	else:
		animation_enemy.play("idle")

func takedamage(_damage: int) -> void:
	health -= 1
	print(health)
	if health <= 0:
		queue_free()
