extends Area2D

signal interruptor_activado

var activado = false

func _on_body_entered(body):
	if body.name == "Goose" and not activado:
		activado = true
		emit_signal("interruptor_activado")
		queue_free()  # o cambia sprite, o animación
