extends Node3D

signal hit_player  # Signal to tell the player they got hit


@onready var hitbox: Area3D = $CharacterBody3D/Hitbox

func _ready():
	hitbox.body_entered.connect(_on_hitbox_body_entered)

func _on_hitbox_body_entered(body):
	if body.is_in_group("player"):  # Check if the body is the player
		hit_player.emit()  # Emit signal to notify the player
