extends CharacterBody2D

class_name Player

@export var speed = 500.0
@export var jump_velocity = -2000.0
@export var acc = 50.0
@export var friction = 70.0
@export var king: KingMood

@onready var animationSprite: AnimatedSprite2D = $AnimationContainer/AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
@export var gravity = 90

var allow_control = false;
var is_on_pike = false
var is_salto = false;

func input() -> Vector2:
	var input_dir = Vector2.ZERO
	input_dir.x = Input.get_axis("left", "right")
	input_dir = input_dir.normalized()
	return input_dir
	
func accelerate(direction):
	velocity = velocity.move_toward(speed  * direction, acc)
	
func add_friction():
	velocity = velocity.move_toward(speed*Vector2.ZERO, friction)
	
func pike_rotation():
	if is_on_pike:
		$AnimationContainer.rotation = PI/8 * Input.get_axis("left", "right")
		
func jump():
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_velocity
			$AudioJump.play()
		elif !is_salto && !is_on_pike:
			is_salto = true;
			animationSprite.play("salto")
			king.made_trick()
			$AudioSalto.play()			
		if is_on_pike:
			velocity.y = jump_velocity
			velocity.x = Input.get_axis("left", "right") * speed
			is_on_pike = false
			$AudioJump.play()
			$AnimationContainer.rotation = 0
		
func do_regards():
	allow_control = false
	velocity = Vector2.ZERO	
	animationSprite.play("regards")
	$AudioRegards.play()
	
		
func player_movement():
	move_and_slide()
	
func play_death():
	king.stop_bark()
	velocity.x = 0
	is_salto = false;
	allow_control = false;
	animationSprite.play("death")
	$AudioBite.play()
	await get_tree().create_timer(3.0).timeout
	get_tree().change_scene_to_file("res://main.tscn")
	
func play_fall():
	velocity.x = 0
	allow_control = false;
	animationSprite.play("standup")
	await get_tree().create_timer(0.5).timeout
	allow_control = true;
	is_salto = false;
	
func play_seat():
	is_on_pike = true
	animationSprite.play("seat")
	

func _physics_process(delta):
	velocity.y += gravity
	if !allow_control:
		player_movement()
		return
	var input_direction = input()
	if input_direction.x < 0:
		var s : Vector2 = scale
		rotation_degrees = -180;
		scale = Vector2(1, -1)
	elif input_direction.x > 0:
		var s : Vector2 = scale
		rotation_degrees = 0;
		scale = Vector2(1, 1)
	if input_direction != Vector2.ZERO:
		if !is_on_pike && !is_salto:
			animationSprite.play("run")
		accelerate(input_direction)
	else:
		if !is_on_pike && !is_salto:
			animationSprite.play("idle")
		add_friction()
	#pike_rotation()
	if is_on_floor() && is_salto:
		play_fall()
	jump()
	if !is_on_pike:
		if !is_on_floor() && !is_salto:
			if velocity.y < 0:
				animationSprite.play("jump_up")
			else:
				animationSprite.play("jump_down")
		player_movement()


func _on_animated_sprite_2d_animation_finished():
	if animationSprite.animation == "regards":
		animationSprite.play("idle")
	if animationSprite.animation == "salto":
		is_salto = false
