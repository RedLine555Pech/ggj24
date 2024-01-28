extends Control

var state = "menu"
# Called when the node enters the scene tree for the first time.
func _ready():
	open_menu()

func open_menu():
	$MainMenu.show();
	$CreditsMenu.hide();
	$LevelSelect.hide();
	$BG_Main.show()
	$BG_Levels.hide()
	$BG_Credits.hide()
	state = "menu"
	
func open_levels():
	$MainMenu.hide();
	$CreditsMenu.hide();
	$LevelSelect.show();
	$BG_Main.hide()
	$BG_Levels.show()
	$BG_Credits.hide()
	state = "levels"
	
func open_credits():
	$MainMenu.hide();
	$CreditsMenu.show();
	$LevelSelect.hide();
	$BG_Main.hide()
	$BG_Levels.hide()
	$BG_Credits.show()
	state = "credits"
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("escape"):
		if state == "menu":
			get_tree().quit();
		else:
			open_menu();


func _on_play_button_pressed():
	open_levels()

func _on_credit_button_pressed():
	open_credits()


func _on_back_button_2_pressed():
	open_menu()


func _on_back_button_pressed():
	open_menu()
