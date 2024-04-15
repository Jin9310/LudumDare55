extends Area2D

@onready var animation_player = $AnimationPlayer
@onready var game: Node = get_node("/root/Game")

func _ready():
	animation_player.play("idle")
	game.connect("mana_from_click_gained", mana_from_click_gained)

func mana_from_click_gained():
	animation_player.play("mana_gained")



