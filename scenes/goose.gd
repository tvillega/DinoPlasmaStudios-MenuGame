class_name Goose
extends CharacterBody2D

@export var speed = 300
@export var og_jump = 400 # Beacuse jump could be 0
@export var jump = 400
@export var gravity = 600
@export var aceleration = 1500

@onready var hurtbox: Hurtbox = $Hurtbox

@onready var sprite: Sprite2D = $Sprite2D
@onready var label: Label = $Label

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback = animation_tree["parameters/playback"]

@onready var pivot: Node2D = $Pivot
@onready var glasses: Sprite2D = $"Pivot/Meme-glasses"

@onready var dead = false

@onready var hoonk = preload("res://SFX/Hoonk.wav")
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var fly_sound: AudioStreamPlayer2D = $FlySound
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound

@onready var full_body_hurtbox: CollisionShape2D = $Hurtbox2/CollisionShape2D

func _ready() -> void:
	if PlayerStats.can_fly:
		full_body_hurtbox.disabled = false
	else:
		full_body_hurtbox.disabled = true
		

func _physics_process(delta: float) -> void:

	if dead and not PlayerStats.inmortal:
		label.text = "OH NO"
		return

	if PlayerStats.can_fly:
		glasses.visible = true
	else:
		glasses.visible = false

	# Gatekeep jumping by setting it to zero
	if not PlayerStats.can_jump:
		jump = 0
	else:
		jump = og_jump

	if not is_on_floor() and Input.is_action_just_pressed("Jump") and PlayerStats.can_fly:
		if not PlayerStats.can_jump:
			label.text = "Can't jump"
		velocity.y = -jump
		fly_sound.play()

	elif not is_on_floor():
		velocity.y += gravity*delta

	elif is_on_floor() and Input.is_action_just_pressed("Jump"):
		if not PlayerStats.can_jump:
			label.text = "Can't jump"
			audio_stream_player_2d.play()
		else:
			velocity.y = -jump
			jump_sound.play()
			
	var move_input = Input.get_axis("Mov_left","Mov_right")

	if move_input < 0:
		sprite.flip_h = true
		hurtbox.scale.x = -1
	elif move_input > 0:
		sprite.flip_h = false
		hurtbox.scale.x = 1
		
	if move_input != 0:
		pivot.scale.x = sign(move_input)
	
	velocity.x = move_toward(velocity.x, speed*move_input, aceleration*delta)
	
	if is_on_floor():
		if abs(velocity.x) > 10 and velocity.y == 0:
			if abs(velocity.x) > og_jump*1.2:
				label.text = "INCOMING!!"
				audio_stream_player_2d.play()
			else:
				if not PlayerStats.can_jump:
					label.text = "Let's walk"
				else:
					label.text = ""
			playback.travel("walk")  # Caminando
		elif velocity.y == 0:
			#label.text = ""
			playback.travel("idle")  # Quieto
	else:
		if velocity.y < 0:
			playback.travel("flap")  # Subiendo (salto)
		elif velocity.y == 0:
			label.text = ""
		else:
			if velocity.y > jump+50:
				if PlayerStats.can_fly:
					label.text = "MVP can fly"
				else:
					label.text = "I CAN'T FLY"
			playback.travel("fall")  # Cayendo (o usa "fall" si tienes animación)
	move_and_slide()
	
func receive_hit():
	
	if PlayerStats.inmortal:
		return
		
	dead = true
	Debug.log("You've been slayed, returning to Lobby.")
	audio_stream_player_2d.play()
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file("res://scenes/lobby.tscn")
	#queue_free()  # Esto elimina al ganso
	
