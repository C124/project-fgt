extends KinematicBody2D


export var spawnFacing: String = "right"
onready var player = get_node("../../../Player")

var motion = Vector2(0,0)
const ENEMYSPEED = 80
var speed1 = ENEMYSPEED
const GRAVITY = 40
var fall = GRAVITY
var direction
var enemyState: String = "calm"
var max_hp = 4
var hp
var firsthit = 1


func _ready():
	if spawnFacing == "right":
		direction = 1
	if spawnFacing == "left":
		direction = -1
	scale.x = -direction
	hp = max_hp

func _physics_process(delta):
	if hp > 0:
		if hp < max_hp:
			$AnimationPlayer.play("run")
			speed1 = ENEMYSPEED + 150
			$AnimationPlayer.playback_speed = 1.85
			enemyState = "run"
		else:
			$AnimationPlayer.play("crawl")


	else:
		$AnimationPlayer.playback_speed = 1
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

func _on_hitBox_area_entered(body):
	if body.is_in_group("sword_dmg1"):
		if (player._is_attacking()):
			hp -= 1
			if firsthit == 1:
				$AnimationPlayer.play("transform")
				firsthit = 0


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "transform":
		enemyState = "run"


func _on_attackBox_body_entered(body):
	if enemyState == "run":
		if(body == player):
			player._hit_player(1)
			if player._get_HP() > 0:
				player._knock_back(direction,-1000,700)
		


func _on_sight_body_entered(body):
	if player.global_position.x - 200 > global_position.x:
		_flip_enemy_right()
	elif player.global_position.x + 200 < global_position.x:
			_flip_enemy_left()
