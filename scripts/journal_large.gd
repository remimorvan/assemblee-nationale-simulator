extends Area2D

@onready var Title: Label = $title
@onready var Content: Label = $content
@onready var Date: Label = $content
@onready var Illustration: TextureRect = $image

func update(title: String, desc: String, image_name: String, day: int):
	Title.text = title
	Content.text = desc
	Date.text = str(day)+" janvier 2026"
	var image_path = "res://assets/card/illustrations/"+image_name
	if ResourceLoader.exists(image_path):
		Illustration.texture = load(image_path)
	else:
		print("Texture not found: " + image_path)
