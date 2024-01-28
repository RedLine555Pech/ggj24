extends Control

func toggle_pause():
	get_tree().paused = !get_tree().paused;
	if get_tree().paused:
		show()
	else:
		hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("escape"):
		toggle_pause()


func _on_resume_button_pressed():
	toggle_pause()


func _on_exit_button_pressed():
	toggle_pause()
	get_tree().change_scene_to_file("res://menu.tscn")
