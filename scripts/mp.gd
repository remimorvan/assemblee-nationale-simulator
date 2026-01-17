extends Node2D

var seat_id: int # Seat number
var group_id: int # Polotical group number
var affinity: Dictionary[String, float] # like social, french fries, economy
var belief: float # [0,1]

# Called when the node enters the scene tree for the first time.
func _init(_seat_id: int, _group_id: int, _belief: float, _affinity : Dictionary[String, float]) -> void:
	seat_id = _seat_id
	group_id = _group_id
	belief = _belief
	affinity = _affinity

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
