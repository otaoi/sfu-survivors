extends CanvasLayer

@onready var health_bar = $HealthBar
@onready var xp_bar = $XPBar
@onready var timer_label = $TimerLabel

func update_timer(seconds):
	var m = int(seconds / 60)
	var s = int(seconds) % 60
	timer_label.text = "%02d:%02d" % [m, s]

func update_health(current_hp, max_hp):
	health_bar.max_value = max_hp
	health_bar.value = current_hp

func update_xp(current_xp, needed_xp):
	xp_bar.max_value = needed_xp
	xp_bar.value = current_xp
