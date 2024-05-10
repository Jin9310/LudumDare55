class_name ManagerCoins
extends Node

signal coins_created
signal coins_consummed 


func create_coins(quantity : float) -> void:
	GameManager.usable_money += quantity
	coins_created.emit()


func consumme_coins(quantity : float) -> void:
	if quantity > GameManager.usable_money:
		return
	
	GameManager.usable_money -= quantity
	coins_consummed.emit()


func create_coins_from_summoning() -> void:
	var quantity : float = (
		(1 * GameManager.click_money_multiplicator) * GameManager.acolytes_spawn_at_one_time
	)
	create_coins(quantity)


func create_coins_from_killing() -> void:
	var quantity : float = (
		(1 * GameManager.kill_money_multiplicator) * GameManager.acolytes_spawn_at_one_time
	)
	create_coins(quantity)


func create_coins_from_clicking() -> void:
	var quantity : float = 1 * GameManager.only_click_money_multiplicator
	create_coins(quantity)
