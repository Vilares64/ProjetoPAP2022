extends Control

func _on_NovoJogo_pressed():
	get_tree().change_scene("res://Assets/AsAventurasDeLeBaguette/Scenes/TransicaoNivel1.tscn")

func _on_Creditos_pressed():
	get_tree().change_scene("res://Assets/AsAventurasDeLeBaguette/Scenes/creditos.tscn")

func _on_Sair_pressed():
	get_tree().quit()
