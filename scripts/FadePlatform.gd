extends StaticBody2D

var is_triggered = false;
var tween
# Called when the node enters the scene tree for the first time.
func trigger():
	is_triggered = true;
	await get_tree().create_timer(0.7).timeout
	$CollisionShape2D.disabled = true;
	$Area2D/CollisionShape2D.disabled = true;
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property($Left, "rotation_degrees", 90, 0.1)
	tween.tween_property($Right, "rotation_degrees", -90, 0.1)
	tween.play()
	await get_tree().create_timer(2.0).timeout
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property($Left, "rotation_degrees", 0, 0.1)
	tween.tween_property($Right, "rotation_degrees", 0, 0.1)
	tween.play()
	is_triggered = false;
	$CollisionShape2D.disabled = false;
	$Area2D/CollisionShape2D.disabled = false;



func _on_area_2d_body_entered(body):
	if body is Player && !is_triggered:
		trigger()
