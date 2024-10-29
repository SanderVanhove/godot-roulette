@tool
extends Node2D


@onready var _smoke_particles: GPUParticles2D = $SmokeParticles
@onready var _explosion_flash: Sprite2D = $ExplosionFlash


func play():
	_smoke_particles.emitting = true
	
	_explosion_flash.material = _explosion_flash.material.duplicate()
	
	var tween: Tween = create_tween().set_parallel()
	tween.tween_property(_explosion_flash, "scale", _explosion_flash.scale, 0.3).from(Vector2(0.1, 0.1)).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(_explosion_flash.material, "shader_parameter/alpha_amount", 1.0, 0.3).from(0.0)
	tween.chain().tween_property(_explosion_flash.material, "shader_parameter/alpha_amount", 0.0, 0.2)
	tween.chain().tween_callback(queue_free).set_delay(0.5)
