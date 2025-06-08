class_name Goose
extends CharacterBody2D

@export var speed = 300
@export var og_jump = 300 # Beacuse jump could be 0
@export var jump = 300
@export var gravity = 600
@export var aceleration = 1500

@onready var sprite: Sprite2D = $Sprite2D
@onready var label: Label = $Label

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback = animation_tree["parameters/playback"]
@onready var glasses = $"Meme-glasses"

func _ready() -> void:
	if not PlayerStats.can_fly:
		glasses.visible = false

func _physics_process(delta: float) -> void:
	
	# Gatekeep jumping by setting it to zero
	if not PlayerStats.can_jump:
		jump = 0
	else:
		jump = og_jump
		
	if not is_on_floor():
		velocity.y += gravity*delta
	
	elif is_on_floor() and Input.is_action_just_pressed("Jump"):
		if not PlayerStats.can_jump:
			Debug.log("I can't jump. There must be a way to unlock it.")
		velocity.y = -jump

	var move_input = Input.get_axis("Mov_left","Mov_right")

	if move_input < 0:
		sprite.flip_h = true
	elif move_input > 0:
		sprite.flip_h = false
	
	velocity.x = move_toward(velocity.x, speed*move_input, aceleration*delta)
	
	if is_on_floor():
		if abs(velocity.x) > 10 and velocity.y == 0:
			if abs(velocity.x) > og_jump*1.5:
				label.text = "INCOMING!!"
			else:
				label.text = ""
			playback.travel("walk")  # Caminando
		elif velocity.y == 0:
			label.text = ""
			playback.travel("idle")  # Quieto
	else:
		if velocity.y < 0:
			playback.travel("flap")  # Subiendo (salto)
		elif velocity.y == 0:
			label.text = ""
		else:
			if velocity.y > jump+50:
				label.text = "I CAN'T FLY"
			playback.travel("fall")  # Cayendo (o usa "fall" si tienes animación)
	move_and_slide()
