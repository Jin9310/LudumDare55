extends CharacterBody2D

@onready var workplace: Node = get_node("/root/Game/WorkPlace01")
@onready var sacrifice: Node = get_node("/root/Game/Sacrifice")
@onready var war: Node = get_node("/root/Game/WarArea")
@onready var game: Node = get_node("/root/Game")

@export var speed: float = 50.0
var on_move: bool = false

var minions_position: String = "Spawn"

var move_to_work_position: bool = false
var move_to_sacrifice_position: bool = false
var move_to_war: bool = false


func _ready():
	game.connect("go_to_work_pressed", go_to_work)
	game.connect("go_to_sacrifice_pressed", go_to_sacrifice)
	game.connect("at_work", arrived_at_work)
	game.connect("go_to_sacrifice_pressed_work",go_to_sacrifice_from_work)
	game.connect("go_to_war", go_to_war)

func _physics_process(delta):
	
	if move_to_work_position == true:
		move_to_position(workplace)
	
	if move_to_sacrifice_position == true:
		move_to_position(sacrifice)
	
	if move_to_war == true:
		move_to_position(war)

func move_to_position(position: Node):
	var direction = global_position.direction_to(position.global_position)
	velocity = direction * speed
	move_and_slide()

func go_to_work():
	move_to_work_position = true
	move_to_sacrifice_position = false

#change minions position
func arrived_at_work(min_pos):
	if min_pos == self:
		minions_position = "Work"

func go_to_sacrifice():
	move_to_work_position = false
	if minions_position == "Spawn":
		move_to_sacrifice_position = true

func go_to_sacrifice_from_work():
	minions_position = "Work"
	move_to_work_position = false
	if minions_position == "Work":
		move_to_sacrifice_position = true

func go_to_war():
	move_to_war = true



