extends Node2D

@export var PlayerScene : PackedScene

func spawn_player(playerId) -> void:
	var currentPlayer = PlayerScene.instantiate()
	currentPlayer.name = str(playerId)
	$Players.add_child(currentPlayer)
	var spawnNode = get_tree().root.get_node("Main/Spawn_Main")
	
	currentPlayer.global_position = spawnNode.global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
