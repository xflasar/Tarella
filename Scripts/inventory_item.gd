@tool
extends Node2D

@export var item_type = ""
@export var item_name = ""
@export var item_texture : Texture
@export var item_effect = ""

@export var item_scene ="" # "res://Scenes/Inventory/InventoryItem.tscn"

@onready var icon_sprite = $Sprite2D

var player_in_pickup_range = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not Engine.is_editor_hint():
		icon_sprite.texture = item_texture
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		icon_sprite.texture = item_texture
	
	if player_in_pickup_range and Input.is_action_just_pressed("ui_accept"):
		pickup_item()
# Rewrite looting

func pickup_item():
	var item = {
		"quantity": 1,
		"item_type": item_type,
		"item_name": item_name,
		"item_texture": item_texture,
		"item_effect": item_effect,
		"item_scene": item_scene,
	}
	
	if GameManager.player_node:
		GameManager.inventory_add_item(item)
		queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_pickup_range = true
		body.interact_ui.visible = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_pickup_range = false
		body.interact_ui.visible = false


func set_item_data(data):
	item_type = data["item_type"]
	item_name = data["item_name"]
	item_effect = data["item_effect"]
	item_texture = data["item_texture"]
	item_scene = data["item_scene"]
