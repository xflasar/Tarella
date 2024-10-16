# File: Scripts/InteractableObject.gd

extends Area2D

class_name Interactable_Object

var is_interacted = false

func interact():
	if not is_interacted:
		print("Object interacted with!")
