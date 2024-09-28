extends CharacterBody2D

const SPEED = 260.0
const JUMP_VELOCITY = -400.0
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var health_bar: ProgressBar = $HealthBar

var attack_power:int = 20
var current_dir = "none"
var attack_ip = false
var enemy_inattack_range = false
var enemy_attack_cooldown = true
var max_health: int = 100
var player_alive = true
var current_health: int = max_health

func _ready():
	health_bar.max_value = max_health
	health_bar.value = current_health

func take_damage(amount: int):
	current_health -= amount
	current_health = clamp(current_health, 0, max_health)
	health_bar.value = current_health
	
	if current_health <= 0:
		die()

func die():
	# Add any death animation logic here
	queue_free()

func _physics_process(delta: float) -> void:
	handle_input()
	attack()
	enemy_attack()

	if current_health <= 0:
		player_alive = false
		print("player has died")
		queue_free()

	if attack_ip:
		return  # Skip movement logic while attacking

	update_animation()

	if not is_on_floor():
		velocity.y += gravity * delta

	move_and_slide()

func handle_input():
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if direction > 0:
		current_dir = "right"
	elif direction < 0:
		current_dir = "left"

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, 20)

	sprite_2d.flip_h = (velocity.x < 0)

func update_animation():
	if attack_ip:
		sprite_2d.animation = "attack animation"
	elif abs(velocity.x) > 1:
		sprite_2d.animation = "walking animation"
	else:
		sprite_2d.animation = "default"
	
	if not is_on_floor():
		sprite_2d.animation = "jumping animation"

func _on_player_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_inattack_range = true

func _on_player_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_inattack_range = false

func enemy_attack():
	if enemy_inattack_range and enemy_attack_cooldown:
		current_health -= 20  # Decrease current_health instead of max_health
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		print(current_health)
		
func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(attack_power)
		   # Deal damage to the enemy on attack
		
func _on_enemy_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(attack_power)

func _on_attack_cooldown_timeout() -> void:
	enemy_attack_cooldown = true

func attack():
	if Input.is_action_just_pressed("attack"):
		Global.Player_current_attack = true
		attack_ip = true
		sprite_2d.play("attack animation")
		$deal_attack_timer.start()

func _on_deal_attack_timer_timeout() -> void:
	$deal_attack_timer.stop()
	Global.Player_current_attack = false
	attack_ip = false
