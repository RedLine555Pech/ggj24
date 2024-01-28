extends Node2D

class_name KingMood
var progress: Progress
var mood = 10;
var allowed_tricks = 3

@onready var king_animation: AnimatedSprite2D = $AnimatedSprite2D;
@onready var tail_animation: AnimatedSprite2D = $Tail;

# Called when the node enters the scene tree for the first time.
func _ready():
	progress = $ProgressBar as Progress
	progress.becameZero.connect(moodZero)
	progress.hide();
	king_animation.play("smile")
	tail_animation.play("default")

func stop_bark():
	$AudioBark.stop()
	king_animation.play("smile")
	
func _process(delta):
	if king_animation.animation == "happy" && !$AudioLaugh.playing:
		$AudioLaugh.play()
	if king_animation.animation == "angry" &&  progress.current > 0 && !$AudioAngry.playing:
		$AudioAngry.play()
	if king_animation.animation == "angry" && progress.current == 0 && !$AudioBark.playing:
		$AudioBark.play()
	
func start_watching(mood):
	progress.show();
	progress.setValue(mood);
	allowed_tricks = 3;
	$Timer.start();
	
func reset_anim():
	$AudioLaugh.stop()
	king_animation.play("smile")	
	
func update_anim(percentage):
	if percentage >= 0.66:
		king_animation.play("smile")
	elif percentage >= 0.33:
		king_animation.play("normal")
	elif percentage != 0:
		king_animation.play("angry")

func moodZero():
	allowed_tricks = 0
	progress.hide();
	$Timer.stop()
	get_tree().call_group("dogs", "start_charge")
	king_animation.play("furious")
	$AudioFurious.play()

func picked_collectable():
	if progress.current > 0:
		var percentage = progress.changeValue(1)
		$AudioPie.play()
		update_anim(percentage)
	
func picked_all_collectable():
	allowed_tricks = 0
	progress.hide();
	$Timer.stop()
	get_tree().call_group("dogs", "stop_charge")
	king_animation.play("happy")
	
	
func made_trick():
	if allowed_tricks > 0:
		allowed_tricks -= 1
		var percentage = progress.changeValue(1)
		update_anim(percentage)

func _on_timer_timeout():
	var percentage = progress.changeValue(-1)
	update_anim(percentage)
		


func _on_animated_sprite_2d_animation_finished():
	if king_animation.animation == "furious":
		king_animation.play("angry")
