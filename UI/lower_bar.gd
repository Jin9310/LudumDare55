extends CanvasLayer

var rounded_money = GameManager.usable_money

func _process(delta):
	#%money.text = "Money: " + "%.2f" % rounded_money
	%Usable_mone_lbl.text = str(GameManager.usable_money)
