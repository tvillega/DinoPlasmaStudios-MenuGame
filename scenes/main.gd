class_name MainScreen
extends Node2D

@onready var bottom: Area2D = $Bottom








func _on_bottom_body_entered(body: Node2D) -> void:
	#pass # Replace with function body.
	Debug.log("Level 1: Flying")
	get_tree().change_scene_to_file("res://scenes/levels/level1.tscn")
