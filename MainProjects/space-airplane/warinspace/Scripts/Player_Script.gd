extends Area2D

#this code allows to add a laser for shooting #(@export is creating an new option you can see it on the top right in the options) 
#now with adding this I can just add the laser after I done it to the option on the right (leser Tcsn)
@export var laser_tcsn: PackedScene
#This code hold every thing the main scene has and you can call anything you want inside the scene 
#(@onready it's job is to find something in the main scene does exist) 
@onready var mainScene = $".."

func _process(_delta):
	#this code will move the player where ever the mouse move 
	#I had an error and the problem was from this word get_global_mouse_position() 
	#this word give you two directions Y and X but in my game I want only X 
	#so I had to give mouse_position X to make sure that I want only X direction without Y
	var mouse_position = get_global_mouse_position()
	#when you use (self) that mean you pointing on the script itself in this situation it is the player
	#when you use X that mean you want the player to move sides not up or down only right or left
	self.position.x = mouse_position.x
	
	#now this for the input for the player to shoot laser
	if Input.is_action_just_pressed("fire"):#here "fire" is input done with in settings of the project 
		#this word (instantiate) make the laser is alive in the current scene
		var new_laser = laser_tcsn.instantiate()
		#now here a added "add_sibling" that mean the bullet will go out of the player not form inside 
		#if you want the bullet to go from inside the player you can change "sibling" to "child"
		add_sibling(new_laser)
		#this code is to set the position of the laser
		new_laser.position = self.position

#this func to make the enemy enter the scene 
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		#self is the player and "queue_free" this to destroy the player and get him off from the scene
		self.queue_free()
		#so here we calling the "mainScene" above and telling that if the player dead send GameOver
		mainScene.is_game_over = true
