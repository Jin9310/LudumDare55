extends CharacterBody2D

signal clicked_minion

@onready var new_game: Node = get_node("/root/NewGame")

#acolyte states
var move: bool = false
var idle: bool = false
var dead: bool = false

#timer for automatic movement around the map
var timer: float
var base_time: float
var random_time: float
#set different direction where acolyte will move next
var direction: Vector2

var random_death_animation: int

func _ready():
	new_game.connect("auto_kill_enabled", auto_kill_enabled)
	SpawnUpgradesUi.connect("kill_all_pressed", auto_kill_enabled)
	LowerBar.connect("kill_all_pressed", auto_kill_enabled)
	
	set_random_time(3.0, 6.0) #set some basic timer
	direction = Vector2.RIGHT.rotated(randf_range(0, TAU)) #set some basic direction
	$AnimationPlayer.play("spawn")

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
	match random_death_animation:
		0:
			$AnimationPlayer.play("death")
		1:
			$AnimationPlayer.play("death_2")
		2:
			$AnimationPlayer.play("death_3")
		3:
			$AnimationPlayer.play("death_4")

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
		var random_number = randi_range(0,1)
		if random_number == 0:
			$AnimationPlayer.play("idle")
			idle = true
		else:
			$AnimationPlayer.play("walk")
			move = true
	else:# here should be everything that happens after minion is dead
		#delete acolyte if death animation is done
		GameManager.kills += 1
		GameManager.current_minion_count -= 1
		Managers.coins.create_coins_from_killing()
		LowerBar.spawn_coin()
		queue_free()

func _on_input_event(viewport, event, shape_idx): #mouse click on a minion
	if Input.is_action_just_pressed("mouse_click"):
		new_game.clicked_minion(self)
		auto_kill_enabled()

func auto_kill_enabled():
	random_death_animation = randi_range(0,3)
	dead = true
