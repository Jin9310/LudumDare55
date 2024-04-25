extends CanvasLayer

func _process(delta):
	pass
	#rotate_with_it()

func rotate_with_it():
	var tween: Tween = get_tree().create_tween().set_loops()
	tween.tween_property(%Panel, "rotation_degrees", 20, .5).as_relative().set_trans(Tween.TRANS_BOUNCE)
	tween.tween_interval(1.0)
	tween.tween_property(%Panel, "rotation_degrees", -40, .5).as_relative()
	
