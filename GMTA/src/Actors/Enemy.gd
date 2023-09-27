extends "res://src/Actors/Actor.gd"

func _ready():
	#Physics bliver ikke udregnet før enemy er inden for playerens camera
	set_physics_process(false)
	#Enemy bevæger sig med venstre til at starte med
	_velocity.x = -speed.x

func _on_StompDetector_body_entered(body):
	#Denne funktion står for at dræbe fjenden ved kollision
	
	#Checker spillerens position i forhold til fjenden
	if body.global_position.y > get_node("StompDetector").global_position.y:
		return
		
	get_node("CollisionShape2D").disabled = true
	queue_free()

func _physics_process(delta):
	_velocity.y += gravity * delta
	if is_on_wall():
		_velocity.x *= -1.0
	_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y
