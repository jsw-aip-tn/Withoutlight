extends CharacterBody2D

var maxHp = 100
var hp = 100
var atk = 10
var SPEED = 120.0
var dash_speed: float = 0.0
var enemy_in_range = false
var atk_cooldown = true
var player_alive = true
var direction : Vector2
var facing : Vector2 = Vector2.LEFT
var range_attack_triggered : bool = false
var melee_attack_triggered : bool = false
var animation_player : AnimationPlayer 
var light_nearby = false
var torch_nearby: int
var fire_direction: Vector2
var is_dashing= false
const DASH_SPEED = 100.0
const TORCH = preload("res://Scenes/torch.tscn")
const arrow_path = preload("res://Scenes/arrow.tscn")
@onready var arrow_spawn_point: Node2D = $AnimatedSprite2D/arrowSpawnPoint
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var cooldown_timer: Timer = $atk_cooldown
@onready var dash_timer: Timer = $dash_timer
@onready var progress_bar: ProgressBar = $ProgressBar2
@onready var game: Node = $".."
@onready var current_wood: Label = $CurrentWood

func _ready() -> void:
	update_hpBar()

func _physics_process(delta: float) -> void:
	movement()
	place_torch()
	update_woodtext()
	
	if hp <= 0:
		player_alive = false

func player():
	pass

func movement():
	if !is_dashing:
		dash_speed = 0
		direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		if facing != direction and direction != Vector2.ZERO:
			facing = direction
		if direction.length():
			direction = direction.normalized()
			velocity = direction * (SPEED + dash_speed)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.y = move_toward(velocity.y, 0, SPEED)
			idle_animation()
		if !melee_attack_triggered && !range_attack_triggered:
			animation()
			move_and_slide()
	else:
		if direction.x == 0:
			match animated_sprite.flip_h:
				true: direction.x = -1
				false: direction.x = 1
		direction = direction.normalized()
		velocity = direction * (SPEED + dash_speed)
		move_and_slide()
		

func update_hpBar():
	progress_bar.update_health(hp, maxHp)
	
func update_woodtext():
	current_wood.text = "Wood: " + str(Global.wood_stack) 
	
func place_torch():
	if Input.is_action_just_pressed("place_torch"):
		if (Global.wood_stack > 0):
			if !light_nearby && torch_nearby <= 0:
				var torch = TORCH.instantiate()
				Global.wood_stack -=1
				update_woodtext()
				torch.position = position
				get_parent().add_child(torch)
		
	#ToDo Pfeil kann mann Steurn wenn animation Gestartet wird.
func animation():
	# Wenn eine Bewegung stattfindet, wird die "run"-Animation abgespielt
	if direction.x != 0 :
		if direction.x > 0:
			animated_sprite.flip_h = false  # Blick nach rechts
			$AnimatedSprite2D/arrowSpawnPoint.position.x = 30
			$AtkArea/AtkHitbox.position.x = 15
		else:
			animated_sprite.flip_h = true  # Blick nach links
			$AnimatedSprite2D/arrowSpawnPoint.position.x = -30
			$AtkArea/AtkHitbox.position.x = -15
		if not animated_sprite.is_playing() or animated_sprite.animation != "run":
			animated_sprite.play("run")  # Abspielen der Lauf-Animation
		$AtkArea/AtkHitbox.disabled = true
#Bewegung nach Oben
	if direction.y != 0:
		if not animated_sprite.is_playing() or animated_sprite.animation != "run":
			animated_sprite.play("run")
	# Melee-Angriff Animation
	if Input.is_action_just_pressed("mele_atk") and not melee_attack_triggered:
		melee_attack_triggered = true
		if not animated_sprite.is_playing() or animated_sprite.animation != "mele_atk":
			animated_sprite.play("mele_atk")  # Abspielen der Angriff-Animation
			$AtkArea/AtkHitbox.disabled = false
		cooldown_timer.start()

	# Range-Angriff Animation
	if Input.is_action_just_pressed("range_atk") and not range_attack_triggered:
		range_attack_triggered = true
		fire_direction = facing
		if not animated_sprite.is_playing() or animated_sprite.animation != "range_atk":
			animated_sprite.play("range_atk")  # Abspielen der Fernkampf-Animation
		cooldown_timer.start()
		
		#Dash
	if Input.is_action_just_pressed("dash"):
		if not animated_sprite.is_playing() or animated_sprite.animation != "dash()":
			animated_sprite.play("dash")
			dash()


func dash():
	is_dashing = true
	dash_timer.start()
	dash_speed = DASH_SPEED
	
func fire(dir : Vector2):
	var arrow = arrow_path.instantiate()
	if range_attack_triggered:
		if dir.x == 0:
			match animated_sprite.flip_h:
				true:
					dir.x = -1
				false:
					dir.x = 1
		arrow.pos = $AnimatedSprite2D/arrowSpawnPoint.global_position
		arrow.rota = deg_to_rad((dir.x*90)-90) 
		get_parent().add_child(arrow)
	
# Funktion für Idle-Animation, wenn keine Eingabe erfolgt
func idle_animation():
	# Idle-Animation wird nur abgespielt, wenn keine Angriffsanimation läuft
	if animated_sprite.is_playing() and (animated_sprite.animation == "mele_atk" or animated_sprite.animation == "range_atk" or animated_sprite.animation == "dash"):
		return  # Verhindern, dass idle die Angriffsanimation überschreibt

	# Wenn keine Angriffsanimation läuft, spiele idle ab
	if not animated_sprite.is_playing() or animated_sprite.animation != "idle":
		animated_sprite.play("idle")  # Abspielen der Idle-Animation
		$AtkArea/AtkHitbox.disabled = true
		
func received_damaged(atk):
	hp = hp -  atk
	update_hpBar()
	if hp <= 0:
		player_alive = false
		game.GameOver()

func pushback(enemy_position: Vector2, pushback_strength):
	var pushback_direction = (position - enemy_position)  
	velocity = pushback_direction * pushback_strength  
	move_and_slide() 
	
func _on_atk_cooldown_timeout() -> void:
	melee_attack_triggered = false
	fire(fire_direction)
	range_attack_triggered = false
	cooldown_timer.stop()

func _on_atk_area_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		body.received_damaged(atk)

func _on_dash_timer_timeout() -> void:
	is_dashing = false
	dash_timer.stop()
