extends CharacterBody2D


@export var m_maxHp : float = 100
@export var m_hp : float = m_maxHp
@export var m_defence : int = 0

@export var m_speed : float = 5
var m_velocity: Vector2 = Vector2.ZERO

@onready var sprite = $Sprite2D
@onready var collShape = $CollisionShape2D
@onready var animPlayer = $AnimationPlayer


func _physics_process(delta: float) -> void:
	#die()
	pass
	
func move():
	move_and_collide(m_velocity)
	
func die():
	queue_free()
