@tool
extends EditorPlugin

const RouletteScene: PackedScene = preload("res://addons/godot-russion-roulette/roulette.tscn")
const ExplosionScene: PackedScene = preload("res://addons/godot-russion-roulette/explosion.tscn")

var _roulette: Node
var _trigger_audio: AudioStreamPlayer
var _shot_audio: AudioStreamPlayer

var _focussed_node: Node
var shake = 0.0
var shake_intensity = 0.0
var timer = 0.0
var pitch_increase: float = 0.0


func _enter_tree() -> void:
	_roulette = RouletteScene.instantiate()
	get_window().add_child(_roulette)
	_trigger_audio = _roulette.get_node("TriggerAudio")
	_shot_audio = _roulette.get_node("ShotAudio")


func _exit_tree() -> void:
	remove_control_from_bottom_panel(_roulette)
	_roulette.queue_free()
	
	
func _process(delta):
	var editor = get_editor_interface()
	
	if shake > 0:
		shake -= delta
		editor.get_base_control().position = Vector2(randf_range(-shake_intensity,shake_intensity), randf_range(-shake_intensity,shake_intensity))
	else:
		editor.get_base_control().position = Vector2.ZERO
	
	timer += delta
	if (pitch_increase > 0.0):
		pitch_increase -= delta * 2.0


func shake_screen(duration, intensity):
	if shake > 0:
		return
		
	shake = duration
	shake_intensity = intensity


func _input(event: InputEvent) -> void:
	if not event is InputEventMouseButton or not event.pressed or event.button_index != MOUSE_BUTTON_LEFT:
		return

	_trigger_audio.play()

	await get_tree().process_frame
	if randf() < 0.5:
		return

	shake_screen(0.1, 5.0)
	_shot_audio.play()
	spawn_explosion()
	if get_window().gui_get_focus_owner():
		get_window().gui_get_focus_owner().hide()


func spawn_explosion():
	var explosion = ExplosionScene.instantiate()
	get_viewport().add_child(explosion, true)
	explosion.position = explosion.get_global_mouse_position()
	
	explosion.get_node("SmokeParticles").emitting = true
	
	var explosion_flash: Sprite2D = explosion.get_node("ExplosionFlash")
	explosion_flash.material = explosion_flash.material.duplicate()
	
	var tween: Tween = create_tween().set_parallel()
	tween.tween_property(explosion_flash, "scale", explosion_flash.scale, 0.3).from(Vector2(0.1, 0.1)).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(explosion_flash.material, "shader_parameter/alpha_amount", 1.0, 0.3).from(0.0)
	tween.chain().tween_property(explosion_flash.material, "shader_parameter/alpha_amount", 0.0, 0.2)
	tween.chain().tween_callback(explosion.queue_free).set_delay(0.1)
