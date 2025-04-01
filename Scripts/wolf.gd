extends CharacterBody2D

var maxhp = 50
var hp = 50
var atk = 4
@export var SPEED : float = 30
var pushback_strength  = 0.5
var player_in_range = false
var direction = Vector2()
var time_since_last_change = 0
var change_interval = 5  # Alle X Sekunden die Richtung ändern
var target
var target_direction: Vector2 = Vector2.ZERO
var dash_speed = 4
var is_dashing = false

@onready var progress_bar: ProgressBar = $ProgressBar2
@onready var ray_cast_up = $"Ray Casts/RayCastUp"
@onready var ray_cast_down = $"Ray Casts/RayCastDown"
@onready var ray_cast_left = $"Ray Casts/RayCastLeft"
@onready var ray_cast_right = $"Ray Casts/RayCastRight"
@onready var animated_sprite_2d = $AnimatedSprite2D


func _process (delta):
	if ray_cast_up.is_colliding():
		direction = Vector2(0, 1)
	if ray_cast_down.is_colliding():
		direction = Vector2(0, -1)
	if ray_cast_left.is_colliding():
		direction = Vector2(1, 0)
	if ray_cast_right.is_colliding():
		direction = Vector2(-1, 0)

func _ready() -> void:
	update_hpBar()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	movement(delta)
	
func enemy():
	pass
	
func update_hpBar():
	progress_bar.update_health(hp, maxhp)
	
func movement(delta: float):
	time_since_last_change += delta
	if !player_in_range and !is_dashing:
		if time_since_last_change >= change_interval:
			var angle = randf_range(0, 2 * PI)  # Zufälligen Winkel generieren
			direction = Vector2(cos(angle), sin(angle)) # Berechne Richtung
			time_since_last_change = 0
			velocity = direction.normalized() * SPEED	
		move_and_slide()
	if  player_in_range and is_dashing:
		is_dashing = true
		target_direction = (target.global_position - global_position).normalized()
		velocity = target_direction * SPEED * dash_speed 
		move_and_slide()
	
func received_damaged(atk):
	hp = hp -  atk
	update_hpBar()
	if hp <= 0:
		queue_free()

func _on_enemie_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_range = false
		is_dashing = false
		target = body
		body.received_damaged(atk)
		body.pushback(position, pushback_strength)

func _on_search_area_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_range = true
		is_dashing = true
		target = body
		#attck_player(body)
		#target_direction = target.position - position

func _on_search_area_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_range = false
		is_dashing = false
		
#func attck_player(body):
#
	#if player_in_range and !is_dashing:
		#target_direction = (target.position - position).normalized()
		#velocity = target_direction * SPEED * dash_speed 
	#move_and_slide()
	#print("Attack Moving")
	
