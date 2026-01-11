extends CharacterBody2D
@export var projectile_scene: PackedScene
@export var speed: float = 200.0
@export var health = 100
@onready var damage_timer = $DamageTimer
@onready var sprite = $Sprite2D
@onready var hurt_box = $HurtBox
signal leveled_up
var level = 1
var current_xp = 0
var xp_needed = 50
var is_dead
@export var damage_mult: float = 1.0
@export var bullet_scale: float = 1.0
@export var shot_count: int = 1
var time_elapsed = 0.0
signal health_changed(new_hp, max_hp)
signal xp_changed(new_xp, max_xp)
@onready var hud = get_tree().get_first_node_in_group("hud")

func _process(delta):
	
	time_elapsed += delta
	if hud:
		hud.update_timer(time_elapsed)

func _physics_process(_delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed
	move_and_slide()
	
	if direction.x < 0:
		$Sprite2D.flip_h = true
	elif direction.x > 0:
		$Sprite2D.flip_h = false

	check_hurtbox()

func check_hurtbox():
	if is_dead:
		return
	# all that is touching the box touchy touchy
	var bodies = hurt_box.get_overlapping_bodies()
	
	# is something touching and is timer ready?
	if bodies.size() > 0 and damage_timer.is_stopped():
		for body in bodies:
			if body.is_in_group("enemies"):
				take_damage(10)
				damage_timer.start() 
				#var push_dir = global_position.direction_to(body.global_position)
				
				#body.global_position += push_dir * 50
				#break 

func take_damage(amount):
	health -= amount
	health_changed.emit(health, 100) # Assuming 100 is max health
	
	
	sprite.modulate = Color(1, 0, 0) 
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color(1, 1, 1) 
	
	if health <= 0:
		die()

func die():
	is_dead = true
	if is_inside_tree(): 
		get_tree().paused = false
		get_tree().change_scene_to_file("res://scenes/DeadMenu.tscn")




func _on_attack_timer_timeout():
	var targets = $AttackRange.get_overlapping_bodies()
	var enemies = []
	
	for body in targets:
		if body.is_in_group("enemies"):
			enemies.append(body)
			
	if enemies.size() == 0:
		return

	
	enemies.sort_custom(func(a, b): 
		return global_position.distance_squared_to(a.global_position) < global_position.distance_squared_to(b.global_position)
	)
	

	for i in range(shot_count):
		if enemies.size() > 0:
			var target_index = i % enemies.size()
			var target = enemies[target_index]
			shoot_at(target)

func shoot_at(target):
	if projectile_scene:
		var bullet = projectile_scene.instantiate()
		bullet.global_position = global_position
		
		bullet.damage = bullet.damage * damage_mult
		bullet.scale = Vector2(bullet_scale, bullet_scale)
	
		bullet.direction = global_position.direction_to(target.global_position)
		bullet.look_at(target.global_position)
		
		get_tree().current_scene.add_child(bullet)
func gain_xp(amount):
	current_xp += amount
	xp_changed.emit(current_xp, xp_needed)
	
	if current_xp >= xp_needed:
		level_up()

func level_up():
	level += 1
	current_xp -= xp_needed 
	xp_needed = int(xp_needed * 1.5) 
	print("LEVEL UP! Now Level: ", level)
	
	
	leveled_up.emit()




	
func apply_upgrade(id):
	print("Applying Upgrade: ", id)
	match id:
		"speed":
			speed += 50
			print("Speed Up: ", speed)
		"damage":
			damage_mult += 0.5 # +50% Damage
			print("Damage Up: ", damage_mult)
		"fire_rate":
			$AttackTimer.wait_time *= 0.8
		"health":
			health += 20
		"size":
			bullet_scale += 0.5 
		"multishot":
			shot_count += 1 
			$AttackTimer.wait_time *= 1.2
			speed *= 0.95
