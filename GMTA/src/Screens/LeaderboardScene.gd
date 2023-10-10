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
onready var baby_mode_button=$BabyMode
onready var submit_button=$"Submit run"
onready var copied_label=$ScrollContainer/HBoxContainer2/time/Label.duplicate()
onready var copied_player_label=$ScrollContainer/HBoxContainer2/player_name/Label.duplicate()
var sort_by="none"

var submitted=false
var metadata
var leaderboard_data
var array

class MyCustomSorter:
	var this_position:Vector2
	func time(a, b):
		if a.metadata.time<b.metadata.time:
			return true
		return false
	func death(a, b):
		if a.metadata.deaths<b.metadata.deaths:
			return true
		return false
	func sheep(a, b):
		if a.metadata.sheep<b.metadata.sheep:
			return true
		return false
		
	func coins(a, b):
		if a.score>b.score:
			return true
		return false
		
var sorter=MyCustomSorter.new()
	

func _ready():
	if PlayerData.baby_mode:
		submit_button.hide()
		baby_mode_button.show()
	else:
		baby_mode_button.hide()
		submit_button.show()
	metadata={
		"sheep":PlayerData.sheep_deaths,
		"time":stepify(PlayerData.time_elapsed, 0.01),
		"deaths":PlayerData.deaths
	}
	update_leaderboard()


func refresh_leaderboard():
	clear_leaderboard()
	populate_leaderboard(array)
	
func update_leaderboard():
	clear_leaderboard()
	player_name_container.add_child(new_player_label("Loading..."))
	yield(SilentWolf.Scores.get_high_scores(0), "sw_scores_received")
	array=SilentWolf.Scores.scores

	clear_leaderboard()
	if sort_by=="none":
		populate_leaderboard(array)
		return
	array.sort_custom(sorter,sort_by)
	populate_leaderboard(array)
	
	
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


func add_record():
	if submitted:
		$AcceptDialog.popup()
		return
	SilentWolf.Scores.persist_score(text_field.text,PlayerData.score,"main",metadata)
	submitted=true

func _on_refresh_pressed():
	update_leaderboard()


func _on_Submit_run_pressed():
	pop_up.popup()



func _on_PlayerNameButtonOk_pressed():
	pop_up.hide()
	add_record()


func clear_db_DO_NOT_USE_IF_NOOB():
	SilentWolf.Scores.wipe_leaderboard()


func sort_leaderboard(sort_method):
	if sort_by==sort_method:
		array.invert()
	else:
		sort_by=sort_method
		array.sort_custom(sorter,sort_by)
	refresh_leaderboard()


func _on_time_pressed():
	sort_leaderboard("time")


func _on_death_pressed():
	sort_leaderboard("death")


func _on_coins_pressed():
	sort_leaderboard("coins")



func _on_sheep_pressed():
	sort_leaderboard("sheep")










