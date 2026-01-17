extends Control

class_name Histogram

@export var bar_values: Array[float] = [0.3, 0.7, 0.5, 0.9, 0.4, 0.6]
@export var bar_colors: Array[Color] = [
	Color(255., 116., 116., 256.)/256.,
	Color(59., 163., 137., 256.)/256.,
	Color(253., 128., 188., 256.)/256.,
	Color(243., 186., 45., 256.)/256.,
	Color(160., 169., 243., 256.)/256.,
	Color(163., 105., 80., 256.)/256.
]
@export var bar_spacing = 10
@export var bar_width = 50
@export var hover_scale = 1.1
@export var hover_color_brightness = 1.3
@export var min_bar_height = 10

var bar_rects: Array[Rect2] = []
var hovered_index: int = -1

func _ready():
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	gui_input.connect(_on_gui_input)
	calculate_bar_positions()

func calculate_bar_positions():
	bar_rects.clear()
	var total_width = bar_width * 6 + bar_spacing * 5
	var start_x = (size.x - total_width) / 2.0
	
	for i in range(6):
		var x = start_x + i * (bar_width + bar_spacing)
		var bar_height = (bar_values[i] * size.y + min_bar_height)/(1. + min_bar_height/size.y) 
		var y = size.y - bar_height
		bar_rects.append(Rect2(x, y, bar_width, bar_height))

func _draw():
	calculate_bar_positions()
	
	# Draw bars
	for i in range(6):
		var rect = bar_rects[i]
		var color = bar_colors[i]
		
		# Apply hover effect
		if i == hovered_index:
			color = color.lightened(hover_color_brightness - 1.0)
			var scale_offset = (bar_width * (hover_scale - 1.0)) / 2.0
			rect = Rect2(rect.position.x - scale_offset, rect.position.y, 
						 rect.size.x * hover_scale, rect.size.y)
			draw_rect(rect, color)
			# Draw hover glow border
			draw_rect(rect, Color.TRANSPARENT, true, 3.0)
		else:
			draw_rect(rect, color)
		
		# Draw bar label (index)
		#var label_pos = Vector2(bar_rects[i].get_center().x - 10, size.y - 20)
		#draw_string(get_theme_font("font"), label_pos, str(i + 1), HORIZONTAL_ALIGNMENT_CENTER, -1, 12)

func _on_gui_input(event: InputEvent):
	if event is InputEventMouseMotion:
		var mouse_pos = event.position
		var new_hovered = -1
		
		for i in range(6):
			if bar_rects[i].has_point(mouse_pos):
				new_hovered = i
				break
		
		if new_hovered != hovered_index:
			hovered_index = new_hovered
			queue_redraw()
			
			if hovered_index != -1:
				_on_bar_hovered(hovered_index)
	
func _on_mouse_entered():
	pass

func _on_mouse_exited():
	if hovered_index != -1:
		hovered_index = -1
		queue_redraw()

func _on_bar_hovered(index: int):
	print("Bar %d hovered! Value: %.2f" % [index, bar_values[index]])
	# TODO: highlight the political group

func update_bar_value(index: int, new_value: float):
	if 0 <= index && index < 6:
		bar_values[index] = clamp(new_value, 0.0, 1.0)
		calculate_bar_positions()
		queue_redraw()

func _on_resized():
	calculate_bar_positions()
	queue_redraw()
