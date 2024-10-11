extends Area2D


#again @export to make something does not exist, existant and you can see it at the right of your screen
#and describe the speed "float" so you can use numbers and . just like this 1.5
#you can change the speed later if you want to from the right
@export var speed: float = 600.0

#now this func to help the bullet to move
func _process(delta):
	#delta its job is to keep every bullet the same speed you can use it like this for everything
	self.position.y -= speed * delta



#now this func is to destroy the enemy when he touch the bullet
func _on_area_entered(area: Area2D) -> void:
	#in the group tag you can see it on the top right and (Groups) then add your enemies
	if area.is_in_group("enemy"):
		#this to remove the enemy after he touch the bullet
		self.queue_free()
