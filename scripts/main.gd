extends Node2D

@export var enemy_scene: PackedScene

func _ready():
	$EnemySpawner.timeout.connect(_on_enemy_spawner_timeout)

func _on_enemy_spawner_timeout():
	var enemy = enemy_scene.instantiate()
	
	var player_pos = $WorldEntities/Player.global_position
	var random_angle = randf() * TAU
	var distance = 1300 
	var spawn_pos = player_pos + Vector2(cos(random_angle), sin(random_angle)) * distance

	enemy.global_position = spawn_pos
	$WorldEntities.add_child(enemy)
	var player = get_tree().get_first_node_in_group("player")
	
	if player:
		# Calculate how many minutes have passed
		var minutes = player.time_elapsed / 60.0
		
		var new_wait_time = 3.0 / (1.0 + minutes)
		
		# Safety Cap: Don't let it go below 0.1s or the game might crash
		$EnemySpawner.wait_time = max(0.1, new_wait_time)
