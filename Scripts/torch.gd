extends Node2D




func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		body.light_nearby = true
		body.torch_nearby +=1

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		body.light_nearby = false
		body.torch_nearby -=1
