class_name hitbox extends Area2D

signal damaged(damage : int)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func takedamage( damage : int ) -> void:
	print("hit: ", damage)
	damaged.emit(damage)
