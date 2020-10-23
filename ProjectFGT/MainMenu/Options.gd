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


func _on_BackButton_button_up():
	get_tree().change_scene("res://MainMenu/Main Menu.tscn")
	pass # Replace with function body.


func _on_CreditsButton_button_up():
	get_tree().change_scene("res://MainMenu/Credits.tscn")
	pass # Replace with function body.


func _on_ControlsButton_button_up():
	get_tree().change_scene("res://MainMenu/Controls.tscn")
	pass # Replace with function body.


func _on_ScreenButton_button_up():
	get_tree().change_scene("res://MainMenu/Screen.tscn")
	pass # Replace with function body.


func _on_SoundsButton_button_up():
	get_tree().change_scene("res://MainMenu/Sounds.tscn")
	pass # Replace with function body.
