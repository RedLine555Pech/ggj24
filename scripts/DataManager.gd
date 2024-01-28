extends Node

var save_path = "user://save.data"
var current_level:int = 1;
var lastCompletedLevel:int = 0;
# Called when the node enters the scene tree for the first time.
func _ready():
	load_data()

func save_data():
	if current_level > lastCompletedLevel:
		lastCompletedLevel = current_level
		var file = FileAccess.open(save_path, FileAccess.WRITE)
		file.store_var(lastCompletedLevel);
	
func load_data():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		lastCompletedLevel = file.get_var(lastCompletedLevel)
	else:
		lastCompletedLevel = 0
