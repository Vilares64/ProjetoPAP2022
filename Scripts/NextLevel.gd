extends Area2D

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		OS.window_fullscreen = !OS.window_fullscreen
		get_tree().change_scene("res://Assets/AsAventurasDeLeBaguette/Scenes/TransicaoNivel" + str(int(get_tree().current_scene.name) + 1) + ".tscn")

