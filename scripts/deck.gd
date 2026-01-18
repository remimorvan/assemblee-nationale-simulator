extends Node2D

@export var card:PackedScene # Utile pour instancier des MP
@onready var Hemicycle: AspectRatioContainer = $"../HBoxContainer/Hemicycle"

var all_cards: Array[Node2D] = []
var PoliticalGroup: Array[String] = ["lfi", "eco", "soc", "macron", "lr", "rn"]

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
			var total_card_effects: float = 0.0
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
				var special_event = data_card["special_event"] if "special_event" in data_card else null
				new_card.setup(text, effects_mean, effects_std, image_path, special_event)
				all_cards.append(new_card)
				var card_mean_effect: float = 0.0
				for group_id in range(len(Hemicycle.group_repartition)):
					var group_weight: float = float(Hemicycle.group_repartition[group_id])/Hemicycle.sum_group_repartition
					card_mean_effect += group_weight * effects_mean[PoliticalGroup[group_id]]
				total_card_effects += card_mean_effect
			print("Nombre de cartes : " + str(len(all_cards)))
			print("Effet moyen des cartes : " + str(total_card_effects/len(all_cards)))
			all_cards.shuffle()
		else:
			print("Expected array")
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in cards.json at line ", json.get_error_line())

func get_new_card(ignore_special: bool) -> Node2D:
	var index: int = 0 
	while (index < len(all_cards) and ignore_special and all_cards[index].special_event):
		index += 1
	assert(index < len(all_cards))
	return all_cards.pop_at(index)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
