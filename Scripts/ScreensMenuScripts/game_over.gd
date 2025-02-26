extends CanvasLayer

func _on_restart_pressed() -> void:
	get_tree().change_scene_to_file("res://game_over.gd")


func _on_exit_2_pressed() -> void:
	get_tree().quit()
