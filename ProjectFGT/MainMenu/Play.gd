extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_NewGameButton_button_up():
	get_tree().change_scene("res://MainMenu/NewGameSaves.tscn")
	pass # Replace with function body.


func _on_SavesButton_button_up():
	get_tree().change_scene("res://MainMenu/LoadGameSaves.tscn")
	pass # Replace with function body.


func _on_BackButton_button_up():
	get_tree().change_scene("res://MainMenu/Main Menu.tscn")
	pass # Replace with function body.
