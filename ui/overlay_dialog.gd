extends CanvasLayer

@onready var name_label = $Panel/CharacterName
@onready var text_label = $Panel/DialogueText
@onready var portrait = $Panel/Portrait

var auto_remove_on_end = true  # opcional

func set_dialogue(name: String, text: String, portrait_texture: Texture = null):
	name_label.text = name
	text_label.text = text
	if portrait_texture:
		portrait.texture = portrait_texture
	else:
		portrait.texture = null

signal dialogue_finished

func show_dialogue(name: String, text: String, portrait_texture: Texture = null):
	set_dialogue(name, text, portrait_texture)
	visible = true

func hide_dialogue():
	visible = false
	emit_signal("dialogue_finished")
	if auto_remove_on_end:
		queue_free()
		
func _input(event):
	if event is InputEventKey and event.pressed:
		hide_dialogue()
