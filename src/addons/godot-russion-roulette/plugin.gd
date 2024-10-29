@tool
extends EditorPlugin


const RouletteScene: PackedScene = preload("res://addons/godot-russion-roulette/roulette.tscn")


var _roulette


func _enter_tree() -> void:
	if not ProjectSettings.has_setting("godot_roulette/average_clicks_to_explosion"):
		ProjectSettings.set_setting("godot_roulette/average_clicks_to_explosion", 100)
	ProjectSettings.set_initial_value("godot_roulette/average_clicks_to_explosion", 100)
	ProjectSettings.set_as_basic("godot_roulette/average_clicks_to_explosion", true)
	var property_info_avarage: Dictionary = {
		"name": "godot_roulette/average_clicks_to_explosion",
		"type": TYPE_INT,
		"hint_string": "Average amount of clicks before something explodes!"
	}
	ProjectSettings.add_property_info(property_info_avarage)
	
	if not ProjectSettings.has_setting("godot_roulette/enable_sound"):
		ProjectSettings.set_setting("godot_roulette/enable_sound", true)
	ProjectSettings.set_initial_value("godot_roulette/enable_sound", true)
	ProjectSettings.set_as_basic("godot_roulette/enable_sound", true)

	if not ProjectSettings.has_setting("godot_roulette/enable_screen_shake"):
		ProjectSettings.set_setting("godot_roulette/enable_screen_shake", true)
	ProjectSettings.set_initial_value("godot_roulette/enable_screen_shake", true)
	ProjectSettings.set_as_basic("godot_roulette/enable_screen_shake", true)
	
	if not ProjectSettings.has_setting("godot_roulette/guarantee_explosion_after_avarage_amount_of_clicks"):
		ProjectSettings.set_setting("godot_roulette/guarantee_explosion_after_avarage_amount_of_clicks", false)
	ProjectSettings.set_initial_value("godot_roulette/guarantee_explosion_after_avarage_amount_of_clicks", false)
	ProjectSettings.set_as_basic("godot_roulette/guarantee_explosion_after_avarage_amount_of_clicks", true)
	var property_info_guarantee: Dictionary = {
		"name": "godot_roulette/guarantee_explosion_after_avarage_amount_of_clicks",
		"type": TYPE_BOOL,
		"hint_string": "Will guarantee that something explodes after the avarage amount of clicks. Takes away the chance aspect and makes it more predictable."
	}
	ProjectSettings.add_property_info(property_info_guarantee)
	
	_roulette = RouletteScene.instantiate()
	_roulette.editor_base_control = get_editor_interface().get_base_control()
	add_control_to_bottom_panel(_roulette, "Graveyard")
	_roulette.set_process(true)


func _exit_tree() -> void:
	remove_control_from_bottom_panel(_roulette)
	_roulette.queue_free()
