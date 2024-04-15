extends Area2D

@onready var animPlayer = $AnimationPlayer
@onready var game: Node = get_node("/root/Game")

func _ready():
	game.connect("click_summon_animation", click_anim)


func click_anim():
	animPlayer.play("click")
