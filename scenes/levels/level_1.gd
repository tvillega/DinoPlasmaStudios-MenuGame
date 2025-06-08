class_name Level1
extends Node2D
@onready var unlock_flying: Area2D = $UnlockFlying
@onready var goose: CharacterBody2D = $Players/Goose

func _ready() -> void:

	if LobbyStats.beaten_lvl_1:
		Debug.log("Already beaten")

func _on_unlock_flying_body_entered(body: Node2D) -> void:

	Debug.log("Unlocked Jump")
	PlayerStats.can_jump = true
	LobbyStats.beaten_lvl_1 = true
	get_tree().change_scene_to_file("res://scenes/lobby.tscn")


func _on_area_2d_body_entered(body: Node2D) -> void:
	Debug.log("Returning to Lobby")
	get_tree().change_scene_to_file("res://scenes/lobby.tscn")
	
