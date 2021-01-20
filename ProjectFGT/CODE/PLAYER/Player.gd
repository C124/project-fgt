extends KinematicBody2D

var motion = Vector2(0,0)

var movementPhase: String
const PLAYERSPEED = 533
const ACCELERATION = 2000
var speed = 0
var desired_speed = 0

var airInertia = 0
const GRAVITY = 30
const JUMPFORCE = -1153
var fall = GRAVITY
var jumpDisrupted = false
var jumpDirecton : String
var speedBeforeJump: int

var direction: int = 1
var prevDirection: int
var isJumping: bool

var isAttacking: bool = false
var hp = 1


var snap: Vector2
var slide: float

var currentlyPlaying = null

func _physics_process(_delta):
	if hp > 0:
		
		if Input.is_action_just_pressed("LMB") && !isAttacking:
			if is_on_floor():
				motion.x = 0
				_play("lightAtt1")
				isAttacking = true
		elif Input.is_action_just_pressed("RMB") && !isAttacking:
			if is_on_floor():
				motion.x = 0
				_play("lightAtt2")
				isAttacking = true
		elif Input.is_action_pressed("right") && !isAttacking:
			_flip_player_right()
			_right_left_movement(direction, _delta)
			if !is_on_floor():
				if jumpDirecton == "left":
					jumpDisrupted = true
		elif Input.is_action_pressed("left") && !isAttacking:
			_flip_player_left()
			if !is_on_floor():
				if jumpDirecton == "right":
					jumpDisrupted = true
			_right_left_movement(direction, _delta)
		elif is_on_floor() && !isAttacking:
			speed = 0
			movementPhase = "idle"
			_play("idle")
		else:
			_jump_inertia()
			
		if Input.is_action_just_pressed("jump") && is_on_floor() && !isAttacking:
			_jump_physics()
		
		_fall_physics()
		_evaluate_snap()
		motion = move_and_slide_with_snap(motion,snap,Vector2.UP)
		motion.x = lerp(motion.x,0,slide)
	else:
		get_tree().reload_current_scene()






func _right_left_movement(index, _delta):
		_evaluate_slide()
		if(prevDirection != direction):
			speed = 0
		desired_speed = PLAYERSPEED * index
		if is_on_floor():
			if Input.is_action_pressed("sprint"):
				desired_speed *= 1.53  
				movementPhase = "sprint"
				_play("sprint")
			else:
				movementPhase = "walk"
				_play("walk")
		else:
			if jumpDisrupted:
				desired_speed *= 0.8
			else:
				match movementPhase:
					"sprint":
						desired_speed *= 1.83
					"walk":
						pass
						#so far nothing
					"idle":
						desired_speed *= 0.8
				speed = desired_speed
		if(abs(speed) > abs(desired_speed)):
			speed = desired_speed
		else:
			speed += ACCELERATION * _delta * index
		motion.x = speed

func _fall_physics():
			if fall > 53:
				fall = 53
			fall += fall/10

			if is_on_floor():
				fall = 40

			else: 
				if motion.y > JUMPFORCE/2 && motion.y < -JUMPFORCE/2 :
					_play("airTop")
				elif motion.y < JUMPFORCE/2:
					_play("airUp")
				else:
					_play("airDown")

			motion.y += fall


func _jump_physics():
	speedBeforeJump = speed
	print(speedBeforeJump)
	motion.y = JUMPFORCE
	jumpDisrupted = false
	if Input.is_action_pressed("right"):
		jumpDirecton = "right"
	elif Input.is_action_pressed("left"):
		jumpDirecton = "left"
	else:
		jumpDirecton = "middle"



func _jump_inertia():
	
	if is_on_floor():
		airInertia = 0
	else:
		if !jumpDisrupted:
			match jumpDirecton:
				"middle":
					airInertia = 0
				"right":
					airInertia = PLAYERSPEED
				"left":
					airInertia = -PLAYERSPEED
			if movementPhase == "sprint":
				airInertia *= 1.53
			motion.x = airInertia


func _flip_player_right():
	prevDirection = direction	
	if direction != 1:
		direction = 1
		scale.x = -1
	
	
func _flip_player_left():
	prevDirection = direction	
	if direction != -1:
		direction = -1
		scale.x = -1

func _play(animName):
	$AnimationPlayer.play(animName)
	

func _on_fallzone_body_entered(body):
	hp = 0

func _knock_back():
	print("kncokback")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "lightAtt1" || "lightAtt2":
		isAttacking = false

func _hit_player():
	hp -= 1

func _evaluate_snap():
	if(motion.y <= 0):
		snap = Vector2.DOWN
	else:
		snap = Vector2.DOWN*32

func _evaluate_slide():
	if(abs(speed)>750):
		slide = 0.2
	elif(abs(speed)>400):
		slide = 0.5
	else:
		slide = 0.6
