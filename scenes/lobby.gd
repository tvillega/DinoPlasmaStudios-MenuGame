class_name Lobby
extends Node2D

@onready var goose: Goose = $Players/Goose

@onready var bottom: Area2D = $Bottom

@onready var start_floor: CollisionShape2D = $FakeUI/Start/CollisionShape2D
@onready var start_button: Button = $FakeUI/Start/Button

@onready var settings: CollisionShape2D = $FakeUI/Settings/CollisionShape2D
@onready var settings_button: Button = $FakeUI/Settings/Button

@onready var credits_portal: CollisionShape2D = $EnterCredits/CollisionShape2D
@onready var creddits_button: Button = $FakeUI/Credits/Button

# Right side of the lobby 
@onready var invisible_wall_right: CollisionShape2D = $InvisibleWallRight/CollisionShape2D
@onready var portal_wall_right: Area2D = $PortalWallRight

# Left side of the lobby
@onready var invisible_wall_left: CollisionShape2D = $InvisibleWallLeft/CollisionShape2D
@onready var portal_wall_left: Area2D = $PortalWallLeft

@onready var overlay_scene = preload("res://ui/OverlayDialog.tscn")
@onready var imag_goose = preload("res://sprites/Domestic_goose_face.png") 

func _ready() -> void:
	
	var overlay = overlay_scene.instantiate()
	add_child(overlay)

	##
	## Setup right side of the lobby
	##d
	if LobbyStats.beaten_lvl_1:
		credits_portal.disabled = false
		invisible_wall_right.disabled = true
		settings.disabled = true
		
	else:
		credits_portal.disabled = true
		settings_button.disabled = true
		
	if LobbyStats.beaten_lvl_2:
		overlay.show_dialogue("Goose", "Maye I should give some use to this wings", imag_goose)
		
	else:
		creddits_button.disabled = true
		
	if LobbyStats.beaten_lvl_3:
		pass
		
	else:
		start_floor.disabled = true
		start_button.disabled = true
		
	overlay.connect("dialogue_finished", Callable(self, "_on_dialogue_finished"))

func _on_bottom_body_entered(body: Node2D) -> void:
	
	if not LobbyStats.beaten_lvl_1:
		Debug.log("Level 1: Jump")
		get_tree().change_scene_to_file("res://scenes/levels/level1.tscn")

##
## Right side of the lobby
##

func _on_portal_wall_right_entered(body: Node2D) -> void:
	Debug.log("Revisiting Level 1")
	get_tree().change_scene_to_file("res://scenes/levels/level1.tscn")

func _on_enter_credits_body_entered(body: Node2D) -> void:
	if LobbyStats.beaten_lvl_2:
		var overlay = overlay_scene.instantiate()
		add_child(overlay)
		overlay.show_dialogue("Goose", "Maybe I should give some use to this wings", imag_goose)
		overlay.connect("dialogue_finished", Callable(self, "_on_dialogue_finished"))
	else:
		Debug.log("Level: 2 Flying")
		get_tree().change_scene_to_file("res://scenes/levels/credits.tscn")

func _on_portal_roof_area_entered(area: Area2D) -> void:
	get_tree().change_scene_to_file("res://scenes/levels/boss.tscn")
