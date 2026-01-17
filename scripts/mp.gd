extends Node2D

var seat_id: int # Seat number
var group_id: int # Polotical group number
#var affinity: Dictionary[String, float] # like social, french fries, economy
var belief: float # [0,1]

# Accès aux sprites de visages, pour mettre celle qu'il faut quand il faut
#@onready var face_sprite = [$Sprites/face_neutral, $Sprites/face_happy, $Sprites/face_unhappy]

# Called when the node enters the scene tree for the first time.
func setup(_seat_id: int, _group_id: int, _belief: float) -> void:
	seat_id = _seat_id
	group_id = _group_id
	belief = _belief

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
