extends CharacterBody2D

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback = animation_tree.get("parameters/playback")
@onready var sprite: Sprite2D = $Sprite2D

@export var speed: float = 100.0
@export var corner_tolerance: float = 10.0
@export var shoot_interval: float = 2.0
@export var egg_scene: PackedScene

var corners: Array = []
var target_index := 0
var shoot_timer := 0.0
var is_damaged := false  # 🔸 NUEVA VARIABLE

func _ready():
	corners = [
		Vector2(20, 20),      
		Vector2(1100, 20),   
		Vector2(1100, 200),  
		Vector2(20, 200)     
	]
	global_position = corners[0]
	playback.travel("trudfly")

func _physics_process(delta):
	
	if LobbyStats.beaten_lvl_2:
		queue_free()
	
	if is_damaged:  # 🔸 EVITA QUE SE MUEVA O DIS PARE SI ESTÁ DAÑADO
		return
	
	move_to_next_corner()
	shoot_timer += delta
	if shoot_timer >= shoot_interval:
		shoot_timer = 0.0
		shoot_egg()

func move_to_next_corner():
	var target = corners[target_index]
	var direction = (target - global_position).normalized()
	velocity = direction * speed
	move_and_slide()

	if abs(direction.x) > abs(direction.y):
		playback.travel("dash")
		sprite.flip_h = direction.x < 0
	else:
		playback.travel("dashup")
		sprite.flip_h = direction.y > 0

	if global_position.distance_to(target) < corner_tolerance:
		target_index = (target_index + 1) % corners.size()

func shoot_egg():
	if egg_scene:
		var egg = egg_scene.instantiate() as RigidBody2D
		get_tree().current_scene.add_child(egg)
		egg.global_position = global_position + Vector2(0, 20)

func take_damage():
	is_damaged = true
	playback.travel("damage")
	LobbyStats.beaten_lvl_2 = true
	PlayerStats.can_fly = true
	await get_tree().create_timer(2).timeout
	queue_free()
