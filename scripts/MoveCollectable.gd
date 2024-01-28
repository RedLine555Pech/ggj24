extends Node2D
class_name MoveCollectable
@export var time = 0.5
@export var move_pos: Vector2 = Vector2(0, 50)
var collectable: Collectable
var tween: Tween
# Called when the node enters the scene tree for the first time.
signal picked
func _ready():
	collectable = $Collectable
	collectable.picked.connect(on_picked)
	tween = create_tween()
	tween.tween_property($Collectable, "position", move_pos, time)
	tween.tween_property($Collectable, "position", Vector2.ZERO, time)
	tween.set_loops()
	
func on_picked():
	picked.emit()
