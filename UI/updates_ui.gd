extends CanvasLayer

func _process(delta):
	pass
	#rotate_with_it()

func rotate_with_it():
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(%Panel, "rotation", 1.0, .1).as_relative()
	tween.tween_interval(1.0)
	tween.tween_property(%Panel, "rotation", -1.0, .1).as_relative()
	


func _on_panel_mouse_entered():
	rotate_with_it()
