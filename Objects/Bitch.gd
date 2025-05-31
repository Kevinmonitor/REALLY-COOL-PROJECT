extends CharacterBody2D

class_name ObjectBitch

@export var moveSpeed = 30

@export var enemyHitbox: Area2D
@export var enemyHurtbox: Area2D
@export var enemyDetection: Area2D

@export var animator: AnimatedSprite2D
@export var shaderAnimator: AnimationPlayer

@export var horizontalMovement: bool = true
@export var verticalMovement: bool = true

@export var enemyHP: float = 10.0

var direction : Vector2 = Vector2.RIGHT

var isDamaged: bool = false
var maxDamageTimer: float = 0.8

var isChasingPlayer: bool = false

var player: PlatformerController2D = null

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	
	_damageFlashHandling()
	
	if direction.x == 1:
		animator.scale.x = -1
	else:
		animator.scale.x = 1
	
	if enemyHP > 0:
		if !player:
			animator.play("bitchMove")
		else:
			animator.play("bitchMoveAngry")
	
func _physics_process(delta: float) -> void:
	direction.y = 0
	_moveEnemy(delta)
	_hitboxHandling()
	
func _hitboxHandling():
	if isDamaged:
		enemyHitbox.monitoring = false
		enemyHitbox.monitorable = false
	else:
		enemyHitbox.monitoring = true
		enemyHitbox.monitorable = true
	pass

func _moveEnemy(delta):
	if enemyHP > 0:
		if !player:
			velocity.x = direction.x * moveSpeed * delta
		else:
			_chasePlayer()
		move_and_slide()
		
func _chasePlayer():
	velocity = position.direction_to(player.position) * (moveSpeed/30)
	
func _on_hurtbox_area_body_entered(body: Node2D) -> void:
	print("collided")
	if body is TileMap or body is TileMapLayer:
		print("collided with tilemap")
		direction.x *= -1
	elif body is PlatformerController2D and !isDamaged:
		print("collided with player")
		body._owFuck()

func _bitchFuckingDie():
	scale = Vector2(0.8, 0.8)
	animator.play("bitchExplode")
	enemyHitbox.monitoring = false
	enemyHitbox.monitorable = false
	enemyHurtbox.monitoring = false
	enemyHurtbox.monitorable = false
	MainGame.get_singleton().updateHP(1)
	await animator.animation_finished
	queue_free()
	
func _takeDamage():
	isDamaged = true
	enemyHP -= MainGame.get_singleton().playerDamage
	if enemyHP <= 0:
		_bitchFuckingDie()
	await get_tree().create_timer(maxDamageTimer * 1.01).timeout
	isDamaged = false
		
func _damageFlashHandling():
	if isDamaged && enemyHP > 0:
		animator.play("bitchHurt")
		shaderAnimator.play("takeDamage")
	else:
		shaderAnimator.stop()
		animator.material.set_shader_parameter("flash_value", 0.0)

func _on_hitbox_area_area_entered(area: Area2D) -> void:
	if area.get_collision_layer_value(7) == true:
		_takeDamage()

func _on_detection_body_entered(body: Node2D) -> void:
	if body is PlatformerController2D:
		player = body
