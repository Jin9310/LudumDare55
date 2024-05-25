extends Node

var coins: ManagerCoins


func _enter_tree() -> void:
	coins = $Coins as ManagerCoins
