extends CharacterBody3D


@onready var camera: Node3D = $Camera
@onready var camera_3d: Camera3D = $Camera/Camera3D
@onready var gun_animation: AnimationPlayer = $Camera/Camera3D/gun/AnimationPlayer
@onready var ray_cast_3d: RayCast3D = $Camera/Camera3D/gun/RayCast3D


@export var SPEED = 5.0
@export var JUMP_VELOCITY = 4.5
@export var gravity = 15
@export var SENSITIVITY = 0.002
var bullets_left = 40
var bullet = preload("res://Scenes/bullet.tscn")

var health = 3

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		camera.rotate_y(-event.relative.x * SENSITIVITY)
		camera_3d.rotate_x(-event.relative.y * SENSITIVITY)
		camera_3d.rotation.x = clamp(camera_3d.rotation.x, deg_to_rad(-40), deg_to_rad(60))
		
		
		pass


func _physics_process(delta: float) -> void:
	
	
	if health == 0:
		get_tree().reload_current_scene()
	
	$Camera/Camera3D/Label.text = str(bullets_left) + " / 40"
	$Camera/Camera3D/bullet
	$Camera/Camera3D/health.text = str(health) + " / 3"
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY


	if Input.is_action_pressed("shoot") and bullets_left > 0:
		if !gun_animation.is_playing():
			gun_animation.play("shoot")
			shoot()


	if Input.is_action_pressed("reload"):
		gun_animation.play("reload")
		bullets_left = 40
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (camera.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
func damage():
	health -= 1
	
	pass
	
	

func shoot():
	bullets_left -= 1
	var bullet_instance = bullet.instantiate()
	bullet_instance.position = ray_cast_3d.global_position
	bullet_instance.transform.basis = ray_cast_3d.global_transform.basis
	get_parent().add_child(bullet_instance)
	pass
