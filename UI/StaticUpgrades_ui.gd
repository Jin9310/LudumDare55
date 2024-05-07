extends CanvasLayer

signal play_scull
signal auto_fill_enabled

var green_color: Color = Color(0, 1, 0, 1)
var default_color: Color = Color(1, 1, 1, 1)

# 431 open position
# 543 closed position

@export var static_upgrades_panel: bool = false #checking if I clicked the btn that opens the options

func _process(delta):
	show_hide_panel()
	hide_others()
	
	if static_upgrades_panel == false:
		%static_upgrades_btn.text = "<"
	else:
		%static_upgrades_btn.text = ">"
	
	
	if GameManager.auto_click == true:
		%auto_click_btn.tooltip_text = "Already purchased"
	else:
		%auto_click_btn.tooltip_text = "Automatic summoning over time \ncost: " + str(UpgradesManager.auto_click_price)
	
	if GameManager.auto_kill_acolytes == true:
		%auto_kill_btn.tooltip_text = "Already purchased"
	else:
		%auto_kill_btn.tooltip_text = "Kills minions automaticaly over time \ncost: " + str(UpgradesManager.auto_kill_price)
	
	if GameManager.auto_fill_purchased == true:
		%auto_fill_btn.tooltip_text = "Already purchased"
	else:
		%auto_fill_btn.tooltip_text = "Automatically fills the KILL ALL progress bar over time \ncost: " + str(UpgradesManager.auto_fill_price)
	
	
	if Input.is_action_just_pressed("rmb") && static_upgrades_panel == true:
		static_upgrades_panel = false
		var tween: Tween = get_tree().create_tween()
		tween.tween_property(%MarginContainer, "position", Vector2(580,0), 0.5)
	
	upgrade_available_checker(GameManager.usable_money, UpgradesManager.auto_click_price, %auto_click_btn, GameManager.auto_click)
	upgrade_available_checker(GameManager.usable_money, UpgradesManager.auto_kill_price, %auto_kill_btn, GameManager.auto_kill_acolytes)
	upgrade_available_checker(GameManager.usable_money, UpgradesManager.auto_fill_price, %auto_fill_btn, GameManager.auto_fill_purchased)
	
	available_helper()


func available_helper():
	#checks if upgrade is available and then colors the little button
	if GameManager.usable_money >= UpgradesManager.auto_click_price && GameManager.auto_click == false:
		%static_upgrades_btn.modulate = green_color
	elif GameManager.usable_money >= UpgradesManager.auto_kill_price && GameManager.auto_kill_acolytes == false:
		%static_upgrades_btn.modulate = green_color
	elif GameManager.usable_money >= UpgradesManager.auto_fill_price && GameManager.auto_fill_purchased == false:
		%static_upgrades_btn.modulate = green_color
	else:
		%static_upgrades_btn.modulate = default_color



func upgrade_available_checker(my_money: float, price: float, btn: Button, purchased: bool):
	if my_money >= price && purchased == false:
		btn.modulate = green_color
	else:
		btn.modulate = default_color

func show_hide_panel():
	var tween: Tween = get_tree().create_tween()
	if static_upgrades_panel == true:
		tween.tween_property(%MarginContainer, "position", Vector2(200,0), 0.5)#.set_trans(Tween.TRANS_CUBIC)
	else:
		tween.tween_property(%MarginContainer, "position", Vector2(543,0), 0.5)

func _on_static_upgrades_btn_pressed():
	static_upgrades_panel = !static_upgrades_panel

func hide_others(): #check if other panels are selected or not, if yes, hide this one
	var tween: Tween = get_tree().create_tween()
	if SpawnUpgradesUi.static_upgrades_panel == true:
		tween.tween_property(%MarginContainer, "position", Vector2(580,0), 0.5)
	elif SpawnUpgradesUi.static_upgrades_panel == false:
		tween.tween_property(%MarginContainer, "position", Vector2(543,0), 0.5)

func _on_auto_click_btn_pressed():
	if GameManager.usable_money >= UpgradesManager.auto_click_price:
		GameManager.auto_click = true
		%auto_click_btn.disabled = true
		GameManager.usable_money -= UpgradesManager.auto_click_price

func _on_auto_kill_btn_pressed():
	if GameManager.usable_money >= UpgradesManager.auto_kill_price:
		GameManager.auto_kill_acolytes = true
		%auto_kill_btn.disabled = true
		GameManager.usable_money -= UpgradesManager.auto_kill_price
		emit_signal("play_scull")

func _on_screenshake_btn_pressed():
	GameManager.screen_shake = !GameManager.screen_shake

func _on_a_click_btn_pressed():
	if GameManager.usable_money >= UpgradesManager.auto_click_price:
		GameManager.auto_click = true
		GameManager.usable_money -= UpgradesManager.auto_click_price


func _on_auto_fill_btn_pressed(): #automatic fill of the Kill All progress bar
	if GameManager.usable_money >= UpgradesManager.auto_fill_price:
		GameManager.usable_money -= UpgradesManager.auto_fill_price
		GameManager.auto_fill_purchased = true
		%auto_fill_btn.disabled = true
		emit_signal("auto_fill_enabled")
