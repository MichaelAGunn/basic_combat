class_name Brazier extends StaticBody3D

func _ready() -> void:
	Global.player.interact.connect(_on_player_interacts)

func _on_player_interacts() -> void:
	print("Interacted")
