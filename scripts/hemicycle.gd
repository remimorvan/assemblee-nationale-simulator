extends Node2D

@export var mp_scene:PackedScene # Utile pour instancier des MP

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Exemple de comment on fait un nouveau noeud au run time
func exemple_new_mp():
	
	# Crée nouveau noeud MP
	var mp = mp_scene.new()
	
	# ajoute le mp dans l'arbre. (nécessaire pour qu'il soit dans le jeu
	add_child(mp) 
	
	# et pour suprimer :
	mp.queue_free()
