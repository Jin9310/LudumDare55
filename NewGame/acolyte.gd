extends CharacterBody2D

@onready var new_game: Node = get_node("/root/NewGame")

#this variable will need to be stored someplace else
@export var ak_enabled: bool = false 

#acolyte states
var move: bool = false
var idle: bool = false
var dead: bool = false

#timer for automatic movement around the map
var timer: float
var base_time: float
var random_time: float
#set different direction where acoly will move next
var direction: Vector2

#timer for auto kill enabled > can be purchased
var auto_kill_timer: float
var ak_base_timer: float = 5.0 #can be updated later on as well

func _ready():
	new_game.connect("auto_kill_enabled", auto_kill_enabled)
	set_random_time(3.0, 6.0) #set some basic timer
	direction = Vector2.RIGHT.rotated(randf_range(0, TAU)) #set some basic direction
	$AnimationPlayer.play("spawn")
	auto_kill_timer = ak_base_timer

func _physics_process(delta):
	
	#timer for automated movement
	timer -= delta
	if timer <= 0: #after timer runs out, change the state of the acolyte
		if dead == false: #need to make sure that all movement and animations are stopped if dieing
			move = !move
			idle = !idle
		else:
			idle = false
			move = false
		set_random_time(3.0, 6.0)
		change_animation()
	
	#setting up the movement speed
	if move:
		velocity = direction * 15
		move_and_slide()
	else:
		velocity = direction * 0
	
	#handling the death
	if dead:
		die_now()
	
	#autokill update purchased
	if ak_enabled:
		auto_kill_timer -= delta
		if auto_kill_timer <= 0:
			die_now()

func change_animation(): #change animations based on NPCs state
	if idle:
		$AnimationPlayer.play("idle")
	if move:
		direction = Vector2.RIGHT.rotated(randf_range(0, TAU)) #set random direction
		$AnimationPlayer.play("walk")

func die_now():
	dead = true
	move = false #stop the movement
	velocity = Vector2(0,0) #stop any movement
	$AnimationPlayer.play("death")

func set_random_time(min_range: float, max_range: float):
	#set random time for each NPC so it feels more live
	if move: #I need move time to be lower than idle time as I want minions to move very little
		random_time = randf_range(min_range - 2, min_range)
		base_time = random_time
		timer = base_time
	else :
		random_time = randf_range(min_range, max_range)
		base_time = random_time
		timer = base_time

func animation_finished():
	#animation is done 
	#this function is called at the end of the animation and is set in AnimationPlayer
	if dead != true:
		$AnimationPlayer.play("idle")
		idle = true
	else:
		#delete acolyte if death animation is done
		queue_free()

func _on_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("mouse_click"):
		dead = true

func auto_kill_enabled():
	ak_enabled = true
