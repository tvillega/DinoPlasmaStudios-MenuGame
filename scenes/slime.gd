extends CharacterBody2D

@export var speed = 400
@export var acceleration = 1000
@export var gravity = 2000
@export var jump = -1000

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@onready var jump_timer: Timer = $JumpTimer
@onready var randomGen : RandomNumberGenerator = RandomNumberGenerator.new()

@onready var hurtbox: Hurtbox = $Hurtbox

@onready var dead: bool = false
@onready var dead_count: int = 0

@onready var smash: AudioStreamPlayer2D = $Smash

func _ready() -> void:
	animated_sprite_2d.play("idle")
	randomGen.randomize()
	jump_timer.wait_time = float(randomGen.randi_range(0,5))

func _physics_process(delta: float) -> void:
	# more stable, 1/60 seconds
	
	if dead:
		if dead_count !=0:
			pass
		else:
			animated_sprite_2d.play("death")
			dead_count = 1
		return
	
	if not is_on_floor():
		velocity.y += gravity * delta
		
	else:
		animated_sprite_2d.play("idle")
		
	move_and_slide()

func take_damage() -> void:
	Debug.log("Slime took %d damage")

func _on_jump_timer_timeout() -> void:
	jump_timer.wait_time = float(randomGen.randi_range(0,5))
	velocity.y = jump

func _on_hurtbox_area_entered(area: Area2D) -> void:
	dead = true
	smash.play()
	await animated_sprite_2d.animation_finished
	queue_free()

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("damage"):
		if area.has_method("get_parent") and area.get_parent().has_method("receive_hit"):
			area.get_parent().receive_hit()
		queue_free()
