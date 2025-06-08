extends RigidBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var hitbox: Area2D = $Hitbox
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var launch_force: Vector2 = Vector2(0, -400)
@export var min_speed_to_exist: float = 5.0
@export var time_to_check: float = 2.0

var time_alive: float = 0.0
var exploded := false

func _ready():
	if physics_material_override == null:
		physics_material_override = PhysicsMaterial.new()
	physics_material_override.bounce = 1.0
	physics_material_override.friction = 0.0

	linear_damp = 0
	angular_damp = 0

	apply_impulse(Vector2.ZERO, launch_force)

	if animation_player.has_animation("bomb"):
		animation_player.play("bomb")

	hitbox.area_entered.connect(_on_hitbox_area_entered)

func _physics_process(delta):
	time_alive += delta
	if time_alive > time_to_check and linear_velocity.length() < min_speed_to_exist:
		queue_free()
		
func _on_hitbox_area_entered(area: Area2D) -> void:
	if exploded:
		return

	if area.is_in_group("damage"):
		exploded = true
		if area.has_method("get_parent") and area.get_parent().has_method("receive_hit"):
			area.get_parent().receive_hit()

		if animation_player.has_animation("explosion"):
			animation_player.play("explosion")
			await animation_player.animation_finished
		queue_free()
