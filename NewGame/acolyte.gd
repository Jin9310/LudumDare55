extends CharacterBody2D

var move: bool = false
var idle: bool = false
var dead: bool = false

var timer: float
var base_time: float
var random_time: float

var direction: Vector2

var number_of_clicks: int = 0

func _ready():
	set_random_time(3.0, 6.0) #set some basic timer
	direction = Vector2.RIGHT.rotated(randf_range(0, TAU)) #set some basic direction
	$AnimationPlayer.play("spawn")


func _physics_process(delta):
	
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
	
	if move:
		velocity = direction * 15
		move_and_slide()
	else:
		velocity = direction * 0
		move_and_slide()
	

func change_animation(): #change animations based on NPCs state
	if idle:
		$AnimationPlayer.play("idle")
	if move:
		direction = Vector2.RIGHT.rotated(randf_range(0, TAU)) #set random direction
		$AnimationPlayer.play("walk")
	if dead:
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

func _on_timer_timeout():
	dead = true
