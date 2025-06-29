extends Area2D

signal interruptor_activado

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var sprite_2d: Sprite2D = $Sprite2D

var activado = false

func _on_body_entered(body):
	if body.name == "Goose" and not activado:
		activado = true
		emit_signal("interruptor_activado")
		audio_stream_player_2d.play()
		sprite_2d.visible = false
		await get_tree().create_timer(10).timeout
		queue_free()  # o cambia sprite, o animación
