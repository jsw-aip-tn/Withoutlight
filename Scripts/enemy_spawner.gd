extends Node

@export_subgroup("Spawn_Timer properties")
@export_custom(PROPERTY_HINT_NONE,"suffix:s") var SPAWN_FREQUENCY: int = 1
@export var NUMBER_OF_SPAWN_TRIES: int = 10
@export var MAX_NUMBER_OF_ENEMIES: int = 5

@export_subgroup("Enemy")
@export_enum("Bat:1","Wolf:2", "Spider:3") var ENEMY_TYPE:int
@export var SCENES: Array[String]
@export var ENEMY_SPAWN_DISTANCE = 75
var enemy
var enemy_counter = 0
var enemy_max_notification_fired = false

var spawn_area_origin: Vector2
var spawn_area_border: Vector2



@onready var spawn_area = $spawn_area

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$enemy_spawn_frequency.wait_time = SPAWN_FREQUENCY
	$enemy_spawn_frequency.start()
	enemy = load(SCENES[ENEMY_TYPE-1])
	spawn_area_origin = spawn_area.position
	spawn_area_border = Vector2(spawn_area_origin.x + spawn_area.size.x, spawn_area_origin.y + spawn_area.size.y)
	var test = 0
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func spawn_enemy ():
	if(enemy_counter>= MAX_NUMBER_OF_ENEMIES):
		if(!enemy_max_notification_fired):
			print("max number of enemies reached in spawn area")
			enemy_max_notification_fired = true
		return
	var new_enemy = enemy.instantiate()
	new_enemy.position = location_creator()
	if(!(new_enemy.position == Vector2.ZERO)):
		add_child(new_enemy)
		enemy_counter+= 1
		
	

func location_creator()-> Vector2:	
	var all_nodes = get_tree().get_nodes_in_group("enemies")
	var new_position = Vector2(randi_range(spawn_area_origin.x, spawn_area_border.x), randi_range(spawn_area_origin.y, spawn_area_border.y))
	var position_too_close = true
	var too_close_counter = 0
	while position_too_close && too_close_counter<= NUMBER_OF_SPAWN_TRIES:
		position_too_close = false
		for node in all_nodes:
			var other_objects_position
			if((node as Node2D)!= null):
				other_objects_position = (node as Node2D).position
			else:
				other_objects_position = Vector2.ZERO	
			var comparer = (other_objects_position - new_position).length()
			if( comparer < ENEMY_SPAWN_DISTANCE):
				position_too_close = true
				too_close_counter+= 1
				break
		if(position_too_close):
			new_position = Vector2(randi_range(spawn_area_origin.x, spawn_area_border.x), randi_range(spawn_area_origin.y, spawn_area_border.y))
		
	if(too_close_counter > NUMBER_OF_SPAWN_TRIES && position_too_close):
		
		return Vector2.ZERO
	else:
		return new_position

func _on_enemy_spawn_frequency_timeout() -> void:
	spawn_enemy()
	
