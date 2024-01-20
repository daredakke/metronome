class_name Dial
extends CharacterBody2D

signal dial_rotated(angle_diff: float)

@onready var sprite: Sprite2D = $DialSprite

@export var rotation_amount: float = 0.01

var dragging: bool = false
var click_radius: int = 240
var click_angle: float


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if (event.position - sprite.position).length() < click_radius:
			if not dragging and event.pressed:
				dragging = true
				click_angle = sprite.position.angle_to_point(get_global_mouse_position())
		
		if dragging and not event.pressed:
			dragging = false
	
	if dragging:
		var angle = sprite.position.angle_to_point(get_global_mouse_position())
		var angle_diff = click_angle - angle
			
		if angle_diff > 0:
			sprite.rotation += rotation_amount - angle_diff
			dial_rotated.emit(angle_diff)
		elif angle_diff < 0:
			sprite.rotation -= rotation_amount + angle_diff
			dial_rotated.emit(angle_diff)
		
		click_angle = angle
