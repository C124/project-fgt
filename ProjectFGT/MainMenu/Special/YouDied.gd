extends Node2D


func _ready():
	pass


func _on_PlayAgainButton_button_up():
	get_tree().change_scene("res://Levels/Level1/Level1.tscn")
	pass # Replace with function body.


func _on_MainMenuButton_button_up():
	get_tree().change_scene("res://MainMenu/Main Menu.tscn")
	pass # Replace with function body.
