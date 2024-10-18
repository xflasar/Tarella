extends Node

var player_node : Node = null

@onready var inventory_slot_scene = preload("res://Scenes/Inventory/InventorySlot.tscn")

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
			print("Item added", Inventory)
			return true
		elif Inventory[i] == null:
			Inventory[i] = item
			inventory_updated.emit()
			return true
	return false

func inventory_remove_item(item_type, item_effect):
	for i in range(Inventory.size()):
		if Inventory[i] != null and Inventory[i]["item_type"] == item_type and Inventory[i]["item_effect"] == item_effect:
			Inventory[i]["quantity"] -= 1
			if Inventory[i]["quantity"] <= 0:
				Inventory[i] = null
			inventory_updated.emit()
			return true
		return false

func inventory_increase_size():
	inventory_updated.emit()

func set_player_reference(player):
	player_node = player

func adjust_drop_position(position):
	var drop_radius = 100
	var nearby_items = get_tree().get_nodes_in_group("Items")

	for item in nearby_items:
		if item.global_position.distance_to(position) < drop_radius:
			var random_offset = Vector2(randf_range(-drop_radius, drop_radius), randf_range(-drop_radius, drop_radius))
			position += random_offset
			break
	return position

func drop_item(item_data, drop_position):
	var item_scene = load(item_data["item_scene"])
	var item_instance = item_scene.instantiate()
	item_instance.set_item_data(item_data)
	drop_position = adjust_drop_position(drop_position)
	item_instance.global_position = drop_position
	get_tree().current_scene.add_child(item_instance)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Inventory.resize(60)
	DisplayServer.window_set_size(Vector2(1920,1080))
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass