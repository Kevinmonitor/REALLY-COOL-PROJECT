extends CanvasLayer

@export var GameScript: Node2D
@export var Lifebar: HBoxContainer
@export var Kobiko: AnimatedSprite2D

@onready var HeartTexture = preload("res://Controllers/PlatformerPlayer/LifeTexture.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _updateHPBar(health: int):
	for child in Lifebar.get_children():
		child.free()
	for i in range(health):
		var heart = HeartTexture.instantiate()
		Lifebar.add_child(heart)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
