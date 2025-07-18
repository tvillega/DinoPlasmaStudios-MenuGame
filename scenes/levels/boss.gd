extends Node2D

@onready var overlay_scene = preload("res://ui/OverlayDialog.tscn")
@onready var imag_goose = preload("res://sprites/Domestic_goose_face.png") 

@onready var stop_init_dialog: bool = false

func _ready():
	
	var overlay = overlay_scene.instantiate()
	add_child(overlay)

	overlay.show_dialogue("Goose", "I must hold as long as I can!", imag_goose)
	await get_tree().create_timer(5).timeout
	stop_init_dialog = true
	
	#overlay.connect("dialogue_finished", Callable(self, "_on_dialogue_finished"))

func _physics_process(delta: float) -> void:
	
	#var overlay = overlay_scene.instantiate()
	#add_child(overlay)

	if not stop_init_dialog:
		var overlay = overlay_scene.instantiate()
		add_child(overlay)
		if LobbyStats.beaten_lvl_3:
			overlay.show_dialogue("Goose", "Ready for a new round?", imag_goose)
		else:
			overlay.show_dialogue("Goose", "I must hold as long as I can!", imag_goose)
	
func _on_exit_timer_timeout() -> void:
	var overlay = overlay_scene.instantiate()
	add_child(overlay)
	overlay.show_dialogue("Goose", "I did it! I unlocked my game!", imag_goose)
	get_tree().paused = true
	await get_tree().create_timer(5).timeout
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/lobby.tscn")
	LobbyStats.beaten_lvl_3 = true
