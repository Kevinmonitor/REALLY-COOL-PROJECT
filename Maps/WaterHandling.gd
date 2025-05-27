extends TileMapLayer

var playerCoords: Vector2
var tile: TileData

func _physics_process(delta: float) -> void:
	
	MainGame.get_singleton().playerPath.underwater = false
	# check if player is in water
	playerCoords = local_to_map(to_local(Vector2(MainGame.get_singleton().playerPath.WaterCollisionArea.global_position.x, MainGame.get_singleton().playerPath.WaterCollisionArea.global_position.y)))
	tile = get_cell_tile_data(playerCoords)
	if tile != null:
		if tile.get_custom_data("water") == true:
			MainGame.get_singleton().playerPath.underwater = true
