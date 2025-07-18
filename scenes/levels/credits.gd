extends Node2D

var interruptores_activados = 0
@onready var miniboss: CharacterBody2D = $miniboss # Asegúrate de que sea el nombre correcto de tu jefe

@onready var lobby_portal: Area2D = $LobbyPortal
@onready var interruptor: Area2D = $Interruptor
@onready var interruptor_2: Area2D = $Interruptor2
@onready var interruptor_3: Area2D = $Interruptor3

@onready var light_novel_intro: bool = true

@onready var overlay_scene = preload("res://ui/OverlayDialog.tscn")
@onready var imag_goose = preload("res://sprites/Domestic_goose_face.png") 

func _physics_process(delta: float) -> void:

	if not LobbyStats.beaten_lvl_2:
		lobby_portal.visible = false

func _ready():
	
	var overlay = overlay_scene.instantiate()
	add_child(overlay)
	
	for interruptor in get_tree().get_nodes_in_group("interruptores"):
		interruptor.connect("interruptor_activado", Callable(self, "_on_interruptor_activado"))
		
	if LobbyStats.beaten_lvl_2:
		interruptor.visible = false
		interruptor_2.visible = false
		interruptor_3.visible = false
		overlay.show_dialogue("Goose", "I already won!!! :D", imag_goose)
	else:
		overlay.show_dialogue("Goose", "I should attack the 3 statues", imag_goose)
	overlay.connect("dialogue_finished", Callable(self, "_on_dialogue_finished"))

func _on_interruptor_activado():
	interruptores_activados += 1
	print("Interruptores activados:", interruptores_activados)

	if interruptores_activados >= 3:
		if miniboss:
			miniboss.take_damage() # Aquí puedes cambiar por animación o efectos si prefiere

func _on_lobby_portal_body_entered(body: Node2D) -> void:
	if LobbyStats.beaten_lvl_2:
		get_tree().change_scene_to_file("res://scenes/lobby.tscn")
