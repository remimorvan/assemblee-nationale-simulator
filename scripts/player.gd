extends Node2D
@onready var Deck: Node2D = $"../Deck"
@onready var Journal: Control = $"../HBoxContainer/VBoxContainer/Journal"
@onready var CalendarText: Control = $"../HBoxContainer/VBoxContainer/CalendarLabel"
@onready var Hemicycle: Control = $"../HBoxContainer/Hemicycle"
@export var card: PackedScene


## Ici c'est pour mettre les actions du joueur

var hand: Array[Area2D] = [] # Cards in hand
var total_nb_card_played: int = 0
var transition_between_days: bool = false
var rng = RandomNumberGenerator.new() 
var special_event # string or null
var declared_special_event_this_turn: bool = false
const nb_days_before_vote: int = 6
var last_card_changed: int = 0

func has_special_card_in_hand() -> bool:
	for card in hand:
		if card.special_event:
			return true
	return false
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rng.randomize()
	for i in range(3):
		var card: Area2D = Deck.get_new_card(has_special_card_in_hand() or declared_special_event_this_turn)
		hand.append(card)
		add_child(card)
	print_hand()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func print_hand() -> void:
	var card_nb: int = 0;
	var viewport_size: Vector2i = $"../HBoxContainer/Hemicycle".get_size()
	for i in range(len(hand)):
		var card = hand[i]
		var card_size = card.get_node("Sprite2D").texture.get_size()
		card.position.x = viewport_size[0]/2.0 + (i - (len(hand)-1)/2.0)*(card_size[0]*1.05)
		card.position.y = 1000
		card.rotation_degrees = (i-1)*5
		card.z_index = i+100

func remove_card_from_hand(card: Area2D) -> int:
	var card_nb: int = 0
	for other_card in hand:
		if other_card == card:
			hand.pop_at(card_nb)
			break
		card_nb += 1
	remove_child(card)
	last_card_changed = card_nb
	return card_nb

func change_random_card(other_card: int) -> void:
	# Randomly choose an integer in [0,1,2] distinct from other_card
	var removed_card_pos: int = rng.randi_range(0,1)
	var arr = [0,1,2]
	arr.pop_at(other_card)
	removed_card_pos = arr[removed_card_pos]
	remove_card_from_hand(hand[removed_card_pos])
	add_card_to_hand(removed_card_pos)
	last_card_changed = removed_card_pos

func add_card_to_hand(card_pos: int) -> void:
	var new_card: Area2D = Deck.get_new_card(has_special_card_in_hand() or declared_special_event_this_turn)
	add_child(new_card)
	hand.insert(card_pos, new_card)
	print_hand()
	last_card_changed = card_pos

func put_card_back_in_hand() -> void:
	var old_card = hand.pop_at(last_card_changed)
	Deck.all_cards.insert(0, old_card)
	remove_child(old_card)
	print_hand()

func add_custom_card_to_hand(text: String, effects_mean: Dictionary[String, float], effects_std: Dictionary[String, float], image_path: String) -> void:
	var new_card = card.instantiate()
	new_card.setup(text, effects_mean, effects_std, image_path, null, null, null)
	hand.insert(last_card_changed, new_card)
	add_child(new_card)
	print_hand()

func get_current_day() -> int:
	return total_nb_card_played/3 + 1
	
func is_new_day() -> int:
	return total_nb_card_played % 3 == 0
	
func incr_nb_card_played() -> void:
	total_nb_card_played += 1
	if is_new_day():
		print("Day " + str(get_current_day()))
		transition_between_days = true
		await get_tree().create_timer(1).timeout
		transition_between_days = false
		trigger_journal()

func declare_special_event(event: String, event_description: String, event_title: String, image_path: String) -> void:
	special_event = {"id": event, "description": event_description, "title": event_title, "image": image_path}
	declared_special_event_this_turn = true
	
func trigger_special_event(event: String) -> void:
	match event:
		"indigestion":
			for mp in get_tree().get_nodes_in_group("MP"):
				var threshold: float = [0.2, 0.2, 0.2, 0.2, 0.65, 0.4][mp.group_id]
				if rng.randf() < threshold:
					mp.present = false
					mp.visible = false
		"train_strike":
			for mp in get_tree().get_nodes_in_group("MP"):
				var threshold: float = [0.5, 0.5, 0.5, 0.2, 0.1, 0.2][mp.group_id]
				if rng.randf() < threshold:
					mp.present = false
					mp.visible = false
		"deficit":
			for mp in get_tree().get_nodes_in_group("MP"):
				mp.change_approval(-1)
		"collumbus_day":
			for mp in get_tree().get_nodes_in_group("MP"):
				var threshold: float = [0.0, 0.0, 0.3, 0.6, 0.1, 0.0][mp.group_id]
				if rng.randf() < threshold:
					mp.present = false
					mp.visible = false
		"convention_citoyenne":
			put_card_back_in_hand()
			add_custom_card_to_hand(
				"Ignorer les propositions de la convention citoyenne sur le climat",
				{"lfi": -1.5, "eco": -2, "soc": -1.5, "macron": 0, "lr": 0, "rn": 0},
				{"lfi": 0.1, "eco": 0.1, "soc": 0.1, "macron": 0.2, "lr": 0.2, "rn": 0.2},
				"ecology.png"
			)
			for mp in get_tree().get_nodes_in_group("MP"):
				var delta: float = [1, 1, 1, 0, 0, 0][mp.group_id]
				mp.change_approval(delta)
		"mediapart":
			incr_nb_card_played()
		"groenland":
			for mp in get_tree().get_nodes_in_group("MP"):
				mp.change_approval(-100)
			var votes: Array[int] = [0, 0, 0];
			for mp in get_tree().get_nodes_in_group("MP"):
				votes[mp.get_final_vote()+1] += 1
				await mp.do_final_animation(mp.get_final_vote())
			print("DÉFAITE !")
		"barrage":
			put_card_back_in_hand()
			add_custom_card_to_hand(
				"Annoncer à la gauche que leur vote vous oblige.",
				{"lfi": 0.6, "eco": 0.7, "soc": 1.0, "macron": 0.5, "lr": 0.0, "rn": 0.0},
				{"lfi": 0.2, "eco": 0.2, "soc": 0.2, "macron": 0.2, "lr": 0.0, "rn": 0.0},
				"random.png"
			)
		_:
			print("TODO special event : " + event)
	
func trigger_journal() -> void:
	# Reset present
	for mp in get_tree().get_nodes_in_group("MP"):
		mp.present = true
		mp.visible = true
	Hemicycle.update_plot()
	CalendarText.bbcode_text = "[center][b][color=black][center][font_size=80]0%s[/font_size]
[font_size=30]janvier 2026"%str(get_current_day())
	if special_event:
		Journal.update(special_event["title"],special_event["description"],"")
		trigger_special_event(special_event["id"])
		special_event = null
		declared_special_event_this_turn = false
		Hemicycle.update_plot()
	if get_current_day() == nb_days_before_vote:
		var votes: Array[int] = [0, 0, 0];
		for mp in get_tree().get_nodes_in_group("MP"):
			votes[mp.get_final_vote()+1] += 1
			await mp.do_final_animation(mp.get_final_vote())
		# votes[0] : approval, votes[1] : abstention, votes[2] : disapproval
		if (votes[0] >= votes[2]):
			print("VICTOIRE !")
		else:
			print("DÉFAITE !")
