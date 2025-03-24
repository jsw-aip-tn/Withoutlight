extends Control
var shader_material : ShaderMaterial

func _ready():
	# Get the ShaderMaterial from the Control node (the 'material' property)
	shader_material = $ColorRect.material
	mouse_filter = MOUSE_FILTER_PASS


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_exit_2_pressed() -> void:
	get_tree().quit()

func _process(delta):
	# Get the mouse position in normalized coordinates (0 to 1)
	var mouse_position = get_viewport().get_mouse_position()
	var viewport_size = get_viewport().size
	var mouse_norm = Vector2(mouse_position.x / viewport_size.x, mouse_position.y / viewport_size.y)

	# Pass the normalized mouse position to the shader
 # Check if we have a valid ShaderMaterial
	shader_material.set_shader_parameter("mouse_position", mouse_norm)
