extends Node

@export var auto_kill_acolytes: bool = false
@export var screen_shake: bool = true
@export var auto_click: bool = false

@export var kills: int = 0
@export var auto_kill_base_timer: float = 10

@export var click_timer_base: float = 2

@export var current_minion_count: int


#MONEY
@export var usable_money: float
@export var kill_money_multiplicator: float = .1
@export var click_money_multiplicator: float = .1
