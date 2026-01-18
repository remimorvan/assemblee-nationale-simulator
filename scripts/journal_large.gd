extends Area2D

@onready var Title: Label = $title
@onready var Content: Label = $content
@onready var Date: Label = $date
@onready var Illustration: TextureRect = $image
@onready var Player: Node2D = $"../Player"

func update(title: String, desc: String, image_name: String, day: int):
	Title.text = title
	Content.text = desc
	Date.text = str(day)+" janvier 2026"
	var image_path = "res://assets/card/illustrations/"+image_name
	if ResourceLoader.exists(image_path):
		Illustration.texture = load(image_path)
	else:
		print("Texture not found: " + image_path)

func show_journal() -> void:
	Player.is_journal_showed = true
	self.position = get_viewport().get_visible_rect().size/2
	self.scale = Vector2(2.3, 2.3)
	self.rotation_degrees = -7
	$"JournalSound".play()
	
func hide_journal() -> void:
	self.scale = Vector2(0.7, 0.7)
	self.position.x = 1790
	self.position.y = 830
	self.rotation_degrees = -87
	Player.is_journal_showed = false
	$"JournalSound".play()
	
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		if Player.is_journal_showed:
			hide_journal()
		else:
			show_journal()
