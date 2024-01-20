class_name PlayButton
extends Button


func _on_toggled(toggled_on: bool) -> void:
	text = "STOP" if toggled_on else "PLAY"
