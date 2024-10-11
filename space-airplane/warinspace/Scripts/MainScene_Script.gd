extends Node2D

#that is the score that the player will start with this var containe the score
var score = 0
#in this code below , if the player still alive don't send game over screen
var is_game_over = false

#this func for reseting the game if the player lost after the gameover
func reset_values():
	#this code to reset the score to 0
	score = 0
	is_game_over = false
