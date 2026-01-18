extends Node2D

var seat_id: int # Seat number
var group_id: int # Polotical group number
var default_shirt_color
#var affinity: Dictionary[String, float] # like social, french fries, economy
var approval: float
var present: bool = true

@export var happy_color = Color(0.2,0.8,0.2,1.)
@export var indifferent_color = Color(1.,1.,1.,1.)
@export var angry_color = Color(0.8,0.2,0.2,1.)
const party_colors: Array[Vector3] = [
	Vector3(255., 116., 116.)/256.,
	Vector3(59., 163., 137.)/256.,
	Vector3(253., 128., 188.)/256.,
	Vector3(243., 186., 45.)/256.,
	Vector3(160., 169., 243.)/256.,
	Vector3(163., 105., 80.)/256.
]

# Accès aux sprites de visages, pour mettre celle qu'il faut quand il faut
#@onready var face_sprite = [$Sprites/face_neutral, $Sprites/face_happy, $Sprites/face_unhappy]

# Called when the node enters the scene tree for the first time.
func setup(_seat_id: int, _group_id: int, _approval: float) -> void:
	seat_id = _seat_id
	group_id = _group_id
	approval = _approval
	default_shirt_color = party_colors[group_id]
	set_shirt_color(default_shirt_color)

func set_shirt_color(clr):
	# Apply change only on the back's shirt sprites.
	for sprite in find_children("shirt_*"):
		# Self modulate instead of modulate so the outlines stay black.
		sprite.self_modulate = Color(clr.x, clr.y, clr.z, 0.5)+Color(0.1,0.1,0.1,0.1);
		
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func change_approval(qty: float) -> void:
	approval += qty
	if qty > .2:
		$Sprites/AnimationPlayer.queue("happy")
	elif qty < .2:
		$Sprites/AnimationPlayer.queue("unhappy")
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# TODO : Update MP's head after player played a card, not at every frame !
	$Sprites/head/face_happy.visible = false
	$Sprites/head/face_neutral.visible = false
	$Sprites/head/face_unhappy.visible = false
	
	if approval > 2:
		$Sprites/head/face_happy.visible = true
	elif approval < -2:
		$Sprites/head/face_unhappy.visible = true
	else:
		$Sprites/head/face_neutral.visible = true
	
	# var t = min(sqrt(abs(approval)),3)/3
	var t = min(abs(approval),9)/9
	var other_color = happy_color
	if approval < 0:
		other_color = angry_color
	$Sprites/head.modulate = other_color*t+indifferent_color*(1-t)
