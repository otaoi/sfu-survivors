extends Area2D

@export var xp_amount = 10
var target = null
var speed = -1

func _process(delta):
	if target:
		global_position = global_position.move_toward(target.global_position, speed * delta)
		speed += 500 * delta 

		if global_position.distance_to(target.global_position) < 10:
			collect()

func _on_body_entered(body):
	if body.is_in_group("player"):
		target = body
		speed = 400

func collect():
	target.gain_xp(xp_amount)
	queue_free()
