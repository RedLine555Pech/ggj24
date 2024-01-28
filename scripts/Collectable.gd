extends Area2D

class_name Collectable
signal picked;
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("swing")
	$SpriteReverse.hide()
	
func _on_body_entered(body):
	if body is Player && body.allow_control:
		picked.emit()
		#get_parent().remove_child(self)
		#body.add_child(self);
		#position = to_local(global_position)
		#$Sprite2D.hide()
		#$SpriteReverse.show()
		#var tween = get_tree().create_tween()
		#tween.tween_property(self, "position", Vector2(0,-64), 0.2)
		#await get_tree().create_timer(0.2).timeout
		queue_free()
