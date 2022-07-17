extends CanvasLayer

func _on_Continuar_pressed():
	get_tree().change_scene("res://Assets/AsAventurasDeLeBaguette/Scenes/YouWon.tscn")

func _on_Menu_pressed():
	get_tree().change_scene("res://Assets/AsAventurasDeLeBaguette/Scenes/menu.tscn")

func _on_Sair_pressed():
	get_tree().quit()
