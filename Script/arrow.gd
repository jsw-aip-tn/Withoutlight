extends CharacterBody2D

const SPEED = 300.0
var atk = 2
var pos: Vector2
var rota : float
var dir : float 


func _ready() -> void:
	global_position = pos
	global_rotation = rota


func _physics_process(delta: float) -> void:
	velocity = (Vector2.RIGHT * SPEED).rotated(rota)
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		body.received_damaged(atk)
		
		
		
