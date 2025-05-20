extends CanvasLayer

@export var GameScript: Node2D
@export var Air: HBoxContainer
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
		
func _updateAir(air: float):
	for child in Air.get_children():
		child.free()
	for i in range(air):
		var meter = HeartTexture.instantiate()
		Air.add_child(meter)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_updateAir(MainGame.get_singleton().playerPath.airTime)
	pass
