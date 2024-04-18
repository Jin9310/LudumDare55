extends Node2D

@onready var new_game: Node = get_node("/root/NewGame/spawning_area")

#new Acolytes
var acolytes_spawn_at_one_time: int = 1
@export var acolytes_spawned: int = 0


func _ready():
	new_game.connect("spawn_basic_minion", spawn_minion)


func spawn_minion():
	spawn_acolyte(acolytes_spawn_at_one_time)


func spawn_acolyte(count: int):
	for i in range(count):
		var new_acolyte = preload("res://NewGame/acolyte.tscn").instantiate()
		%PathToSpawn.progress_ratio = randf()
		new_acolyte.global_position = %PathToSpawn.global_position
		add_child(new_acolyte)
		acolytes_spawned += 1 #count all spawned acolytes

