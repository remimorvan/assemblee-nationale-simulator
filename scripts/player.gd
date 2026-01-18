extends Node2D
@onready var Deck: Node2D = $"../Deck"

## Ici c'est pour mettre les actions du joueur

var hand: Array[Area2D] = [] # Cards in hand
var total_nb_card_played: int = 0
var transition_between_days: bool = false
var rng = RandomNumberGenerator.new() 
var special_event # string or null
var declared_special_event_this_turn: bool = false

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
	var viewport_size: Vector2i = get_viewport().get_visible_rect().size
	for card in hand:
		var card_size = card.get_node("Sprite2D").texture.get_size()
		card.position.x = viewport_size[0]/2.0 + (card_nb - (len(hand)-1)/2.0)*(card_size[0]*1.2)
		card.position.y = 1000 
		card_nb+=1

func remove_card_from_hand(card: Area2D) -> int:
	var card_nb: int = 0
	for other_card in hand:
		if other_card == card:
			hand.pop_at(card_nb)
			break
		card_nb += 1
	remove_child(card)
	return card_nb

func change_random_card(other_card: int) -> void:
	# Randomly choose an integer in [0,1,2] distinct from other_card
	var removed_card_pos: int = rng.randi_range(0,1)
	var arr = [0,1,2]
	arr.pop_at(other_card)
	removed_card_pos = arr[removed_card_pos]
	remove_card_from_hand(hand[removed_card_pos])
	add_card_to_hand(removed_card_pos)

func add_card_to_hand(card_pos: int) -> void:
	var new_card: Area2D = Deck.get_new_card(has_special_card_in_hand() or declared_special_event_this_turn)
	add_child(new_card)
	hand.insert(card_pos, new_card)
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

func declare_special_event(event: String) -> void:
	special_event = event
	declared_special_event_this_turn = true
	
func trigger_special_event(event: String) -> void:
	if event == "indigestion":
		for mp in get_tree().get_nodes_in_group("MP"):
			var threshold: float = [0.2, 0.2, 0.2, 0.2, 0.65, 0.3][mp.group_id]
			if rng.randf() < threshold:
				mp.present = false
				mp.visible = false
	else:
		print("TODO special event : " + event)
	
func trigger_journal() -> void:
	# Reset present
	for mp in get_tree().get_nodes_in_group("MP"):
		mp.present = true
		mp.visible = true
	if special_event:
		trigger_special_event(special_event)
		special_event = null
		declared_special_event_this_turn = false
	print("TODO: JOURNAL")
