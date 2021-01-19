extends KinematicBody2D

export var spawnFacing: String = "right"
onready var player = get_node("../../../Player")
export var shit: int

var motion = Vector2(0,0)
const ENEMYSPEED = 100
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
	scale.x = direction
	hp = max_hp

func _physics_process(delta):
	if hp > 0:
		if is_on_floor():
			if enemyState == "calm":
				speed1 = ENEMYSPEED
				$AnimationPlayer.play("walk")
			elif enemyState == "charged":
				speed1 = ENEMYSPEED * 4
				$AnimationPlayer.play("sprint")
				if player.global_position.x - 200 > global_position.x:
					_flip_enemy_right()
				elif player.global_position.x + 200 < global_position.x:
					_flip_enemy_left()
	else:
		queue_free()
	
	
	_fall_physics()
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
		player._hit_player()
		player._knock_back()

func _on_hurtBox_area_entered(body):
	if body.is_in_group("sword_dmg1"):
		hp -= 1
