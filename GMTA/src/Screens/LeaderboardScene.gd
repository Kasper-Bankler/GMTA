extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var pop_up=$PopupDialog
onready var text_field=$PopupDialog/VBoxContainer/TextEdit
onready var time_button=$HeaderContainer/TimeContainer/time
onready var death_button=$HeaderContainer/DeathContainer/death
onready var sheep_button=$HeaderContainer/SheepContainer/sheep
onready var coins_button=$HeaderContainer/CoinsContainer/coins

onready var player_name_container=$ScrollContainer/HBoxContainer2/player_name
onready var time_container=$ScrollContainer/HBoxContainer2/time
onready var death_container=$ScrollContainer/HBoxContainer2/death
onready var coins_container=$ScrollContainer/HBoxContainer2/coins
onready var sheep_container=$ScrollContainer/HBoxContainer2/sheep
onready var scores_container=$ScrollContainer/HBoxContainer2

onready var copied_label=$ScrollContainer/HBoxContainer2/time/Label.duplicate()
onready var copied_player_label=$ScrollContainer/HBoxContainer2/player_name/Label.duplicate()
var sort_by

var metadata
var leaderboard_data
# Called when the node enters the scene tree for the first time.
func _ready():
	metadata={
		"sheep":PlayerData.sheep_deaths,
		"time":stepify(PlayerData.time_elapsed, 0.01),
		"deaths":PlayerData.deaths
	}
	refresh_leaderboard()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pas
func refresh_leaderboard():
	clear_leaderboard()
	yield(SilentWolf.Scores.get_high_scores(0), "sw_scores_received")
	
	populate_leaderboard(SilentWolf.Scores.scores)

func new_label(text):
	var new_label=copied_label.duplicate()

	new_label.text=str(text)
	return(new_label)
	
func new_player_label(text):
	var new_label=copied_label.duplicate()
	new_label.text=str(text)
	return(new_label)
	
func populate_leaderboard(arr):
	for run in arr:
		print(run)
		for container in scores_container.get_children():
			if (container.name=="player_name"):
				container.add_child(new_player_label(run[container.name]))
			elif(container.name=="score"):
				container.add_child(new_label(run[container.name]))
			else:
				container.add_child(new_label(run.metadata[container.name]))
				
		

func _on_backButton_pressed():
	get_tree().change_scene("res://src/Screens/EndScreen.tscn")
	
		
	
func clear_leaderboard():
	for container in scores_container.get_children():

		for n in container.get_children():

			container.remove_child(n)
			n.queue_free()
#

func add_record():
	SilentWolf.Scores.persist_score(text_field.text,PlayerData.score,"main",metadata)
	

func _on_test_pressed():
	refresh_leaderboard()
	
	
func _on_backButton2_pressed():
  yield(SilentWolf.Scores.get_high_scores(), "sw_scores_received")
  print("Scores: " + str(SilentWolf.Scores.scores))


func _on_Submit_run_pressed():
	pop_up.popup()
	for row in SilentWolf.Scores.scores:
		print(row)


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






