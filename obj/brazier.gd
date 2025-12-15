class_name Brazier extends StaticBody3D

signal interaction(object_name: String)
signal player_enters_radius
signal player_exits_radius

var burn_sound = preload("res://assets/sfx/burn.wav")

@onready var interact_radius = $InteractRadius
@onready var audio = $Audio

func _ready() -> void:
	Global.player.interact.connect(_on_player_interacts)
	audio.set_stream(burn_sound)

func _on_player_interacts() -> void:
	if Global.player in interact_radius.get_overlapping_bodies():
		audio.play()
		emit_signal('interaction', 'brazier')

func _on_interact_radius_body_entered(entered_body):
	if Global.player == entered_body:
		emit_signal('player_enters_radius')

func _on_interact_radius_body_exited(exited_body):
	if Global.player == exited_body:
		emit_signal('player_exits_radius')
