class_name Level1
extends Node2D
@onready var unlock_flying: Area2D = $UnlockFlying
@onready var goose: CharacterBody2D = $Players/Goose
@onready var button: Button = $UnlockFLying/Button
@onready var overlay_scene = preload("res://ui/OverlayDialog.tscn")
@onready var imag_goose = preload("res://sprites/Domestic_goose_face.png") 

@onready var visit_count: int = LobbyStats.lvl1_visits

func _ready() -> void:
	
	button.disabled = true #Desactiva controles desde el principio
	
	var overlay = overlay_scene.instantiate()
	add_child(overlay)
	
	if LobbyStats.beaten_lvl_1:
		Debug.log("Already beaten")
		#button.disabled = true
		overlay.show_dialogue("Goose", "Now I can jump, I have no problems with you!!!", imag_goose)
	else:
		match visit_count:
			0:
				_show_dialogue("Goose","I don't think that those things are friendly")
			1:
				_show_dialogue("Goose","I should pay attention to the rhythm at which they jump")
			_:
				_show_dialogue("Goose","If I run over those things??")
		LobbyStats.lvl1_visits += 1
		#overlay.show_dialogue("Goose", "I don't think that those things are friendly", imag_goose)
	overlay.connect("dialogue_finished", Callable(self, "_on_dialogue_finished"))

func _on_unlock_flying_body_entered(body: Node2D) -> void:

	Debug.log("Unlocked Jump")
	PlayerStats.can_jump = true
	LobbyStats.beaten_lvl_1 = true
	get_tree().change_scene_to_file("res://scenes/lobby.tscn")

func _on_area_2d_body_entered(body: Node2D) -> void:
	Debug.log("Returning to Lobby")
	get_tree().change_scene_to_file("res://scenes/lobby.tscn")
	
func _show_dialogue(name: String, text: String) -> void:
		var overlay = overlay_scene.instantiate()
		add_child(overlay)
		overlay.show_dialogue(name, text, imag_goose)
		overlay.connect("dialogue_finished", Callable(self, "_on_dialogue_finished"))
		
func _on_dialogue_finished():
	button.disabled = false  # Ahora el jugador puede interactuar
