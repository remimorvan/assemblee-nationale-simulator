extends Node2D

@export var mp_scene:PackedScene # Utile pour instancier des MP

var width: int = 10
var height: int = 10

var party_colors: Array[Vector3] = [
	Vector3(255., 116., 116.)/256.,
	Vector3(59., 163., 137.)/256.,
	Vector3(253., 128., 188.)/256.,
	Vector3(243., 186., 45.)/256.,
	Vector3(160., 169., 243.)/256.,
	Vector3(163., 105., 80.)/256.
]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var mat: ShaderMaterial = $TextureRect.material

	var vec3_color_array: PackedVector3Array = PackedVector3Array()
	vec3_color_array.resize(width*height)
	
	for i in range(width*height):
		var party = new_mp(i)
		vec3_color_array[i] = party_colors[party]
		
	mat.set_shader_parameter("color_values", vec3_color_array)

# inverse of the shader code
func cell_to_uv(cellx: float, celly: float) -> Vector2:
	var cycle_center = Vector2(0.5,1.7)

	var projectedx: float = float(cellx) / float(width)
	var projectedy: float = float(celly) / float(height)
	
	var r = (projectedy + 2.) * 0.5
	var angle = ((projectedx*0.1 + 0.2) * 2. - 1.) * PI
	
	var viewport_size: Vector2i = get_viewport().get_visible_rect().size
	
	var UV = Vector2(cos(angle), sin(angle)) * r + cycle_center
	#return UV*100. + viewport_size/2.
	return Vector2(UV.x * viewport_size.x, UV.y * viewport_size.y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Crée et place le MP 
func new_mp(seat: int) -> int:	# returns number of the political party of mp 
	var x = seat%width
	var y = seat/width
	
	# Crée nouveau noeud MP
	var mp = mp_scene.instantiate()
	
	var seat_id = seat
	
	var group_id:int = floor((seat*6)/float(width*height))
	
	var belief = 0.

	mp.setup(seat_id, group_id, belief)
	
	# ajoute le mp dans l'arbre. (nécessaire pour qu'il soit dans le jeu
	add_child(mp)
	
	var viewport_size: Vector2i = get_viewport().get_visible_rect().size
	var center = Vector2(viewport_size)/2.
	
	# modify position so that it is on a grid
	if (x % 2 == 1):
		mp.global_position = cell_to_uv(y+1, x+0.5)
	else:
		mp.global_position = cell_to_uv(float(y) + 0.5, float(x) + 0.5)
	mp.scale.x = 0.7
	mp.scale.y = 0.7
	
	return group_id
	# et pour suprimer :
	#mp.queue_free()
