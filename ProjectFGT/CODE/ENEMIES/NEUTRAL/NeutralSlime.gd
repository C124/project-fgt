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
var enemyStateBefore: String = "alive"

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
			speed1 = ENEMYSPEED + 275
			$AnimationPlayer.playback_speed = 2
			enemyState = "run"
		else:
			$AnimationPlayer.play("crawl")


	else:
		enemyStateBefore = "gonnaDie"
		$AnimationPlayer.playback_speed = 1
		speed1 = 0
		$AnimationPlayer.play("death")
		if enemyState == "die":
			queue_free()

	
	
	_fall_physics()
	motion.x = speed1 * direction
	motion = move_and_slide(motion, Vector2.UP)
	
	if $RayCast2DWall.is_colliding():
		if enemyStateBefore == "alive":
			_flip_enemy()
			print("stena")
			

	if is_on_floor():
		if enemyStateBefore == "alive":
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
	if anim_name == "death":
		enemyState = "die"


func _on_attackBox_body_entered(body):
	if enemyState == "run" && enemyStateBefore == "alive":
		if(body == player):
			player._hit_player(1)
			if player._get_HP() > 0:
				player._knock_back(direction,-1000,700)
		
