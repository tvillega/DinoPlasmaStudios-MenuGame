extends Node2D

var interruptores_activados = 0
@onready var miniboss: CharacterBody2D = $miniboss # Asegúrate de que sea el nombre correcto de tu jefe

func _ready():
	for interruptor in get_tree().get_nodes_in_group("interruptores"):
		interruptor.connect("interruptor_activado", Callable(self, "_on_interruptor_activado"))

func _on_interruptor_activado():
	interruptores_activados += 1
	print("Interruptores activados:", interruptores_activados)

	if interruptores_activados >= 3:
		miniboss.take_damage() # Aquí puedes cambiar por animación o efectos si prefiere
	
