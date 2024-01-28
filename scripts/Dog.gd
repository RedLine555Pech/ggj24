extends Area2D

class_name Dog

@export var player: Player;
@export var home: Node2D;
@export var speed = 700.0
@export var change_direction_time = 0.5
@export var direction_time_step = 0.2

var is_charging = false;
var is_stopped = false;
var direction = 0;
# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.wait_time = change_direction_time;

func set_direction(pos):
	direction = sign((pos - global_position).x);
# Called every frame. 'delta' is the elapsed time since the previous frame.
func start_charge():
	is_charging = true
	set_direction(player.global_position)
	$Timer.start()
	
func stop_charge(total_stop = false):
	is_charging = false
	$Timer.stop()
	is_stopped = total_stop
	if $AnimatedSprite2D.animation == "run":
		$AnimatedSprite2D.play("stop")
	
func _process(delta):
	if is_stopped:
		return
	$AnimatedSprite2D.play("run")
	if !is_charging:
		set_direction(home.global_position)
	global_position += Vector2(direction * speed * delta, 0)
	if direction > 0:
		rotation_degrees = -180;
		scale = Vector2(1, -1)
	elif direction < 0:
		rotation_degrees = 0;
		scale = Vector2(1, 1)

func _on_timer_timeout():
	$Timer.wait_time = change_direction_time + randf_range(-direction_time_step, direction_time_step);
	set_direction(player.global_position)


func _on_body_entered(body):
	if body is Player and is_charging:
		$AnimatedSprite2D.play("bite")
		body.play_death()
		get_tree().call_group("dogs", "stop_charge", true)
