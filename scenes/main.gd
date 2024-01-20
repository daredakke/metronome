class_name Main
extends Node2D

const SECONDS_IN_MINUTE: float = 60.0

@onready var clave_high: AudioStream = preload("res://sounds/clave high.mp3")
@onready var clave_low: AudioStream = preload("res://sounds/clave low.mp3")
@onready var click_high: AudioStream = preload("res://sounds/click high.mp3")
@onready var click_low: AudioStream = preload("res://sounds/click low.mp3")
@onready var digital_high: AudioStream = preload("res://sounds/digital high.mp3")
@onready var digital_low: AudioStream = preload("res://sounds/digital low.mp3")

@onready var sfx: Dictionary = {
	"clave": {
		"high": clave_high,
		"low": clave_low
	},
	"click": {
		"high": click_high,
		"low": click_low
	},
	"digital": {
		"high": digital_high,
		"low": digital_low
	},
}

@onready var bpm_display: Bpm = %BPM
@onready var bpm_timer: Timer = %BPMTimer
@onready var sfx_player: AudioStreamPlayer = %SFXPlayer
@onready var time_sig_dropdown: OptionButton = %TimeSigDropdown
@onready var sound_dropdown: OptionButton = %SoundDropdown
@onready var led_on_sprite: Sprite2D = %LEDOnSprite

var master_bus := AudioServer.get_bus_index("Master")
var time_signatures: Dictionary = {
	"3/4": 3,
	"4/4": 4,
	"5/4": 5,
	"7/4": 7,
	"9/4": 9,
	"11/4": 11,
}

var selected_time_signature: int
var signature_index: int = 1
var selected_sfx: Dictionary
var beat: int = 0
var playing: bool = false


func _ready() -> void:
	bpm_timer.wait_time = (SECONDS_IN_MINUTE * 2) / int(bpm_display.bpm)
	
	time_sig_dropdown.clear()
	
	for signature in time_signatures.keys():
		time_sig_dropdown.add_item(signature)
	
	time_sig_dropdown.selected = signature_index
	selected_time_signature = get_selected_time_signature(signature_index)
	
	sound_dropdown.clear()
	
	for sound in sfx.keys():
		sound_dropdown.add_item(sound)
	
	selected_sfx = get_selected_sfx(0)
	
	led_on_sprite.visible = false


func _on_time_sig_dropdown_item_selected(index: int) -> void:
	selected_time_signature = get_selected_time_signature(index)
	beat = 0


func _on_sound_dropdown_item_selected(index: int) -> void:
	selected_sfx = get_selected_sfx(index)


func _on_play_button_toggled(toggled_on: bool) -> void:
	playing = toggled_on
	
	if playing:
		_on_bpm_timer_timeout()
		bpm_timer.start()
	else:
		bpm_timer.stop()
		sfx_player.stop()
		led_on_sprite.visible = false


func _on_bpm_timer_timeout() -> void:
	if beat == 0:
		sfx_player.stream = selected_sfx["low"]
	else:
		sfx_player.stream = selected_sfx["high"]
	
	sfx_player.play()
	
	led_on_sprite.visible = true
	beat += 1
	
	if beat >= selected_time_signature:
		beat = 0


func _on_bpm_changed(new_bpm: int) -> void:
	bpm_timer.wait_time = (SECONDS_IN_MINUTE * 2) / new_bpm


func get_selected_time_signature(index: int) -> int:
	var signature = time_sig_dropdown.get_item_text(index)
	
	return time_signatures[signature]


func get_selected_sfx(index: int) -> Dictionary:
	var sound = sound_dropdown.get_item_text(index)
	
	print(sfx[sound])
	return sfx[sound]


func _on_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(master_bus, linear_to_db(value))


func _on_sfx_player_finished() -> void:
	led_on_sprite.visible = false
