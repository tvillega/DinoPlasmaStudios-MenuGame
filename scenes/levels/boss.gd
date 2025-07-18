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
		overlay.show_dialogue("Goose", "I must hold as long as I can!", imag_goose)
	
