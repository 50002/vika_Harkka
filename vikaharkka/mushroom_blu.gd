extends CharacterBody2D

var speed = 60
var player_chase = false
var player
var attack = false
var health = 5
var state = 0



@onready var atk: Timer = $attack
@onready var hitbox: CollisionShape2D = $CollisionShape2D/Hitboks/CollisionShape2D

func _ready() -> void:
	player = get_parent().get_node("CharacterBody2D")
	
func _physics_process(delta: float) -> void:
	
		if player_chase:
			if state == 0:
				position.x += (player.position.x - position.x)/speed
				position.y += (player.position.y - position.y)/speed
			else:
				position.x -= (player.position.x - position.x)/speed
				position.y -= (player.position.y - position.y)/speed
			$CollisionShape2D/AnimatedSprite2D.play("MOV")
		
			if(player.position.x - position.x) < 0:
				$CollisionShape2D.scale = Vector2(-1.0, 1.0)
			else:
				$CollisionShape2D.scale = Vector2(1.0, 1.0)
			
		elif attack == true:
			if $CollisionShape2D/AnimatedSprite2D.get_frame() in [2, 3, 4]:
				hitbox.disabled = false
			else:
				hitbox.disabled = true
			
		else:
			$CollisionShape2D/AnimatedSprite2D.play("MOV")
	



func _on_sight_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true


func _on_sight_body_exited(body: Node2D) -> void:
	
	player_chase = false




func _on_hit_detect_body_entered(body: Node2D) -> void:
	atk.start()
	player_chase = false
	attack = true
	$CollisionShape2D/AnimatedSprite2D.play("ATK")
	state = 1


func _on_attack_timeout() -> void:
	attack = false
	player_chase = true
	state = 0
