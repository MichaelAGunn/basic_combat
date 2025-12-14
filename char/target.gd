class_name Target extends StaticBody3D

@onready var body = $Body
@onready var space = $Space
@onready var anima = $AnimationPlayer
@onready var audio = $Audio

var hit_sound = preload("res://assets/sfx/strike.wav")

func _ready() -> void:
	Global.player.strike.connect(_on_player_strikes)

func _on_player_strikes(got_stricken: PhysicsBody3D) -> void:
	if self == got_stricken:
		anima.play('hit')
		audio.set_stream(hit_sound)
		audio.play()
