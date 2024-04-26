extends CanvasLayer

# 431 open position
# 543 closed position

@export var static_upgrades_panel: bool = false

func _process(delta):
	show_hide_panel()
	hide_others()

func show_hide_panel():
	var tween: Tween = get_tree().create_tween()
	if static_upgrades_panel == true:
		tween.tween_property(%MarginContainer, "position", Vector2(431,0), 0.5)#.set_trans(Tween.TRANS_CUBIC)
	else:
		tween.tween_property(%MarginContainer, "position", Vector2(543,0), 0.5)


func _on_static_upgrades_btn_pressed():
	static_upgrades_panel = !static_upgrades_panel

func hide_others():
	var tween: Tween = get_tree().create_tween()
	if SpawnUpgradesUi.static_upgrades_panel == true:
		tween.tween_property(%MarginContainer, "position", Vector2(580,0), 0.5)
	elif StaticUpgradesUi.static_upgrades_panel == false:
		tween.tween_property(%MarginContainer, "position", Vector2(543,0), 0.5)
