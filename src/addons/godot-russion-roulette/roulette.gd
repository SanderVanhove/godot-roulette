@tool
extends Node


const ExplosionScene: PackedScene = preload("res://addons/godot-russion-roulette/explosion.tscn")

@onready var _node_graveyard: Container = %NodeGraveyard
@onready var _trigger_audio: AudioStreamPlayer = $Audio/TriggerAudio
@onready var _shot_audio: AudioStreamPlayer = $Audio/ShotAudio

var editor_base_control: Control

var _focussed_node: Node
var _shake_duration = 0.0
var _shake_intensity = 0.0
var _exploded_nodes: Dictionary = {}


var _chance: float = 100.0
var _sound_enabled: bool = true
var _screen_shake_enabled: bool = true


func _ready() -> void:
	set_process(false)


func _exit_tree() -> void:
	reset()


func _process(delta):
	if _shake_duration > 0:
		_shake_duration -= delta
		editor_base_control.position = Vector2(
			randf_range(-_shake_intensity, _shake_intensity), 
			randf_range(-_shake_intensity, _shake_intensity)
		)
	else:
		set_process(false)
		editor_base_control.position = Vector2.ZERO


func _input(event: InputEvent) -> void:
	if not event is InputEventMouseButton or not event.pressed or event.button_index != MOUSE_BUTTON_LEFT:
		return

	await get_tree().process_frame
	if randf() > 1.0 / _chance:
		if _sound_enabled:
			_trigger_audio.play()
		return

	var node: Control = get_window().gui_get_focus_owner()
	if node and not node.find_parent("Roulette"):
		if _sound_enabled:
			_shot_audio.play()
			
		_exploded_nodes[node] = node.get_parent()
		node.custom_minimum_size = node.size
		node.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		node.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
		node.reparent(_node_graveyard, false)
		
		shake_screen(0.1, 5.0)
		spawn_explosion()


func shake_screen(duration, intensity):
	if not _screen_shake_enabled:
		return

	_shake_duration = duration
	_shake_intensity = intensity
	set_process(true)


func spawn_explosion():
	var explosion = ExplosionScene.instantiate()
	get_viewport().add_child(explosion, true)
	explosion.position = explosion.get_global_mouse_position()
	explosion.play()
	
	
func reset():
	for node in _exploded_nodes:
		if not is_instance_valid(node) or not is_instance_valid(_exploded_nodes[node]):
			continue
		node.reparent(_exploded_nodes[node], false)


func _on_chance_spin_box_value_changed(value: float) -> void:
	_chance = value


func _on_sound_check_button_toggled(toggled_on: bool) -> void:
	_sound_enabled = toggled_on


func _on_screen_shake_check_button_toggled(toggled_on: bool) -> void:
	_screen_shake_enabled = toggled_on


func _on_button_pressed() -> void:
	reset()
