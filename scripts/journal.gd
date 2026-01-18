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
	if ResourceLoader.exists(image_name):
		Illustration.texture = load(image_name)
	else:
		print("Texture not found: " + image_name)

func update_with_basic(day: int) -> void:
	var json = JSON.new()
	var file = FileAccess.open("res://assets/journals.json", FileAccess.READ)
	var error = json.parse(file.get_as_text())
	if error == OK:
		var data_received = json.data
		if typeof(data_received) == TYPE_ARRAY:
			var title = data_received[day-1]["title"]
			var content = data_received[day-1]["content"]
			var image_name = "res://assets/card/illustrations/random.png"
			update(title, content, image_name, day)
		else:
			print("Unexpected data")
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in journals.json at line ", json.get_error_line())

func show_journal() -> void:
	Player.is_journal_showed = true
	self.position = get_viewport().get_visible_rect().size/2
	self.scale = Vector2(2.3, 2.3)
	self.rotation_degrees = -7
	$"JournalSound".play()
	
func hide_journal() -> void:
	self.scale = Vector2(0.7, 0.7)
	self.position.x = 1790
	self.position.y = 850
	self.rotation_degrees = -87
	Player.is_journal_showed = false
	$"JournalSound".play()
	
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		if Player.is_journal_showed:
			hide_journal()
		else:
			show_journal()
