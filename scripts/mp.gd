extends Node2D

var seat_id: int # Seat number
var group_id: int # Polotical group number
var default_shirt_color
#var affinity: Dictionary[String, float] # like social, french fries, economy
var approval: float
var present: bool = true
const threshold_vote: float = 1.5 # Threshold above which you're sure of your vote
var rng = RandomNumberGenerator.new() 

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
		sprite.self_modulate = Color(clr.x, clr.y, clr.z, 1.).lightened(0.55);
		
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rng.randomize()
	change_approval(0.0)

func change_approval(qty: float) -> void:
	approval += qty
	if qty > .4:
		$Sprites/AnimationPlayer.queue("happy")
	elif qty < -.4:
		$Sprites/AnimationPlayer.queue("unhappy")
	# Change appearance
	$Sprites/head/face_happy.visible = false
	$Sprites/head/face_neutral.visible = false
	$Sprites/head/face_unhappy.visible = false
	
	if approval >= threshold_vote:
		$Sprites/head/face_happy.visible = true
	elif approval <= -threshold_vote:
		$Sprites/head/face_unhappy.visible = true
	else:
		$Sprites/head/face_neutral.visible = true
	
	var t = min(sqrt(abs(approval)),sqrt(5))/sqrt(5)
	var other_color = happy_color
	if approval < 0:
		other_color = angry_color
	$Sprites/head.modulate = other_color*t+indifferent_color*(1-t)

func get_final_vote() -> int:
	"""Returns the final vote (+1 for approval, -1 disapproval, 0 for abstention)
	of the MP. If its approval is higher than a threshold, the vote is deterministic,
	otheriwe we add some randomness."""
	if approval >= threshold_vote:
		return 1
	elif approval <= - threshold_vote:
		return -1
	var new_approval: float = approval + rng.randfn(0,0.75)
	if approval >= threshold_vote - 0.5:
		return 1
	elif approval <= - threshold_vote + 0.5:
		return -1
	return 0

func do_final_animation(vote: int) -> void:
	$Sprites/head/face_happy.visible = false
	$Sprites/head/face_neutral.visible = false
	$Sprites/head/face_unhappy.visible = false
	var new_color = indifferent_color
	if vote == 1:
		$Sprites/AnimationPlayer.queue("happy")
		$Sprites/head/face_happy.visible = true
		new_color = happy_color
	elif vote == -1:
		$Sprites/AnimationPlayer.queue("unhappy")
		$Sprites/head/face_unhappy.visible = true
		new_color = angry_color
	else:
		$Sprites/head/face_neutral.visible = true
	$Sprites/head.modulate = new_color
	await get_tree().create_timer(0.02).timeout
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# TODO : Update MP's head after player played a card, not at every frame !
	pass
