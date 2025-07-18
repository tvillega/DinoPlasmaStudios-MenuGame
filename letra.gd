extends Area2D

@export var speed: float = 200.0
var velocity: Vector2 = Vector2.ZERO

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	change_to_goose_direction()
	if animation_player:
		animation_player.play("rayo")

func _physics_process(delta: float) -> void:
	position += velocity * delta

func change_to_goose_direction():
	var goose = get_parent().get_node_or_null("Goose")
	if goose == null:
		print("⚠ Goose no encontrado, proyectil destruido.")
		queue_free()
		return

	var dir = (goose.global_position - global_position).normalized()
	velocity = dir * speed

	# 🔥 Apuntar la punta del rayo hacia la dirección en que viaja
	rotation = dir.angle()

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		if body.has_method("receive_hit"):
			body.receive_hit()
		queue_free()
