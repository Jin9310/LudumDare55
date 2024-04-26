extends CanvasLayer

# 431 open position
# 543 closed position
# 580 hidden position

@export var static_upgrades_panel: bool = false

func _process(delta):
	show_hide_panel()
	hide_others()

func show_hide_panel():
	var tween: Tween = get_tree().create_tween()
	if static_upgrades_panel == true:
		tween.tween_property(%SpawnMargin, "position", Vector2(200,40), 0.5)#.set_trans(Tween.TRANS_CUBIC)
	else:
		tween.tween_property(%SpawnMargin, "position", Vector2(543,40), 0.5)


func _on_static_upgrades_btn_pressed():
	static_upgrades_panel = !static_upgrades_panel

func hide_others():
	var tween: Tween = get_tree().create_tween()
	if StaticUpgradesUi.static_upgrades_panel == true:
		tween.tween_property(%SpawnMargin, "position", Vector2(580,40), 0.5)
	elif StaticUpgradesUi.static_upgrades_panel == false:
		tween.tween_property(%SpawnMargin, "position", Vector2(543,40), 0.5)
