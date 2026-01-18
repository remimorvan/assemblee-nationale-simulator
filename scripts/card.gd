extends Node2D

@onready var Player: Node2D = $"../../Player"
@onready var Deck: Node2D = $"../../Deck"
@onready var Hemicycle: AspectRatioContainer = $"../../HBoxContainer/Hemicycle"

var text: String # Text of the card
var effect_mean: Dictionary[String, float] # political group -> mean effect
var effect_std: Dictionary[String, float] # political group -> standard deviation of effect
var image_path: String # Text of the card
var special_event # String or null # Name of the special effect to trigger
var special_event_title # Same
var special_event_description # Same
var rng: RandomNumberGenerator
var hovered: bool
var tween: Tween
var old_z_index = -1

var PoliticalGroup: Array[String] = ["lfi", "eco", "soc", "macron", "lr", "rn"]

# Called when the node enters the scene tree for the first time.
func _init() -> void:
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func setup(_text: String, _effect_mean: Dictionary[String, float], _effect_std: Dictionary[String, float], _image_path: String, _special_event, _special_event_title, _special_event_description) -> void:
	text = _text
	effect_mean = _effect_mean
	effect_std = _effect_std
	image_path =  "res://assets/card/illustrations/"+_image_path
	special_event = _special_event
	special_event_title = _special_event_title
	special_event_description = _special_event_description
	rng = RandomNumberGenerator.new()
	rng.randomize()
	var CardLabel = $"Label"
	CardLabel.text = text
	if ResourceLoader.exists(image_path):
		$Image.texture = load(image_path)
	else:
		print("Texture not found: " + image_path)

	
	
# Returns the effect (delta on MP's approval's rate) of the card based on
# an MP's political group.
func get_approval_change(political_group: String) -> float:
	assert(political_group in effect_mean)
	assert(political_group in effect_std)
	return rng.randfn(effect_mean[political_group], effect_std[political_group]) 

func _on_mouse_entered() -> void:
	# put in front
	old_z_index = self.z_index
	self.z_index = 1000
	
	hovered = true
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self, "scale", Vector2(1.,1.), .25)

func _on_mouse_exited() -> void:
	# restore z_index
	self.z_index = old_z_index
	
	hovered = false
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	tween.parallel().tween_property(self, "scale", Vector2(.7,.7), .25)
	

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT and not Player.transition_between_days:
		for mp in get_tree().get_nodes_in_group("MP"):
			if mp.present:
				mp.change_approval(get_approval_change(PoliticalGroup[mp.group_id]))
		if special_event:
			Player.declare_special_event(special_event, special_event_description, special_event_title, image_path)
		Player.incr_nb_card_played()
		
		Hemicycle.update_plot()
		
		# Remove card from hand
		var card_pos: int = Player.remove_card_from_hand(self)
		Player.add_card_to_hand(card_pos)
		Player.change_random_card(card_pos)
