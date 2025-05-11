class_name Level1
extends Node2D

@onready var unlock_flying: Area2D = $UnlockFlying
@onready var goose: CharacterBody2D = $Players/Goose

func _on_unlock_flying_body_entered(body: Node2D) -> void:
	#pass # Replace with function body.
	Debug.log("Unlocked Jump")
	PlayerStats.flying = true
	get_tree().change_scene_to_file("res://scenes/main.tscn")
