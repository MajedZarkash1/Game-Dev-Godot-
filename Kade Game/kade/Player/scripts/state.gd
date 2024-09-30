class_name State
extends Node

static var player : Player




func _ready() -> void:
	pass



#what happenes when the player Enters this state?
func Enter() -> void:
	pass



func Exit() -> void:
	pass



func Process( _delta : float ) -> State:
	return null



func Physics( _delta : float ) -> State:
	return null



func HandleInput(_event: InputEvent) -> State:
	return null
