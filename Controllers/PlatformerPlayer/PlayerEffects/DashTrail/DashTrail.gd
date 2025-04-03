extends AnimatedSprite2D

@onready var tween = get_tree().create_tween()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	#Sets transition and ease for all following tweens
	tween.set_trans(Tween.TRANS_QUART) 
	tween.set_ease(Tween.EASE_OUT)

	#Tween to execute, 

	tween.tween_property(self, "modulate:a", 0.0, 0.3)
	
	tween.tween_callback(_onTweenEnd)

func _onTweenEnd():
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
