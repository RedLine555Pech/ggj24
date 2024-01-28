extends Node

@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer;
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !audio_player.playing:
		audio_player.play()
