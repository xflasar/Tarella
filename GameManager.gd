extends Node

var player_node : Node = null

var Players = {}

func spawn_player(id) -> void:
	print("Spawn player called for " + str(id))
	get_tree().root.get_node("Main").spawn_player(id)
	
# Inventory
var Inventory = []
signal inventory_updated

func inventory_add_item(item):
	for i in range(Inventory.size()):
		if Inventory[i] != null and Inventory[i]["item_type"] == item["item_type"] and Inventory[i]["item_effect"] == item["item_effect"]:
			Inventory[i]["quantity"] += item["quantity"]
			inventory_updated.emit()
			return true
		elif Inventory[i] == null:
			Inventory[i] = item
			inventory_updated.emit()
			return true
		return false

func inventory_remove_item():
	inventory_updated.emit()

func inventory_increase_size():
	inventory_updated.emit()

func set_player_reference(player):
	player_node = player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Inventory.resize(30)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
