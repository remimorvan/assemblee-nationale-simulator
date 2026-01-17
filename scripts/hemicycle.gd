extends Node2D

@export var mp_scene:PackedScene # Utile pour instancier des MP

var width: int = 10
var height: int = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(width*height):
		new_mp(i)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Exemple de comment on fait un nouveau noeud au run time
func new_mp(seat: int):
	var x = seat%width
	var y = seat/width
	
	# Crée nouveau noeud MP
	var mp = mp_scene.instantiate()
	
	var seat_id = seat
	var group_id = x/2
	var belief = 0.

	mp.setup(seat_id, group_id, belief)
	
	# ajoute le mp dans l'arbre. (nécessaire pour qu'il soit dans le jeu
	add_child(mp)
	
	var viewport_size: Vector2i = get_viewport().get_visible_rect().size
	var center = Vector2(viewport_size)/2.
	
	# modify position so that it is on a grid
	mp.global_position = Vector2(center.x+float(x-width/2)*50.,center.y+float(y-height/2)*70.)
	mp.scale.x = 0.5
	mp.scale.y = 0.5
	
	# et pour suprimer :
	#mp.queue_free()
