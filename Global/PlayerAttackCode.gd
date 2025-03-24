extends Area2D

@export var collision: CollisionShape2D
@export var sprite: AnimatedSprite2D
@export var player: PlatformerController2D
@onready var startPosition: float = 0.0

var animTime: float = 1.0

# 12fps: each frame runs for 5 frames = 0.08 seconds = 0.4 second?

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# the sprite is not visible by default.
	sprite.visible = false
	collision.disabled = true
	
	# 4 frames, slash time 0.3 seconds -> 4 frames in 0.3 seconds equals 13FPS
	# calculate the animation time.
	sprite.sprite_frames.set_animation_speed("slash", sprite.sprite_frames.get_frame_count("slash")/player.slashTime)
	startPosition = position.x

func _activateSlash():
	#print("sex")
	sprite.visible = true
	collision.disabled = false
	player.slash = true
	sprite.play("slash") # how long is this slash animation? 
	await get_tree().create_timer(player.slashTime).timeout
	sprite.visible = false
	collision.disabled = true
	player.slash = false
	
func _physics_process(delta: float) -> void:
	if player.anim.scale.x == player.animScaleLock.x:
		position.x = startPosition * 1
		sprite.scale.x = 1
	else:
		position.x = startPosition * -1
		sprite.scale.x = -1
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
