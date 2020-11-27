extends KinematicBody2D


onready var player = get_parent().get_parent().get_parent().get_node("Player")
export var spawnFacing: String = "right"

var motion = Vector2(0,0)
const ENEMYSPEED = 80
var speed1 = ENEMYSPEED
const GRAVITY = 40
var fall = GRAVITY
var direction
var enemyState: String = "calm"
var max_hp = 1
var hp


func _ready():
	if spawnFacing == "right":
		direction = 1
	if spawnFacing == "left":
		direction = -1
	scale.x = -direction
	hp = max_hp

func _physics_process(delta):
	if hp > 0:
		$AnimationPlayer.play("crawl")
	else:
		queue_free()
	
	
	_fall_physics()
	motion.x = speed1 * direction
	motion = move_and_slide(motion, Vector2.UP)
	
	if $RayCast2DWall.is_colliding():
		_flip_enemy()
		print("stena")
		

	if is_on_floor():
		if !$RayCast2DPit.is_colliding():
			_flip_enemy()
			print("zeme")

func _fall_physics():
			if fall > 53:
				fall = 53
			fall += fall/10
			motion.y += fall
			if is_on_floor():
				fall = 40

func _flip_enemy():
	scale.x = -1
	direction *= -1
	
func _flip_enemy_left():
	if direction != 1:
		direction = 1
		scale.x = -1
	
	
func _flip_enemy_right():
	if direction != -1:
		direction = -1
		scale.x = -1
