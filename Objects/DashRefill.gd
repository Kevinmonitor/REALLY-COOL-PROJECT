extends Area2D

@onready var sprite = $AnimatedSprite2D
@onready var text = $RichTextLabel

var enabled: bool = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if enabled:
		sprite.play("glow")
		text.text = "enabled"
	else:
		sprite.play("inactive_glow")
		text.text = "disabled"
	
func _on_body_entered(body: Node2D) -> void:
	# disable if enabled
	if enabled:
		MainGame.get_singleton()._refillDash()
		_disableDashItem()
	
func _disableDashItem():
	enabled = false
	await get_tree().create_timer(2.0).timeout
	# wait for 2 seconds
	_enableDashItem()

func _enableDashItem():
	enabled = true
