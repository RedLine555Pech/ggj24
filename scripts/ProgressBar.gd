extends Node2D

class_name Progress

var current: float;
var max: float;
var maxColor = Color("#e5d416")
var minColor = Color("#ff0000")

var fill_sprite: Sprite2D;
var defSize: Vector2
var tween
func _ready():
	fill_sprite = $Fill as Sprite2D;
	defSize = fill_sprite.get_rect().size;

signal becameZero
# Called when the node enters the scene tree for the first time.
func setValue(value):
	current = value;
	max = value;
	redraw(false)

func changeValue(delta):
	current =  current + delta;
	if current > max:
		current = max
	if current <= 0:
		current = 0
		becameZero.emit()
	return redraw()

func redraw(animate = true):
	if animate:
		if tween:
			tween.kill()
		var percentage = current / max;
		var r = minColor.r + (maxColor.r - minColor.r)*percentage;
		var g = minColor.g + (maxColor.g - minColor.g)*percentage;
		var b = minColor.b + (maxColor.b - minColor.b)*percentage;
		tween = create_tween()
		tween.tween_property(fill_sprite, "region_rect", Rect2(0,0,(percentage) * defSize.x, defSize.y), 0.1)
		tween.tween_property(fill_sprite, "modulate", Color(r, g, b), 0.1)
		return percentage
	else:
		fill_sprite.region_rect = Rect2(0,0,(current / max) * defSize.x, defSize.y);
		fill_sprite.modulate = maxColor
		return 1.0
