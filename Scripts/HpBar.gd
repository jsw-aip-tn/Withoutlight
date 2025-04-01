extends ProgressBar

var current_health 

func update_health(amount, maxHp):
	current_health  = clamp(amount, 0, maxHp)
	value = current_health * 100 / maxHp
