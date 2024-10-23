@tool
extends EditorPlugin


const RouletteScene: PackedScene = preload("res://addons/godot-russion-roulette/roulette.tscn")


var _roulette


func _enter_tree() -> void:
	_roulette = RouletteScene.instantiate()
	_roulette.editor_base_control = get_editor_interface().get_base_control()
	add_control_to_bottom_panel(_roulette, "Roulette")
	_roulette.set_process(true)


func _exit_tree() -> void:
	remove_control_from_bottom_panel(_roulette)
	_roulette.queue_free()
