extends Area2D

var speed = 600
var direction = Vector2.RIGHT
var damage = 10

func _process(delta):
	position += direction * speed * delta

func _on_body_entered(body):
	
	if body.is_in_group("enemies"):
		if body.has_method("take_damage"):
			body.take_damage(damage)
			queue_free() 
		else:
			print("Errored here proj")
