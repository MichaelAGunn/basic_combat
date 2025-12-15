class_name Brazier extends StaticBody3D

@onready var interact_radius = $InteractRadius

func _ready() -> void:
	Global.player.interact.connect(_on_player_interacts)

func _on_player_interacts() -> void:
	if Global.player in interact_radius.get_overlapping_bodies():
		print("Interacted with brazier")
