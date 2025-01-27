extends Node2D

@export var enemy_tscn: PackedScene

#this is the timer you can added from the signals
func _on_timer_timeout() -> void:
	#here we changing the name of the enemy_tscn
	var new_enemy = enemy_tscn.instantiate()
	#after put the (name_enemy) inside the brackets now it knows what exactly what to add when the game run
	self.add_child(new_enemy)
	
	#now here this var to spwan the enemies randomly in the game 
	#in this line the enemies can spwan put at on place and use X to make sure only on one line
	var viewport_with = get_viewport_rect().size.x
	#now this can spawn the enemies randomly
	var rand_x = randf_range(0, viewport_with)
	#this code to spawn new enemy evertime
	new_enemy.position.x = rand_x
	#here in this code I added -30 so the enemy does not spawn in the scene by that the enemy will spawn outside the scene 
	new_enemy.position.y = -50
	
