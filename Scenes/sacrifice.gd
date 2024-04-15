extends Area2D

@onready var animPlayer = $AnimationPlayer
@onready var game: Node = get_node("/root/Game")

func _ready():
	game.connect("play_sacrifice_place_animation", sacrifice_anim)
	idle_anim()



func sacrifice_anim():
	animPlayer.play("sacrifice")
	idle_anim()

func idle_anim():
	animPlayer.play("idle")
