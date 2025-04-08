extends CharacterBody2D

@export var move_speed : float = 50;
@export var animator : AnimatedSprite2D;
var is_game_over: bool = false

@export var bullet_scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:	
	if not is_game_over:
		velocity = Input.get_vector("left","right","up","down")*move_speed;
		if (velocity == Vector2.ZERO):
			animator.play("idle")
		else:
			animator.play("run")
			
		move_and_slide();

func _process(delta: float) -> void:
	if velocity != Vector2.ZERO or is_game_over:
		$running.stop()
	elif not $running.playing:
		$running.play()

func game_over():
	if not is_game_over:
		is_game_over = true
		animator.play("gameover")
		
		get_tree().current_scene.show_game_over()
		$GameOver.play()
		$RestartTimer.start()


func on_fire() -> void:
	if velocity != Vector2.ZERO or is_game_over:
		return
	
	$fire.play()
	
	var bullet_note = bullet_scene.instantiate()
	bullet_note.position = position + Vector2(6,6)
	get_tree().current_scene.add_child(bullet_note)
	pass # Replace with function body.


func reload_scene() -> void:
		get_tree().reload_current_scene()
		pass # Replace with function body.
