extends Node

signal score_updated
signal player_died
signal sheep_died
signal current_scene_updated
signal health_updated
signal time_updated

onready var background_music=$Music
onready var death_music=$DeathMusic
onready var victory_music=$VictoryMusic
onready var all_sounds=[background_music,death_music,victory_music]
var score: = 0 setget set_score
var deaths: = 0 setget set_deaths
var sheep_deaths: = 0 setget set_sheep_deaths
var current_scene: PackedScene =preload("res://src/Screens/StartMenu.tscn") setget set_current_scene
var health: = 100 setget set_health
var time_elapsed: = 0.0
var time: = ""
var playing=false
var portal_entered = false
var scene_name



func _ready():
  SilentWolf.configure({
	"api_key": "MB0UzF9f4Qa0TSfee7RXF4jhG2FS0FIY4tyawrGk",
	"game_id": "GMTA",
	"game_version": "3.5.1",
	"log_level": 0
  })

  SilentWolf.configure_scores({
	"open_scene_on_close": "res://scenes/MainPage.tscn"
  })

func _process(delta: float) -> void:
	if !playing:
		background_music.stop()
		return
	time_elapsed += delta
	time = _format_seconds(time_elapsed,true)


func _format_seconds(time : float, use_milliseconds : bool) -> String:
	var minutes := time / 60
	var seconds := fmod(time, 60)
	if not use_milliseconds:
		return "%02d:%02d" % [minutes, seconds]
	var milliseconds := fmod(time, 1) * 100
	return "%02d:%02d:%02d" % [minutes, seconds, milliseconds]

func reset() -> void:
	score = 0
	deaths = 0
	sheep_deaths = 0
	health = 0
	time_elapsed = 0


func set_score(value: int) -> void:
	score = value
	emit_signal("score_updated")

func set_deaths(value: int) -> void:
	deaths = value
	emit_signal("player_died")

func set_sheep_deaths(value: int) -> void:
	sheep_deaths = value
	emit_signal("sheep_died")
	

func stop_all_music():
	for music in all_sounds:
		music.stop()
func set_current_scene(value: PackedScene) -> void:
	var scene_name=value.instance().name
	if ("Level" in scene_name):
		if (!("Level" in current_scene.instance().name)):
			stop_all_music()
			background_music.play()
	else:
		stop_all_music()
		
		if ("Death" in scene_name):
			print("DEATH SOUNDDD")
			death_music.play()
		if ("EndScreen" in scene_name):
			victory_music.play()
	current_scene = value
	get_tree().change_scene_to(value)
	emit_signal("current_scene_updated")
	
func set_health(value: int) -> void:
	health = value
	emit_signal("health_updated")

func take_damage(damage):
	if !portal_entered:
		health -= damage
