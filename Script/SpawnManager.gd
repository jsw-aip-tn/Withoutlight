extends Node2D

var current_wave: int
const BAT = preload("res://Szene/bat.tscn")
@onready var bat_spawn_1: Marker2D = $BatSpawn1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_wave = 0
	start_wave()
	#prepare_spawn("bat", 10,15)

func start_wave():
	current_wave += 1
	spawn_monsters()
	

func spawn_monsters():
	var bat_spawn_points = [$BatSpawn1, $BatSpawn2, $BatSpawn3, $BatSpawn4, $BatSpawn5]
	var many_of_monsters = current_wave 
	for i in many_of_monsters:
		#var spawn_point = bat_spawn_points[i]
		var bat = BAT.instantiate()
		bat.position = bat_spawn_1.position
		add_child(bat)
		
		
		
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#func prepare_spawn(type, multiplier, mob_spawns):
	#var mob_amount = float(current_wave) * multiplier
	#var mob_wait_time: float = 2
	#var mob_spawn_rounds = mob_amount/mob_spawns
	#spawn_type(type, mob_spawn_rounds, mob_wait_time)
	
#func spawn_type(type, mob_spawn_rounds, mob_wait_time):
	#if type == "bat":
		#var bat_spawn1 = $BatSpawn
		#var bat_spawn2 = $BatSpawn2
		#var bat_spawn3 = $BatSpawn3
		#var bat_spawn4 = $BatSpawn4
		#var bat_spawn5 = $BatSpawn5
		#if  mob_spawn_rounds >= 1:
			#for i in mob_spawn_rounds:
				#var bat1 = BAT.instantiate()
				#bat1.global_position = bat_spawn1.global_position
				#var bat2 = BAT.instantiate()
				#bat2.global_position = bat_spawn2.global_position
				#var bat3 = BAT.instantiate()
				#bat3.global_position = bat_spawn3.global_position
				#var bat4 = BAT.instantiate()
				#bat4.global_position = bat_spawn4.global_position
				#var bat5 = BAT.instantiate()
				#bat5.global_position = bat_spawn5.global_position
				#add_child(bat1)
				#add_child(bat2)
				#add_child(bat3)
				#add_child(bat4)
				#add_child(bat5)
				#print("spawn")
				#mob_spawn_rounds -= 1
				#await get_tree().create_timer(mob_wait_time).timeout
