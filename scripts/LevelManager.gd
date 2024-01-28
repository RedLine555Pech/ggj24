extends Node2D

@export var king_mood: KingMood
@export var player: Player;
@export var win_screen: TextureRect;

@export var levels: Array[Resource]
var total_collectables = 0
@export var current_collectables = 0
var level_started = false;
var start_mood = 0;
var first_start = true
# Called when the node enters the scene tree for the first time.
func _ready():
	player.do_regards()
	load_level()

func load_level():
	$Dark.fade_in(first_start)
	first_start = false
	await get_tree().create_timer(0.2).timeout
	if DataManager.current_level > levels.size():
		await get_tree().create_timer(1.0).timeout
		win_screen.show()
		await get_tree().create_timer(5.0).timeout
		get_tree().change_scene_to_file("res://menu.tscn")
		return
	var level = levels[DataManager.current_level-1]
	for n in $LevelAnchor.get_children():
		$LevelAnchor.remove_child(n)
		n.queue_free()
	var instance = level.instantiate() as Level
	total_collectables = 0;
	current_collectables = 0;
	for child in instance.get_children():
		if child is Collectable || child is MoveCollectable:
			total_collectables += 1;
			child.picked.connect(king_mood.picked_collectable);
			child.picked.connect(picked_collectable);
	$LevelAnchor.call_deferred('add_child', instance)
	start_mood = instance.start_mood
	await get_tree().create_timer(1.0).timeout
	player.allow_control = true
	$Dark.fade_out()
	$SpotLightSprite.fade_out()

func picked_collectable():
	current_collectables += 1
	if current_collectables == total_collectables:
		king_mood.picked_all_collectable()
		$SpotLightSprite.fade_in()

func _on_spot_light_body_entered(body):
	if body is Player && current_collectables == total_collectables && level_started:
		king_mood.reset_anim()
		level_started = false;
		body.do_regards();
		DataManager.save_data()
		var tween = get_tree().create_tween()
		tween.tween_property(body, "global_position", $PlayerAnchor.global_position, 0.1)
		DataManager.current_level += 1;
		load_level()


func _on_spot_light_body_exited(body):
	if body is Player && level_started == false:
		level_started = true;
		king_mood.start_watching(start_mood)
