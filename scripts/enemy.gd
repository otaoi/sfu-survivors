extends CharacterBody2D
@export var gem_scene: PackedScene
@onready var sprite = $Sprite2D
@export var speed = 115
@export var health = 30
@export var skins: Array[Texture2D]

@onready var player = get_tree().get_first_node_in_group("player")
func _ready():
	if skins.size() > 0:
		sprite.texture = skins.pick_random()
	
	
	if player:
		var time_min = player.time_elapsed / 60
		

		health = health * (1 + (0.5 * time_min))
		
		speed = min(speed * (1 + (0.1 * time_min)), 400)
		


func _physics_process(_delta):
	if player:
		var dist = global_position.distance_to(player.global_position)
		

		if dist > 50.0:
			var direction = global_position.direction_to(player.global_position)
			velocity = direction * speed
			move_and_slide()

func take_damage(amount):
	health -= amount
	modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	modulate = Color.WHITE
	
	if health <= 0:
		die()

func die():
	if gem_scene:
		var gem = gem_scene.instantiate()
		gem.global_position = global_position
		get_tree().current_scene.call_deferred("add_child", gem)

	queue_free()
