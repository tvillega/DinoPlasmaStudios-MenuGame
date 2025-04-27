extends CharacterBody2D
@export var speed = 200
@export var jump = 300
@export var gravity = 600
@export var aceleration = 700
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback = animation_tree["parameters/playback"]
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity*delta
	if is_on_floor() and Input.is_action_just_pressed("Jump"):
		velocity.y = -jump
		

	var move_input = Input.get_axis("Mov_left","Mov_right")
	velocity.x = move_toward(velocity.x, speed*move_input, aceleration*delta)
	
	if is_on_floor():
		if abs(velocity.x) > 10:
			playback.travel("walk")  # Caminando
		else:
			playback.travel("idle")  # Quieto
	else:
		if velocity.y < 0:
			playback.travel("flap")  # Subiendo (salto)
		else:
			playback.travel("fall")  # Cayendo (o usa "fall" si tienes animación)
	move_and_slide()
