extends CharacterBody2D

const SPEED = 200.0
var atk = 5
var pos: Vector2
var rota : float
var dir : float 
var found_target = false
var target
var direction_to_target: Vector2 = Vector2.ZERO
@onready var lifetime: Timer = $Lifetime


func _ready() -> void:
	global_position = pos
	global_rotation = rota
	_start_timer()

func _physics_process(delta: float) -> void:
	if !found_target:
		velocity = (Vector2.RIGHT * SPEED).rotated(rota)
	else:   
		velocity = direction_to_target.normalized() * SPEED
		
		# Optional: Rotieren des Pfeils in Richtung der Bewegung
		rotation = direction_to_target.angle()
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


func _on_searchradius_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		found_target = true
		target = body
		# Berechne den Vektor, der das Ziel angibt
		direction_to_target = target.global_position - global_position
