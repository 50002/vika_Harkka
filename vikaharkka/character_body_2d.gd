extends CharacterBody2D


const SPEED = 150.0
var RorL := 1
# 0 = Left
# 1 = Right
var Health := 3
var state := 0
#State 0 = nothing
#state 1 = attacking
#state 2 = hurt
#state 3 = death
#state 4 = movement

@onready var capsule: CollisionShape2D = $CollisionShape2D
@onready var animate: AnimatedSprite2D = $CollisionShape2D/AnimatedSprite2D


func _physics_process(delta: float) -> void:
	#kääntää spriten oikeeseen suuntaan
	if Input.is_action_pressed("ui_right") == true:
		RorL = 1
	elif Input.is_action_pressed("ui_left"):
		RorL = 0
	if RorL == 1:
		if state == 0:
			animate.play("idleR")
		elif state == 1:
			animate.play("attackR")
		elif state == 2:
			animate.play("hurt")
		elif state == 3:
			animate.play("deathR")
		elif state == 4:
			animate.play("walkR")
	else:
		if state == 0:
			animate.play("idleL")
		elif state == 1:
			animate.play("attackL")
		elif state == 2:
			animate.play("hurt")
		elif state == 3:
			animate.play("deathL")
		elif state == 4:
			animate.play("walkL")

	
	if Input.is_action_pressed("Attack"):
		state = 1
	elif state == 1:
		state = 0
	
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (Vector2(input_dir.x,  input_dir.y)).normalized()
	if direction and state not in  [1, 2, 3]:
		state = 4
		velocity.x = direction.x * SPEED
		velocity.y = direction.y * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
	if Input.is_anything_pressed() == false:
		state = 0
	move_and_slide()
	
