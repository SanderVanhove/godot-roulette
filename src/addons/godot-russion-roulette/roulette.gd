extends Node2D


const ExplosionScene: PackedScene = preload("res://addons/godot-russion-roulette/explosion.tscn")


@onready var _trigger_audio: AudioStreamPlayer = $TriggerAudio
@onready var _shot_audio: AudioStreamPlayer = $ShotAudio


func _ready() -> void:
	print("init")
	#get_viewport().gui_focus_changed.connect(_on_focus_changed)


#func _input(event: InputEvent) -> void:
	#if not event is InputEventMouseButton or not event.pressed or event.button_index != MOUSE_BUTTON_LEFT:
		#return
#
	##_trigger_audio.global_position = get_global_mouse_position()
	#_trigger_audio.play()
	#var explosion: Node2D = ExplosionScene.instantiate()
	#explosion.position = get_global_mouse_position()
	#get_tree().root.add_child.call_deferred(explosion)
#
#
#func _on_focus_changed(node: Control):
	#
	#if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		#return
	#if randf() < 0.9999:
		#return
#
	##_shot_audio.global_position = get_global_mouse_position()
	#_shot_audio.play()
	#node.queue_free()


func _on_button_pressed() -> void:
	print("A thing")
	_shot_audio.play()
