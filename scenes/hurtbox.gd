class_name Hurtbox
extends Area2D

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if area.has_method("deal_damage"):
		area.deal_damage(get_parent())  # ✅ Aquí está el cambio
