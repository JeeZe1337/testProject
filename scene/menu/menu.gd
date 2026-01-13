extends Node2D
const FIRST_LEVEL = "res://scene/level/level.tscn"

func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file(FIRST_LEVEL)
