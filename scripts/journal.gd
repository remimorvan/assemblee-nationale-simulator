extends Area2D

@onready var Title: RichTextLabel = $title
@onready var Content: RichTextLabel = $content
@onready var Date: Label = $date
@onready var Illustration: TextureRect = $image
@onready var Player: Node2D = $"../Player"

var tween: Tween
signal journal_show
signal journal_hide
var show = true

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
	#Player.is_journal_showed = true
	journal_show.emit()
	await Player.hand_tween.finished
	show = true
	$"JournalSound".play()
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self, "position", get_viewport().get_visible_rect().size/2, .25)
	tween.parallel().tween_property(self, "scale", Vector2(2.3, 2.3), .25)
	tween.parallel().tween_property(self, "rotation_degrees", -7.0, .25)
	
func hide_journal() -> void:
	#Player.is_journal_showed = false
	show = false
	journal_hide.emit()
	$"JournalSound".play()
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self, "position", Vector2(1790, 850), .25)
	tween.parallel().tween_property(self, "scale", Vector2(0.7, 0.7), .25)
	tween.parallel().tween_property(self, "rotation_degrees", -87.0, .25)
	await tween.finished
	journal_hide.emit()
	
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		#if Player.is_journal_showed:
		if show:
			
			hide_journal()
			
		else:
			
			show_journal()
