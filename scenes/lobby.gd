class_name Lobby
extends Node2D

@onready var bottom: Area2D = $Bottom
@onready var bottom_teleporter: CollisionShape2D = $Bottom/BottomTeleporter

# Right side of the lobby 
@onready var invisible_wall_right: CollisionShape2D = $InvisibleWallRight/CollisionShape2D
@onready var portal_wall_right: Area2D = $PortalWallRight

# Left side of the lobby
@onready var invisible_wall_left: CollisionShape2D = $InvisibleWallLeft/CollisionShape2D
@onready var portal_wall_left: Area2D = $PortalWallLeft

func _ready() -> void:

	##
	## Setup right side of the lobby
	##d
	pass
	#if LobbyStats.beaten_lvl_1:
		#invisible_wall_right.disabled = true

func _on_bottom_body_entered(body: Node2D) -> void:
	
	if not LobbyStats.beaten_lvl_1:
		Debug.log("Level 1: Jump")
		get_tree().change_scene_to_file("res://scenes/levels/level1.tscn")
	else:
		Debug.log("Level 2: Fly")
		get_tree().change_scene_to_file("res://scenes/levels/level2.tscn")

##
## Right side of the lobby
##

func _on_portal_wall_right_entered(body: Node2D) -> void:
	Debug.log("Revisiting Level 1")
	get_tree().change_scene_to_file("res://scenes/levels/level1.tscn")
