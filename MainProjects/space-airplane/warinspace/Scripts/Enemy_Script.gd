extends Area2D


#@export to create a option and float to do 100.0
@export var speed: float = 400
#this to call some nodes from the main scene
@onready var mainScene = $'../..'

func _process(delta):
	#to let the enemy move down we should use Y and don't forget the -= to move down if you want up +=
	self.position.y += speed * delta

#this to make the enemy disappear after getting hit by the bullet
func _on_area_entered(area: Area2D) -> void:
	#again queue_free() to remove the enemy or player and don't forget to type self 
	self.queue_free()
	#this call the (score) from the mainScene and += to add 10 points to the score everytime you kill an enemy
	mainScene.score += 10
