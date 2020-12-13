extends KinematicBody2D

var velocity = Vector2()
var timer = null
export var bullet_delay = 0.15
var can_shoot = true

func _ready():
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(bullet_delay)
	timer.connect("timeout",self,"on_timeout_complete")
	add_child(timer)


func _physics_process(delta):
	get_input()
	
func get_input():
	#velocity = Vector2.ZERO		
	#Input.is_mouse_button_pressed(BUTTON_LEFT) && 		
	if can_shoot:
		shoot()
		
		can_shoot = false
		
		timer.start()
		
func shoot():
	
	#spawn a projectile
	var projectile = load("res://turret/projectile.tscn")
	var bullet = projectile.instance()
	add_child(bullet)

func on_timeout_complete():
	can_shoot = true
