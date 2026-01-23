extends ColorRect

@onready var player = $"../Player"

func _on_texture_button_pressed() -> void:
	player.game_pause = false
	#queue_free()
	self.visible = false
