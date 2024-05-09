extends Node

## fixed prices ##
var auto_click_price: float = 50 #one time price
var auto_kill_price: float = 75 #one time price
var auto_fill_price: float = 200
var kill_all_button_price: float
### prices that scale ###
var kill_money_upgrade: float = 10
var click_money_upgrade: float = 45
var spawn_more_minions_upgrade: float = 12
var raise_max_amount_of_spawned: float = 150

var faster_auto_spawn_price: float = 210
var faster_auto_kill_price: float = 110

var fast_spawn_low: bool = false
var fast_kill_low: bool = false

var low_multiplicator: float = .02


func _process(delta):
	all_kill_handler()

func auto_click_handler():
	pass

func auto_kill_handler():
	pass

func all_kill_handler():
	kill_all_button_price = GameManager.current_minion_count + 5
