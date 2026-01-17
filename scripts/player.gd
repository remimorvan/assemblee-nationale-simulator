extends Node2D
@onready var Deck: Node2D = $"../Deck"

## Ici c'est pour mettre les actions du joueur

var hand: Array[Area2D] = [] # Cards in hand

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(3):
		var card: Area2D = Deck.get_new_card()
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
		card.position.x = viewport_size[0]/2 + (card_nb - (len(hand)-1)/2.0)*(card_size[0]*1.2)
		card.position.y = 1000 
		card_nb+=1
