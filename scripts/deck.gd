extends Node2D

@export var card:PackedScene # Utile pour instancier des MP
var all_cards: Array[Node2D] = []

# Called when the node enters the scene tree for the first time.
func _init() -> void:
	pass
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var file = FileAccess.open("res://assets/card/cards.json", FileAccess.READ)
	var json = JSON.new()
	if json.parse(file.get_as_text()) == OK:
		var data_received = json.data
		if typeof(data_received) == TYPE_ARRAY:
			for data_card in data_received:
				var new_card = card.instantiate()
				var text: String = data_card["text"]
				var effects = data_card["effects"]
				var effects_mean: Dictionary[String, float] = {}
				var effects_std: Dictionary[String, float] = {}
				for party in effects:
					effects_mean[party] = effects[party][0]
					effects_std[party] = effects[party][1]
				var image_path = data_card["image_path"]
				new_card.setup(text, effects_mean, effects_std, image_path)
				all_cards.append(new_card)
			all_cards.shuffle()
		else:
			print("Expected array")
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in cards.json at line ", json.get_error_line())

func get_new_card() -> Node2D:
	assert (not all_cards.is_empty())
	return all_cards.pop_front()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
