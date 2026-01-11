extends CanvasLayer

signal upgrade_selected(upgrade_type)

@onready var container = $VBoxContainer

# Define your upgrades here
var options = [
	{"id": "speed", "name": "Trash COFEEEEEEE", "desc": "++Movement Speed"},
	{"id": "damage", "name": "Rocks in the paper", "desc": "+25% Damage"},
	{"id": "fire_rate", "name": "Nimble Small AND FAST HANDS", "desc": "+20% Fire Rate"},
	{"id": "health", "name": "Deodorant", "desc": "+20 Health"},
	{"id": "size", "name": "A8 Paper?", "desc": "+50% Bullet Size"},
	{"id": "multishot", "name": "More Paper, More Problems", "desc": "+1 Projectile, but -20% Fire Rate and -5% Speed"}
]

func _ready():
	visible = false

func show_options():
	visible = true
	get_tree().paused = true 
	

	for child in container.get_children():
		child.queue_free()
	
	
	var choices = options.duplicate()
	choices.shuffle()
	var daily_specials = choices.slice(0, 3) 
	
	# Create Buttons
	for item in daily_specials:
		var btn = Button.new()
		btn.text = item["name"] + "\n" + item["desc"]
		btn.custom_minimum_size = Vector2(200, 60)
		container.add_child(btn)
		

		btn.pressed.connect(_on_btn_pressed.bind(item["id"]))

func _on_btn_pressed(id):
	emit_signal("upgrade_selected", id)
	visible = false
	get_tree().paused = false 
