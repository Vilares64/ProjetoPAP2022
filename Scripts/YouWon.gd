extends CanvasLayer

func _on_Menu_pressed():
	get_tree().change_scene("res://Assets/AsAventurasDeLeBaguette/Scenes/Menu.tscn")

func _on_Sair_pressed():
	get_tree().quit()
