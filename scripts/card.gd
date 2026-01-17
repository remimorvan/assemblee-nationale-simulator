extends Node2D

var text: String # Text of the card
var effect: Dictionary[String, float] # like social, french fries, economy
var image_path: String # Text of the card

# Called when the node enters the scene tree for the first time.
func setup(_text: String, _effect: Dictionary[String, float], _image_path: String) -> void:
	text = _text
	effect = _effect
	image_path = _image_path

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
