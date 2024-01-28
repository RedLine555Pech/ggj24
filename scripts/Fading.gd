extends Sprite2D

var tween: Tween

func fade_in(instant = false):
	if instant:
		modulate.a = 1
	else:
		if tween:
			tween.kill()
		tween = create_tween()
		modulate = Color(modulate.r, modulate.g, modulate.b, 0)
		tween.tween_property(self, "modulate", Color(modulate.r, modulate.g, modulate.b, 1), 0.2)
	
func fade_out():
	if tween:
		tween.kill()
	tween = create_tween()
	modulate = Color(modulate.r, modulate.g, modulate.b, 1)
	tween.tween_property(self, "modulate", Color(modulate.r, modulate.g, modulate.b, 0), 0.2)
