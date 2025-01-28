extends Area2D

var wood_stack = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("SPAWNT")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	wood_stack += 1
	print(wood_stack)
	queue_free()
