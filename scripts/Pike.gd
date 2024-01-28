extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body is Player:
		body.play_seat()
		var tween = get_tree().create_tween()
		tween.tween_property(body, "global_position", $Anchor.global_position, 0.1)
