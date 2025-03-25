extends Node



func _physics_process(delta: float) -> void:
	win()

func win():
	if Global.current_wave == 10:
		get_tree().change_scene_to_file("res://Scenes/winning_screen.tscn")
		
		
func GameOver():
	get_tree().change_scene_to_file("res://Scenes/game_over.tscn")

func lose():
	get_tree().change_scene_to_file("res://Scenes/game_over.tscn")
