extends Node2D

@onready var Player: Node2D = $"../../Player"
@onready var Deck: Node2D = $"../../Deck"
@onready var Hemicycle: Node2D = $"../../Hemicycle"
@onready var Plot: Control = $"../../VBoxContainer/Plot"

var text: String # Text of the card
var effect_mean: Dictionary[String, float] # political group -> mean effect
var effect_std: Dictionary[String, float] # political group -> standard deviation of effect
var image_path: String # Text of the card
var special_event # String or null # Name of the special effect to trigger
var rng: RandomNumberGenerator
var hovered: bool
var tween: Tween

var PoliticalGroup: Array[String] = ["lfi", "eco", "soc", "macron", "lr", "facho"]

# Called when the node enters the scene tree for the first time.
func _init() -> void:
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func setup(_text: String, _effect_mean: Dictionary[String, float], _effect_std: Dictionary[String, float], _image_path: String, _special_event) -> void:
	text = _text
	effect_mean = _effect_mean
	effect_std = _effect_std
	image_path = _image_path
	special_event = _special_event
	rng = RandomNumberGenerator.new()
	rng.randomize()
	var CardLabel = $"Label"
	CardLabel.text = text
	
# Returns the effect (delta on MP's approval's rate) of the card based on
# an MP's political group.
func get_approval_change(political_group: String) -> float:
	assert(political_group in effect_mean)
	assert(political_group in effect_std)
	return rng.randfn(effect_mean[political_group], effect_std[political_group]) 

func _on_mouse_entered() -> void:
	hovered = true
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self, "scale", Vector2(1.2,1.2), .25)

func _on_mouse_exited() -> void:
	hovered = false
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	tween.parallel().tween_property(self, "scale", Vector2(1.,1.), .25)
	

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT and not Player.transition_between_days:
		for mp in get_tree().get_nodes_in_group("MP"):
			mp.change_approval(get_approval_change(PoliticalGroup[mp.group_id]))
		if special_event:
			Player.declare_special_event(special_event)
		Player.incr_nb_card_played()
		
		# Update plot
		var approvals: Array[float] = Hemicycle.compute_group_approvals()
		for i in range(6):
			Plot.update_bar_value(i, approvals[i])
		
		# Remove card from hand
		var card_pos: int = Player.remove_card_from_hand(self)
		Player.add_card_to_hand(card_pos)
		Player.change_random_card(card_pos)
