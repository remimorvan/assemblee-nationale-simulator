extends Node2D

@export var mp_scene:PackedScene # Utile pour instancier des MP
@export var desk_color:Color
@onready var Plot: Control = $"../VBoxContainer/Plot"
@onready var TextStats: Control = $"../VBoxContainer/TextStats"

var width: int = 19
var height: int = 13

var group_repartition: Array[int] = [
	81,
	47,
	71,
	179,
	53,
	132
]
var sum_group_repartition: int = 0 # Computed at _init()

var default_approval: Array[float] = [-3.0, -2.5, -1.5, 3.0, 1.0, -2.5]

var party_colors: PackedVector3Array = [
	Vector3(255., 116., 116.)/256.,
	Vector3(59., 163., 137.)/256.,
	Vector3(253., 128., 188.)/256.,
	Vector3(243., 186., 45.)/256.,
	Vector3(160., 169., 243.)/256.,
	Vector3(163., 105., 80.)/256.
]

var party_array: PackedInt32Array = PackedInt32Array()

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

func _init() -> void:
	for n in group_repartition:
		sum_group_repartition += n
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	party_array.resize(width*height)
	
	for i in range(width*height):
		var party = new_mp(i)
		party_array[i] = party
		
	# bars
	for i in range(height):
		# create bar for row i
		var line = Line2D.new()
		
		const bar_height = 0.15
		for j in range(width):
			var point: Vector2
			if (i % 2 == 1):
				point = cell_to_uv(float(j)+0.5, float(i) + bar_height)
			else:
				point = cell_to_uv(float(j), float(i) + bar_height)
			line.add_point(point)
			
		# last bar
		var point: Vector2
		if (i % 2 == 1):
			point = cell_to_uv(float(width)+0.5, float(i) + bar_height)
		else:
			point = cell_to_uv(float(width), float(i) + bar_height)
		line.add_point(point)

		line.default_color = desk_color
		line.width = 20.0
		line.antialiased = true
		line.begin_cap_mode = Line2D.LINE_CAP_ROUND
		line.end_cap_mode = Line2D.LINE_CAP_ROUND
		add_child(line)
		line.z_index = 2*(height-i);
	
	var mat: ShaderMaterial = $TextureRect.material
	
	mat.set_shader_parameter("party_values", party_array)
	mat.set_shader_parameter("party_colors", party_colors)
	
	update_plot()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_political_group(seat_id: int) -> int:
	var sum_seats: int = 0
	var group_id: int = -1
	while group_id < 6 and float(seat_id)/float(width*height) >= float(sum_seats)/float(sum_group_repartition):
		group_id += 1
		sum_seats += group_repartition[group_id]
	return group_id
	
func compute_group_approvals() -> Array[float]:
	var res: Array[float] = [0., 0., 0., 0., 0., 0.]
	var size: Array[int] = [0, 0, 0, 0, 0, 0]
	for mp in get_tree().get_nodes_in_group("MP"):
		var pol_group = mp.group_id
		size[pol_group] += 1
		if mp.approval >= 0:
			res[pol_group] += 1.
	for i in range(6):
		res[i] /= float(size[i])
	return res
	
# returns [a,b,c] where a is number of people with approval > 1
# c is the number of people with approval < -1 and b is the rest
func compute_number_approvals() -> Array[int]:
	var res: Array[int] = [0,0,0]
	for mp in get_tree().get_nodes_in_group("MP"):
		if mp.approval > 1:
			res[0] += 1
		elif mp.approval < -1:
			res[2] += 1
		else:
			res[1] += 1
	return res
	
func update_plot():
	var approvals: Array[float] = compute_group_approvals()
	for i in range(6):
		Plot.update_bar_value(i, approvals[i])
	TextStats.bbcode_text = "[color=black][font_size=25]Satisfais: %s\nIndécis: %s\nInsatisfaits: %s" % compute_number_approvals()

func highlight(index: int):
	party_colors[index] *= 2
	var mat: ShaderMaterial = $TextureRect.material
	mat.set_shader_parameter("party_colors", party_colors)

# Crée et place le MP 
func new_mp(seat: int) -> int:	# returns number of the political party of mp 
	var x = seat%height
	var y = seat/height
	
	# Crée nouveau noeud MP
	var mp = mp_scene.instantiate()
	
	var seat_id = seat
	var group_id: int = get_political_group(seat_id)
	var approval: float = default_approval[group_id]

	mp.setup(seat_id, group_id, approval)
	
	# ajoute le mp dans l'arbre. (nécessaire pour qu'il soit dans le jeu
	add_child(mp)
	
	mp.z_index = 2*(height-x);
	
	var viewport_size: Vector2i = get_viewport().get_visible_rect().size
	var center = Vector2(viewport_size)/2.
	
	# modify position so that it is on a grid
	if (x % 2 == 1):
		mp.position = cell_to_uv(y+1, float(x)+0.5)
	else:
		mp.position = cell_to_uv(float(y) + 0.5, float(x) + 0.5)
	#mp.position = cell_to_uv(float(y) + 0.5,float(x) + 0.5)
	mp.scale.x = 0.7
	mp.scale.y = 0.7
	
	return group_id
	# et pour suprimer :
	#mp.queue_free()
