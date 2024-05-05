extends Node

@export var screen_shake: bool = true #can be disabled in pause menu
@export var current_minion_count: int #need to track how many minions are on the screen due to performance

####### AUTO KILLING of the acolytes
@export var auto_kill_acolytes: bool = false
@export var kills: int = 0 #kill count
####   KILL UPGRADES   ####
@export var auto_kill_base_timer: float = 5 #how fast the acolyes are killed automatically

####### AUTO CLICKING
@export var auto_click: bool = false
####   CLICK UPGRADES   ####
@export var click_timer_base: float = 2 #how fast auto click clicks

####   SPAWNING
@export var acolytes_spawn_at_one_time: int = 1 #spawns per click (shared for manual and automatic) 
#spawn numbers are covered in auto click section
@export var max_spawned_acolytes: int = 100 # the base is that we can spawn max amount of acolytes

####   MONEY
@export var usable_money: float = 200 #money that player currently have
####   MONEY UPGRADES   ####
@export var kill_money_multiplicator: float = .1 #money gained per kill
@export var click_money_multiplicator: float = .1 #money gained per click on spawn
@export var only_click_money_multiplicator: float = .1 #money gained per click anywhere

