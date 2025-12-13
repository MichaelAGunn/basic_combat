class_name Target extends StaticBody3D

@onready var body = $Body
@onready var space = $Space
@onready var anima = $AnimationPlayer

func _ready() -> void:
	Global.player.strike.connect(_on_player_strikes)

func _on_player_strikes(got_stricken: PhysicsBody3D) -> void:
	if self == got_stricken:
		anima.play('hit')
