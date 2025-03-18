extends CanvasLayer

func _on_restart_pressed() -> void:
	Global.current_wave = 0
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_exit_2_pressed() -> void:
	get_tree().quit()
