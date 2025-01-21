extends Node2D

var hp = 20
var atk = 2
const SPEED = 150.0
var player_in_range = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	movment()
	
	
func movment():
	if !player_in_range:
		pass
