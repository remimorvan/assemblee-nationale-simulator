extends Control

@onready var Text: Control = $RichTextLabel

func _ready() -> void:
	update_journal("1er jour","1ere description","")

func update_journal(title: String, desc: String, image_path: String):
	Text.bbcode_text = "[center][color=black][font_size=25][b]%s
[/b]%s" % [title,desc]
