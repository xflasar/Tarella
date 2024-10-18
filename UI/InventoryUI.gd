extends Control

@onready var grid_container = $ScrollContainer/GridContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.inventory_updated.connect(_on_inventory_updated)
	_on_inventory_updated()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_inventory_updated():
	clear_grid_container()

	# Add slots for each inventory position
	for inventory_item in GameManager.Inventory:
		var inventory_slot = GameManager.inventory_slot_scene.instantiate()
		grid_container.add_child(inventory_slot)

		if inventory_item != null:
			inventory_slot.set_item(inventory_item)
		else:
			inventory_slot.set_empty()

func clear_grid_container():
	while grid_container.get_child_count() > 0:
		var child = grid_container.get_child(0)
		grid_container.remove_child(child)
		child.queue_free()