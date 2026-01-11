extends Control


func _ready():
	get_tree().paused = false

func game_over():
	visible = true
	get_tree().paused = true 

func _on_exit_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")
