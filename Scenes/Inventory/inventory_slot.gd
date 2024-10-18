extends Control

@onready var slot_icon = $Inner/ItemIcon
@onready var slot_quantity_label = $Inner/ItemQuantity
@onready var details_panel = $DetailsPanel
@onready var item_name = $DetailsPanel/ItemName
@onready var item_type = $DetailsPanel/ItemType
@onready var item_effect = $DetailsPanel/ItemEffect
@onready var usage_panel = $UsagePanel

# Slot item
var slot_item = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass


func _on_item_button_mouse_entered() -> void:
	if slot_item != null:
		usage_panel.visible = false
		details_panel.visible = true
		details_panel.position = $Inner.global_position - Vector2(5, 40)

func _on_item_button_mouse_exited() -> void:
	details_panel.visible = false
	

func _on_item_button_pressed() -> void:
	if slot_item != null:
		usage_panel.visible = !usage_panel.visible
		usage_panel.position = $Inner.global_position - Vector2(5, 40)

func set_empty():
	slot_icon.texture = null
	slot_quantity_label.text = ""

# Set slot item with its values from the dictionary
func set_item(new_item):
	slot_item = new_item
	slot_icon.texture = new_item["item_texture"]
	slot_quantity_label.text = str(slot_item["quantity"])
	item_name.text = str(slot_item["item_name"])
	item_type.text = str(slot_item["item_type"])

	if slot_item["item_effect"] != "":
		item_effect.text = str("+ ", slot_item["item_effect"])
	else:
		item_effect.text = ""

func _on_drop_button_pressed():
	if slot_item != null:
		var drop_position = GameManager.player_node.global_position
		var drop_offset = Vector2(0, randf_range(5,20))
		drop_offset = drop_offset.rotated(randf_range(0, 360))
		GameManager.drop_item(slot_item, drop_position + drop_offset)
		GameManager.inventory_remove_item(slot_item["item_type"], slot_item["item_effect"])
		usage_panel.visible = false