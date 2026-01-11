extends Control


@onready var title_label = $ColorRect/VBoxContainer/Label

func _ready():
	var tween = create_tween().set_loops() # .set_loops() makes it run forever
	

	tween.tween_property(title_label, "modulate", Color.RED, 1.0)
	
	tween.tween_property(title_label, "modulate", Color.BLACK, 1.0)


func _on_exit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
