class_name Bpm
extends Control

signal bpm_changed(bpm: int)

@onready var bpm_label: Label = $BPMMargin/BPMPanel/BPMLabel

const BPM_LOWER_BOUND: int = 40
const BPM_UPPER_BOUND: int = 270

@export var bpm: float = 120:
	set(value):
		bpm = clampf(value, BPM_LOWER_BOUND, BPM_UPPER_BOUND)
		bpm_changed.emit(int(bpm))

@export var bpm_change_amount: float = 0.5


func _on_dial_rotated(angle_diff: float) -> void:
	if angle_diff < 0:
		bpm += bpm_change_amount - clampf(angle_diff, -1, 0)
	else:
		bpm -= bpm_change_amount + clampf(angle_diff, 0, 1)
	
	bpm_label.text = str(int(bpm))
