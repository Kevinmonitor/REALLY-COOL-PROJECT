extends CharacterBody2D

class_name ObjectBitch

@export var moveSpeed = 30

@export var enemyHitbox: Area2D
@export var enemyHurtbox: Area2D

@export var animator: AnimatedSprite2D
@export var shaderAnimator: AnimationPlayer

@export var horizontalMovement: bool = true
@export var verticalMovement: bool = true

@export var enemyHP: float = 10.0

var direction : Vector2 = Vector2.RIGHT

var isDamaged: bool = false
var maxDamageTimer: float = 0.8

var isChasingPlayer: bool = false

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	
	_damageFlashHandling()
	
	if direction.x == 1:
		animator.scale.x = -1
	else:
		animator.scale.x = 1
	
	if enemyHP > 0:
		animator.play("bitchMove")
	
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
		velocity.x = direction.x * moveSpeed * delta
		move_and_slide()

func _on_hurtbox_area_body_entered(body: Node2D) -> void:
	print("collided")
	if body is TileMap or body is TileMapLayer:
		print("collided with tilemap")
		direction.x *= -1
	elif body is PlatformerController2D and !isDamaged:
		print("collided with player")

func _bitchFuckingDie():
	scale = Vector2(0.8, 0.8)
	animator.play("bitchKillYourself")
	enemyHitbox.monitoring = false
	enemyHitbox.monitorable = false
	enemyHurtbox.monitoring = false
	enemyHurtbox.monitorable = false
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
		shaderAnimator.play("takeDamage")
	else:
		shaderAnimator.stop()
		animator.material.set_shader_parameter("flash_value", 0.0)

func _on_hitbox_area_area_entered(area: Area2D) -> void:
	_takeDamage()
	pass # Replace with function body.
