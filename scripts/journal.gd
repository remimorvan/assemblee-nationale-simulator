extends Control

@onready var Text: Control = $RichTextLabel

func _ready() -> void:
	update("1er jour","1ere description","")

func update(title: String, desc: String, image_path: String):
	Text.bbcode_text = "[center][color=black][font_size=25][b]%s
[/b][font_size=15]%s" % [title,desc]
