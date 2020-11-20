extends KinematicBody2D

onready var player = get_parent().get_parent().get_node("Player")
export var spawnFacing: String = "right"

var motion = Vector2(0,0)
const ENEMYSPEED = 300
var speed1 = ENEMYSPEED
const GRAVITY = 40
var fall = GRAVITY
var direction
var enemyState: String = "calm"

func _ready():
	if spawnFacing == "right":
		direction = 1
	if spawnFacing == "left":
		direction = -1
	scale.x = direction
	
func _physics_process(delta):
	if is_on_floor():
		if enemyState == "calm":
			speed1 = ENEMYSPEED
			$AnimationPlayer.play("walk")
		elif enemyState == "charged":
			speed1 = ENEMYSPEED * 2
			$AnimationPlayer.play("sprint")
			if player.global_position.x - 70 > global_position.x:
				_flip_enemy_right()
			elif player.global_position.x + 70 < global_position.x:
				_flip_enemy_left()
				
	
	
	_fall_physics()
	#rint(speed1)
	motion.x = speed1 * direction
	motion = move_and_slide(motion, Vector2.UP)
	
	if $RayCast2DWall.is_colliding():
		_flip_enemy()
		enemyState = "calm"

	if is_on_floor():
		if !$RayCast2DPit.is_colliding():
			_flip_enemy()
			enemyState = "calm"

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
	
func _flip_enemy_right():
	if direction != 1:
		direction = 1
		scale.x = -1
	
	
func _flip_enemy_left():
	if direction != -1:
		direction = -1
		scale.x = -1


func _on_sight_body_entered(body):
	if body == player:
		enemyState = "charged"

func _on_sight_body_exited(body):
	if body == player:
		enemyState = "calm"


func _on_bodyKncokBackArea_body_entered(body):
	if body == player:
		player._knock_back()
