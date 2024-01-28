extends TextureButton

@export var level: int

func _ready():
	if DataManager.lastCompletedLevel + 1 < level:
		disabled = true;
		modulate = Color(0.5,0.5,0.5)

func _on_pressed():
	if !disabled:
		DataManager.current_level = level;
		get_tree().change_scene_to_file("res://main.tscn")
