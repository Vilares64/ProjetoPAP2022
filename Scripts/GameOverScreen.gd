extends CanvasLayer

func _on_Menu_pressed():
	get_tree().change_scene("res://Assets/AsAventurasDeLeBaguette/Scenes/Menu.tscn")

func _on_Sair_pressed():
	get_tree().quit()


func _on_NovoJogo_pressed():
	OS.window_fullscreen = !OS.window_fullscreen
	get_tree().change_scene("res://Assets/AsAventurasDeLeBaguette/Scenes/nivel1.tscn")
