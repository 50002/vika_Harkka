extends Node2D

var player
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent().get_node("CharacterBody2D")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	player.get_node("CollisionShape2D").get_node("Catsuit").visible = true
	queue_free()
