extends Area2D

@onready var animation_player = $AnimationPlayer
@onready var game: Node = get_node("/root/Game")

func _ready():
	animation_player.play("idle")
	game.connect("mana_created", mana_created)

func mana_created():
	animation_player.play("mana_gained")

