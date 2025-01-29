extends CharacterBody2D

const SPEED = 200.0
var atk = 5
var pos: Vector2
var rota : float
var dir : float 
@onready var lifetime: Timer = $Lifetime


func _ready() -> void:
	global_position = pos
	global_rotation = rota
	_start_timer()

func _physics_process(delta: float) -> void:
	velocity = (Vector2.RIGHT * SPEED).rotated(rota)
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		body.received_damaged(atk)
		

func _start_timer():
	lifetime.start()

func _on_lifetime_timeout() -> void:
	queue_free()

func Fly():
	pass	
