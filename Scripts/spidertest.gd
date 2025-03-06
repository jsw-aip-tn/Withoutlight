extends CharacterBody2D

const speed = 20
const chase_speed = 40
var dir: Vector2
@onready var timer = $Timer
var player = null
var is_spider_chase: bool
var target



func _ready():
	is_spider_chase = false
	
func _process(delta):
	move(delta)
	handle_animation()
		
		
		
func move(delta):
	if is_spider_chase:
		var direction = global_position.direction_to(player.global_position).normalized()
		velocity = direction * chase_speed
		move_and_slide()
	else: 
		!is_spider_chase
		velocity += dir * speed * delta
		move_and_slide()
	
	
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = true
	elif velocity.x < 0:
		$AnimatedSprite2D.flip_h = false
	
	
func _on_timer_timeout():
	timer.wait_time = choose([1.0, 1.5, 2.0])
	if !is_spider_chase:
		dir = choose([Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN])
		print(dir)
func handle_animation():
	var animated_sprite = $AnimatedSprite2D
	if is_spider_chase:
		animated_sprite.play("walk")
	
	else: 
		animated_sprite.play("idle")
		

func choose(array):
	array.shuffle()
	return array.front()


func _on_detection_area_body_entered(body):
	
	player = body
	is_spider_chase = true


func _on_detection_area_body_exited(body):
	player = null
	is_spider_chase = false
	
