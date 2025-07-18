extends CharacterBody2D

# --- Nodos ---
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D

# --- Propiedades de Movimiento ---
@export var base_speed: float = 90.0
@export var var_gravity: float = 700.0
@export var patrol_range: float = 200.0
@export var jump_velocity: float = -300.0
@export var obstacle_detection_distance: float = 30.0

# --- Disparo ---
@export var base_shoot_cooldown: float = 2.0
var shoot_cooldown: float = base_shoot_cooldown
var can_shoot: bool = true
var LetterProjectile = preload("res://letra.tscn")

# --- Resistencia / Tiempo de vida ---
@export var time_to_live: float = 30.0
var max_time: float = 30.0
var is_alive: bool = true

# --- Variables Internas ---
var random_direction: int = 0
var change_state_timer: float = 0.0
var initial_position: Vector2

func _ready():
	randomize()
	initial_position = global_position
	max_time = time_to_live

	if animation_player:
		animation_player.play("idle")
	else:
		print("ERROR: AnimationPlayer no asignado")

	decide_next_action()
	change_state_timer = randf_range(1.5, 3.0)


func _physics_process(delta: float) -> void:
	if is_alive:
		update_aggressiveness(delta)
		apply_gravity(delta)
		update_state(delta)

		if is_on_floor() and check_for_obstacle():
			perform_jump()

		if can_shoot:
			shoot_letter()

		velocity.x = random_direction * base_speed
		move_and_slide()
		detect_walls()
		update_animations()


func update_aggressiveness(delta: float):
	time_to_live -= delta
	if time_to_live <= 0:
		die()

	# Aumenta agresividad con el tiempo
	var progress = 1.0 - (time_to_live / max_time)
	base_speed = lerp(90.0, 300.0, progress) # Más rápido
	shoot_cooldown = lerp(base_shoot_cooldown, 0.1, progress) # Dispara cada 0.1s al final


func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += var_gravity * delta
	else:
		velocity.y = 0


func update_state(delta: float) -> void:
	change_state_timer -= delta
	if change_state_timer <= 0:
		decide_next_action()
		change_state_timer = randf_range(1.5, 3.0)

	if abs(global_position.x - initial_position.x) > patrol_range:
		random_direction *= -1
		initial_position.x = global_position.x


func decide_next_action() -> void:
	var actions = [-1, 0, 1]
	random_direction = actions[randi() % actions.size()]


func detect_walls() -> void:
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if abs(collision.get_normal().x) > 0.5:
			if collision.get_collider() is StaticBody2D:
				random_direction *= -1
				change_state_timer = 0.5
				break


func check_for_obstacle() -> bool:
	var ray_cast = $ObstacleRayCast
	if not ray_cast:
		printerr("ERROR: Nodo ObstacleRayCast2D no encontrado")
		return false

	if random_direction == 1:
		ray_cast.target_position = Vector2(obstacle_detection_distance, 0)
	elif random_direction == -1:
		ray_cast.target_position = Vector2(-obstacle_detection_distance, 0)
	else:
		return false

	ray_cast.force_raycast_update()
	if ray_cast.is_colliding():
		var collider = ray_cast.get_collider()
		if collider is StaticBody2D:
			return true
	return false


func perform_jump() -> void:
	if is_on_floor():
		velocity.y = jump_velocity
		random_direction *= -1
		initial_position.x = global_position.x


func shoot_letter():
	if not can_shoot:
		return

	var goose = get_parent().get_node_or_null("Goose")
	if goose == null:
		return

	var dir_to_goose = (goose.global_position - global_position).normalized()
	var progress = 1.0 - (time_to_live / max_time)
	var bullet_speed = lerp(200.0, 800.0, progress)

	# Gradualidad de balas: 1 → 2 → 3
	var num_bullets = 1
	if progress > 0.33 and progress <= 0.66:
		num_bullets = 2
	elif progress > 0.66:
		num_bullets = 3

	# 🔥 Patrón circular cada 5 s en la segunda mitad de la pelea
	if int(time_to_live) % 5 == 0 and progress > 0.5:
		disparar_circular(bullet_speed)
	else:
		var angle_offsets = []
		if num_bullets == 1:
			angle_offsets = [0]
		elif num_bullets == 2:
			angle_offsets = [-0.1, 0.1]
		else:
			angle_offsets = [-0.2, 0, 0.2]

		for angle_offset in angle_offsets:
			var letter = LetterProjectile.instantiate()

			# Subida alta antes de redirigirse
			var subida_speed = 500.0
			var subida_tiempo = 0.5
			letter.position = global_position
			letter.velocity = Vector2(0, -1) * subida_speed

			var final_dir = dir_to_goose.rotated(angle_offset)
			get_tree().create_timer(subida_tiempo).timeout.connect(func():
				if letter and letter.is_inside_tree():
					letter.velocity = final_dir * bullet_speed
			)

			letter.body_entered.connect(func(body):
				if body.name == "Goose" and body.has_method("receive_hit"):
					body.receive_hit()
					letter.queue_free()
			)

			get_parent().add_child(letter)

	can_shoot = false
	await get_tree().create_timer(shoot_cooldown).timeout
	can_shoot = true


func disparar_circular(bullet_speed: float):
	var total_balas = 12 # 12 balas en 360°
	for i in range(total_balas):
		var angle = deg_to_rad((360 / total_balas) * i)
		var dir = Vector2(cos(angle), sin(angle)).normalized()

		var letter = LetterProjectile.instantiate()
		letter.position = global_position
		letter.velocity = dir * bullet_speed

		letter.body_entered.connect(func(body):
			if body.name == "Goose" and body.has_method("receive_hit"):
				body.receive_hit()
				letter.queue_free()
		)

		get_parent().add_child(letter)


func die():
	is_alive = false
	print("El jefe se ha cansado y muere!")
	if animation_player:
		animation_player.play("death")
	await get_tree().create_timer(1.0).timeout
	queue_free()


func update_animations() -> void:
	if not animation_player:
		return

	if is_on_floor():
		if abs(velocity.x) < 5:
			if animation_player.current_animation != "idle":
				animation_player.play("idle")
		else:
			if animation_player.current_animation != "run":
				animation_player.play("run")
	else:
		if velocity.y < 0 and animation_player.current_animation != "jump":
			animation_player.play("jump")
		elif velocity.y > 0 and animation_player.current_animation != "fall":
			animation_player.play("fall")

	if velocity.x != 0:
		sprite.flip_h = velocity.x < 0
