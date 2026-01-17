extends Node2D

var seat_id: int # Seat number
var group_id: int # Polotical group number
#var affinity: Dictionary[String, float] # like social, french fries, economy
var approval: float

@export var happy_color = Color(0.2,0.8,0.2,1.)
@export var indifferent_color = Color(1.,1.,1.,1.)
@export var angry_color = Color(0.8,0.2,0.2,1.)

# Accès aux sprites de visages, pour mettre celle qu'il faut quand il faut
#@onready var face_sprite = [$Sprites/face_neutral, $Sprites/face_happy, $Sprites/face_unhappy]

# Called when the node enters the scene tree for the first time.
func setup(_seat_id: int, _group_id: int, _approval: float) -> void:
	seat_id = _seat_id
	group_id = _group_id
	approval = _approval

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var t = min(abs(approval),10)/10
	var other_color = happy_color
	if approval < 0:
		other_color = angry_color
	$Sprites/head.modulate = other_color*t+indifferent_color*(1-t)
