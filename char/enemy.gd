class_name Enemy extends CharacterBody3D

@onready var body = $Body
@onready var space = $Space
@onready var anima = $AnimationPlayer

func _ready() -> void:
	Global.player.strike.connect(_on_player_strikes)
	anima.play('idle')

func _on_player_strikes(got_stricken: PhysicsBody3D) -> void:
	if self == got_stricken:
		anima.play('hurt')

func _on_animation_player_animation_finished(anim_name):
	anima.play('idle')
