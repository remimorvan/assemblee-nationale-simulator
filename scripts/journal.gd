extends Control

@onready var Text: Control = $RichTextLabel

func _ready() -> void:
	update("1er jour","1ere description","")

func update(title: String, desc: String, image_name: String):
	Text.bbcode_text = "[center][color=black][font_size=25][b]%s
[/b][font_size=15]%s" % [title,desc]
	var image_path = "res://assets/card/illustrations/"+image_name
	if ResourceLoader.exists(image_path):
		$Image.texture = load(image_path)
	else:
		print("Texture not found: " + image_path)
