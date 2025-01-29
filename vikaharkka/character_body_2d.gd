extends CharacterBody2D


const SPEED = 150.0
var RorL := 1
# 0 = Left
# 1 = Right
var canDash := false
var Health := 3
var state := 0
#State 0 = nothing
#state 1 = attacking
#state 2 = hurt
#state 3 = death
#state 4 = movement
#state 5 = Dash
#state 8 = animation stopper
@onready var i_frames: Timer = $iFrames
@onready var dt: Timer = $dt

@onready var capsule: CollisionShape2D = $CollisionShape2D
@onready var animate: AnimatedSprite2D = $CollisionShape2D/AnimatedSprite2D
@onready var dash_cd: Timer = $DashCD
@onready var catsuit: AnimatedSprite2D = $CollisionShape2D/Catsuit


func _physics_process(delta: float) -> void:
	#kääntää spriten oikeeseen suuntaan
	if Input.is_action_pressed("ui_right") == true:
		RorL = 1
	elif Input.is_action_pressed("ui_left"):
		RorL = 0
	
	#Animation
	if RorL == 1:
		if state == 0:
			animate.play("idleR")
			catsuit.play("idleR")
		elif state == 1:
			animate.play("attackR")
			catsuit.play("attackR")
		elif state == 2:
			animate.play("hurt")
			catsuit.play("hurt")
		elif state == 3:
			animate.play("deathR")
			catsuit.play("deathR")
			state = 8
		elif state == 4:
			animate.play("walkR")
			catsuit.play("walkR")
	else:
		if state == 0:
			animate.play("idleL")
			catsuit.play("idleL")
		elif state == 1:
			animate.play("attackL")
			catsuit.play("attackL")
		elif state == 2:
			animate.play("hurt")
			catsuit.play("hurt")
		elif state == 3:
			animate.play("deathL")
			catsuit.play("deathL")
			state = 8
		elif state == 4:
			animate.play("walkL")
			catsuit.play("walkL")

	
	if Input.is_action_pressed("Attack"):
		state = 1
	elif state == 1:
		state = 0
		
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (Vector2(input_dir.x,  input_dir.y)).normalized()
	if direction and state not in  [1, 2, 3]:
		state = 4
		velocity.x = move_toward(velocity.x, direction.x*SPEED, (delta*SPEED)*10)
		velocity.y =  move_toward(velocity.y, direction.y*SPEED, (delta*SPEED)*10)
		if Input.is_action_pressed("Dash") and canDash == true:
			dash_cd.start()
			velocity.x = direction.x * SPEED * 5.0
			velocity.y = direction.y * SPEED * 5.0
			canDash = false
	else:
		velocity.x = move_toward(velocity.x, 0, 50.0)
		velocity.y = move_toward(velocity.y, 0, SPEED)
	if Input.is_anything_pressed() == false and state not in [2, 3, 5]:
		state = 0
	move_and_slide()
	


func _on_dash_cd_timeout() -> void:
	canDash = true


func _on_hurtbox_area_entered(area: Area2D) -> void:
	state = 2
	Health -= 1
	$Hurtbox/CollisionShape2D.disabled == true
	if Health > 0:
		i_frames.start()
	else:
		state = 3
		dt.start()


func _on_i_frames_timeout() -> void:
	$Hurtbox/CollisionShape2D.disabled == true
	state = 0


func _on_dt_timeout() -> void:
	get_tree().reload_current_scene()
