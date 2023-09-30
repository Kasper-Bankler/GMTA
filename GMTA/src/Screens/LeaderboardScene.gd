extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var player_name_container=$PlayernameContainer
onready var pop_up=$PopupDialog
onready var text_field=$PopupDialog/VBoxContainer/TextEdit
onready var time_button=$HeaderContainer/TimeContainer/time
onready var death_button=$HeaderContainer/DeathContainer/death
onready var sheep_button=$HeaderContainer/SheepContainer/sheep
onready var coins_button=$HeaderContainer/CoinsContainer/coins

var sort_by
var metadata
var leaderboard_data
# Called when the node enters the scene tree for the first time.
func _ready():
	metadata={
		"sheep":PlayerData.sheep_deaths,
		"time":stepify(PlayerData.time_elapsed, 0.001),
		"deaths":PlayerData.deaths
	}
	refresh_leaderboard()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pas
func refresh_leaderboard():
	yield(SilentWolf.Scores.get_high_scores(0), "sw_scores_received")

func _on_backButton_pressed():
	get_tree().change_scene("res://src/Screens/EndScreen.tscn")


#func add_scoreboard_entry():
#	var player_name_label=new_nod
#	player_name_container.



func add_record():
	SilentWolf.Scores.persist_score(text_field.text,PlayerData.score,"main",metadata)
	
	
func _on_backButton2_pressed():
  yield(SilentWolf.Scores.get_high_scores(), "sw_scores_received")
  print("Scores: " + str(SilentWolf.Scores.scores))


func _on_Submit_run_pressed():
	clear_db()
	pop_up.popup()
	for row in SilentWolf.Scores.scores:
		print(row.player_name)


func _on_PlayerNameButtonOk_pressed():
	pop_up.hide()
	add_record()

func clear_db():
	SilentWolf.Scores.wipe_leaderboard()

func _on_TextEdit_text_changed():
	print(text_field.text)


func _on_time_pressed():
	sort_by="time"


func _on_death_pressed():
	sort_by="death"
	



func _on_coins_pressed():
	sort_by="coins"
	

func _on_sheep_pressed():
	sort_by="sheep"
