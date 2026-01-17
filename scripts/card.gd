extends Node2D

var text: String # Text of the card
var effect_mean: Dictionary[String, float] # political group -> mean effect
var effect_std: Dictionary[String, float] # political group -> standard deviation of effect
var image_path: String # Text of the card
var rng: RandomNumberGenerator

# Called when the node enters the scene tree for the first time.
func _init(_text: String, _effect_mean: Dictionary[String, float], _effect_std: Dictionary[String, float], _image_path: String) -> void:
	text = _text
	effect_mean = _effect_mean
	effect_std = _effect_std
	image_path = _image_path
	rng = RandomNumberGenerator.new()
	rng.randomize() 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Returns the effect (delta on MP's approval's rate) of the card based on
# an MP's political group.
func get_approval_change(political_group: String) -> float:
	assert(political_group in effect_mean)
	assert(political_group in effect_std)
	return rng.randfn(effect_mean[political_group], effect_std[political_group]) 
