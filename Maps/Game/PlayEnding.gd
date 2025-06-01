extends Area2D

var player: Node2D

func _on_body_entered(body: Node2D) -> void:
	if body is PlatformerController2D:
		player = body
		MainGame.get_singleton().fadeToEndScreen()
		body.set_physics_process(false)
		body.velocity = Vector2(0, 0)
