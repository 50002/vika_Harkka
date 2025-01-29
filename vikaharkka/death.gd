extends Control



func _on_again_pressed() -> void:
	get_tree().change_scene_to_file("res://Map.tscn")
	



func _on_pussy_pressed() -> void:
	get_tree().change_scene_to_file("res://start.tscn")
