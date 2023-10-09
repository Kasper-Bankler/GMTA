extends Actor



signal coinCollected
onready var death_scene = preload("res://src/Screens/DeathScreen.tscn")
onready var bullet_scene = preload("res://Objects/Bullet.tscn")
onready var rocket_scene = preload("res://Objects/homing_missile.tscn")
onready var _animated_sprite_rocket=$RocketMode
onready var _animated_sprite=$NormalMode
onready var muzzle_left = $MuzzleLeft
onready var muzzle_right = $MuzzleRight
onready var timer = $BulletTimer
onready var crosshair=$CrosshairMarker
onready var rocket_timer=$RocketTimer
onready var rocket_label=$Label
onready var rocket_label_timer=$RocketLabelTimer
onready var _animated_sprite_death=$DeathMode 
onready var hud=$Camera2D/CanvasLayer
var plPlayerExplosion := preload ("res://assets/player/PlayerExplosion.tscn")
var rocket_shot=false
#:= fastlåser datatypen til en bool
var on_ladder := false
var climb_speed = Vector2(0.0, 300.0)
var bullet=null
var rocket_mode=false
var isDead=false
var b
var death_animation_looped_counter = 0
var is_dead = false

var running=true
var bullet_delay=0.4
var can_shoot=true



	
class MyCustomSorter:
	var this_position:Vector2
	func sort_distance(a, b):
		if ((a.global_position-this_position).length()) <  ((b.global_position-this_position).length()):
			return true
		return false


var sorter=MyCustomSorter.new()

func rocket_label():
	if (is_dead):
		return
	rocket_label.show()
	
	rocket_label_timer.start(2)

func _on_RocketLabelTimer_timeout():
	
	rocket_label.hide()

var enemy_arr=null

func get_enemy_position():
	sorter.this_position=global_position
	enemy_arr=get_tree().get_nodes_in_group("enemies")
	enemy_arr.sort_custom(sorter,"sort_distance")
	if (!enemy_arr.size()==0 and !enemy_arr[0]==null):
		return(enemy_arr[0])
	else:
		return(self)


func _ready():
	
	_animated_sprite_death.hide()
	PlayerData.portal_entered = false
	rocket_label.hide()
	crosshair.hide()
	add_to_group("player")
	sorter.this_position=global_position
	enemy_arr=get_tree().get_nodes_in_group("enemies")
	enemy_arr.sort_custom(sorter,"sort_distance")
	remove_child(crosshair)
	get_parent().call_deferred("add_child",crosshair)
	timer.set_wait_time(bullet_delay)

func shoot():
	
	if rocket_mode and rocket_shot:
		$RocketReloadSound.play()
		rocket_label.show()
		return
	if (running):
		_animated_sprite.play("run_shoot")
		_animated_sprite_rocket.play("run_shoot")

	bullet=bullet_scene.instance() 
	if (rocket_mode):
		bullet=rocket_scene.instance()
		bullet.missile_target=get_enemy_position()
		rocket_shot=true
		rocket_timer.start()
	
	if (_animated_sprite.flip_h):
		bullet.facing=-1
		
		bullet.global_position = muzzle_left.global_position
	else:
		bullet.facing=1
		bullet.global_position = muzzle_right.global_position
	
	get_parent().add_child(bullet)
	can_shoot = false
	timer.start(bullet_delay)

func _process(delta):
	if PlayerData.health < 1:
		die()
	
func _physics_process(delta):
	if (is_dead):
		return
	if !rocket_shot or !rocket_mode:
		rocket_label.hide()
	if (running):
		_animated_sprite.play("run")
		_animated_sprite_rocket.play("run")
	else:
		_animated_sprite.play("idle")
		_animated_sprite_rocket.play("idle")
	
#	sætter crosshair for mode rocket
	crosshair.global_position=get_enemy_position().global_position
	
	
#	crosshair visibility kontrol
#	skift mode
	if Input.is_action_just_pressed("shift"):
		rocket_mode=not rocket_mode
		if (rocket_mode):
			crosshair.show()
			_animated_sprite.hide()
			_animated_sprite_rocket.show()
		else:
			crosshair.hide()
			_animated_sprite.show()
			_animated_sprite_rocket.hide()
		
#	skydefunktion
	if Input.is_action_just_pressed("shoot") and can_shoot:
		shoot()	

	if on_ladder:
		_velocity.y = 0
	if should_climb_ladder():
		if Input.is_action_pressed("move_up"):
			_velocity.y = -climb_speed.y
		elif Input.is_action_pressed("move_down"):
			_velocity.y = climb_speed.y
		else:
			_velocity.y = 0
		_velocity = move_and_slide(_velocity,Vector2.UP)
	else:
		var is_jump_interrupted = Input.is_action_just_released("jump") and _velocity.y < 0.0
		var direction = get_direction()
		_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
		_velocity = move_and_slide(_velocity, FLOOR_NORMAL)
	if _velocity.x < 0:
		running = true
		_animated_sprite.flip_h=true
		_animated_sprite_rocket.flip_h=true
	elif _velocity.x > 0:
		running = true
		_animated_sprite.flip_h=false
		_animated_sprite_rocket.flip_h=false
		
	else:
		running = false
		

	
func should_climb_ladder() -> bool:
	if on_ladder and (Input.is_action_pressed("move_up") or Input.is_action_pressed("move_down")):
		return true
	else:
		return false
	
func get_direction():
	return Vector2(
	Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
	-1.0 if Input.is_action_just_pressed("jump") and is_on_floor() else 1.0
	)

func calculate_move_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		speed: Vector2,
		is_jump_interrupted: bool
	):
	var out = linear_velocity
	out.x = speed.x * direction.x
	out.y += gravity * get_physics_process_delta_time()
	if direction.y == -1:
		out.y = speed.y * direction.y
	#Højden af hoppet bliver bestemt ud fra hvor lang tid jump knappen er trykket.
	if is_jump_interrupted:
		out.y = 0.0
	return out



func _on_LadderChecker_body_entered(body):
	on_ladder = true

func _on_LadderChecker_body_exited(body):
	on_ladder = false

func _on_CoinChecker_area_entered(area):
	emit_signal("coinCollected")

func _on_BulletTimer_timeout():
	can_shoot = true


func _on_RocketTimer_timeout():
	rocket_shot=false


func die():
	PlayerData.playing=false
	if (is_dead):
		return
	is_dead = true
	_velocity.x = 0
	_velocity.y = 0
	crosshair.hide()
	hud.hide()
	rocket_label.hide()
	
	PlayerData.deaths += 1
	PlayerData.score = 0
	PlayerData.health = 100
	
	_animated_sprite.hide()
	_animated_sprite_rocket.hide()
	_animated_sprite_death.show()
	_animated_sprite_death.play("Death")
	
	
	
func _on_DeathMode_animation_finished() -> void:
	death_animation_looped_counter += 1
	position.y -= 10
	if (death_animation_looped_counter >= 7):
		get_tree().change_scene_to(death_scene)


func _on_PortalChecker_area_entered(area):
	PlayerData.portal_entered = true

