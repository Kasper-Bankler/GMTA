extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var player_name_container=$PlayernameContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_backButton_pressed():
	var score_id = yield(SilentWolf.Scores.persist_score("Goore",1000),"sw_score_posted")
	print("Score persisted successfully: " + str(score_id))

func add_scoreboard_entry():
	var player_name_label=new_nod
	player_name_container.

func _on_backButton2_pressed():
  yield(SilentWolf.Scores.get_high_scores(), "sw_scores_received")
  print("Scores: " + str(SilentWolf.Scores.scores))
