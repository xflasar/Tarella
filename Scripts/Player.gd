extends "./EntityBase.gd"
class_name Player

@onready var interact_ui = get_tree().root.get_node("Main/GlobalUI").get_node("ItemPickupUI")
@onready var inventory_ui = get_tree().root.get_node("Main/GlobalUI").get_node("InventoryUI")
@onready var ingameMenu_ui = get_tree().root.get_node("Main/GlobalUI").get_node("InGameMenu")

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())

func _ready() -> void:
	GameManager.set_player_reference(self)
	set_multiplayer_authority(name.to_int())
	pass

# Function to handle movement based on input
func _physics_process(delta: float) -> void:
	if not is_multiplayer_authority():
		m_velocity = Vector2.ZERO
		
		# Movement controls (WSAD or arrow keys)
		if Input.is_action_pressed("ui_right"):
			m_velocity.x += 1
		elif Input.is_action_pressed("ui_left"):
			m_velocity.x -= 1
		elif Input.is_action_pressed("ui_down"):
			m_velocity.y += 1
			$AnimationPlayer.play("Walk_Down")
		elif Input.is_action_pressed("ui_up"):
			m_velocity.y -= 1
		else:
			$AnimationPlayer.play("Idle")

		# Normalize the velocity vector to avoid faster diagonal movement
		if m_velocity.length() > 0:
			m_velocity = m_velocity.normalized() * m_speed

		# Move the player using KinematicBody2D move_and_slide
		move()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_inventory"):
		inventory_ui.visible = !inventory_ui.visible
		#get_tree().paused = !get_tree().paused # This is for pausing whole tree of nodes that can be paused by Process mode
	elif Input.is_action_just_pressed("ui_menu"):
		ingameMenu_ui.ingameMenuUI_change_state()
		get_tree().paused = !get_tree().paused
