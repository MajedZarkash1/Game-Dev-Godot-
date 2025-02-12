extends CharacterBody3D

signal hit_player  # Signal to tell the player they got hit

@export var speed: float = 3.0
@export var detection_radius: float = 10.0  # Detection range
@onready var animation: AnimationPlayer = $skeleton_mage/AnimationPlayer
@onready var hitbox: Area3D = $Hitbox
@onready var player: CharacterBody3D = $"../player"
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D  # Ensure this node exists!

func _ready():
	hitbox.body_entered.connect(_on_hitbox_body_entered)
	nav_agent.path_desired_distance = 0.5  # Precision for following path
	nav_agent.target_desired_distance = 1.0  # Stop near target
	nav_agent.avoidance_enabled = true  # Enable obstacle avoidance

func _physics_process(delta: float) -> void:
	if player and player.global_position.distance_to(global_position) <= detection_radius:
		nav_agent.set_target_position(player.global_position)  # Set path to player

	if !nav_agent.is_navigation_finished():
		var next_path_position = nav_agent.get_next_path_position()
		var direction = (next_path_position - global_position).normalized()
		velocity = direction * speed
		animation.play("Running_A")
		look_at(next_path_position, Vector3.UP)
		rotate_y(PI)  # Rotate 180 degrees to correct the backward look
	else:
		velocity = Vector3.ZERO
		animation.play("Idle_B")
	
	move_and_slide()

func _on_hitbox_body_entered(body):
	if body.is_in_group("player"):
		hit_player.emit()  # Notify the player they got hit
