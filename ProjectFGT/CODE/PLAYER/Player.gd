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
var isBeingHit: bool = false
var hp = 4

var snap: Vector2
var slide: float

var currentlyPlaying = null

var lastLightAttack = 1

func _physics_process(_delta):
	if hp > 0:
		if Input.is_action_just_pressed("LMB")  && !isAttacking && !isBeingHit:
			if is_on_floor():
				_common_combat()
				_L_combat(lastLightAttack)
		if Input.is_action_just_pressed("RMB")  && !isAttacking && !isBeingHit:
			if is_on_floor():
				_common_combat()
				_R_combat()
		elif Input.is_action_pressed("right") && !isAttacking && !isBeingHit:
			_flip_player_right()
			_right_left_movement(direction, _delta)
			if !is_on_floor():
				if jumpDirecton == "left":
					jumpDisrupted = true
		elif Input.is_action_pressed("left") && !isAttacking && !isBeingHit:
			_flip_player_left()
			if !is_on_floor():
				if jumpDirecton == "right":
					jumpDisrupted = true
			_right_left_movement(direction, _delta)
		elif is_on_floor() && !isAttacking:
			speed = 0
			movementPhase = "idle"
			if isBeingHit && motion.y >= 0:
				_play("heavyFall")
			elif !isBeingHit:
				_play("idle")
		elif isBeingHit:
			_set_speed(speed)
		else:
			_jump_inertia()

		if Input.is_action_just_pressed("jump") && is_on_floor() && !isAttacking && !isBeingHit:
			_jump_physics(JUMPFORCE)
	else:
		_evaluate_death()

	_fall_physics()
	_evaluate_snap()
	motion = move_and_slide_with_snap(motion,snap,Vector2.UP)
	motion.x = lerp(motion.x,0,slide)



#COMBAT METHODS
func _L_combat(value: int):
	isAttacking = true
	if $Timer.is_stopped():
		lastLightAttack = 1
	else:
		lastLightAttack *= -1
	if lastLightAttack == 1:
		_play("lightAtt1")
	else:
		_play("lightAtt2")

func _R_combat():
	_play("heavyAttack")

func _common_combat():
	desired_speed = 0
	motion.x = 0
	speed = 0
	isAttacking = true

#MOVEMENT METHODS
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
		_set_speed(speed * direction)

func _knock_back(sourceDirection: int,height: int, strength: int):
	isBeingHit = true
	_play("hit")
	_jump_physics(height)
	print(sourceDirection)
	speed = sourceDirection * strength

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

#IN AIR METHODS (FALL, JUMP, INERTIA)
func _fall_physics():
			if fall > 53:
				fall = 53
			fall += fall/10

			if is_on_floor():
				fall = 40
			elif !isBeingHit: 
				if motion.y > JUMPFORCE/2 && motion.y < -JUMPFORCE/2 :
					_play("airTop")
				elif motion.y < JUMPFORCE/2:
					_play("airUp")
				else:
					_play("airDown")
			motion.y += fall

func _jump_physics(force: int):
	if(force == JUMPFORCE):
		speedBeforeJump = speed
		jumpDisrupted = false
		if Input.is_action_pressed("right"):
			jumpDirecton = "right"
		elif Input.is_action_pressed("left"):
			jumpDirecton = "left"
		else:
			jumpDirecton = "middle"
	motion.y = force

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

func _set_gravity(value: int):
	fall = value

#FLIP METHODS
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

#ANIMATION RELATED METHODS
func _play(animName):
	$AnimationPlayer.play(animName)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "lightAtt1" || anim_name == "lightAtt2" || anim_name == "heavyAttack":
		if anim_name != "heavyAttack":
			$Timer.start()
		isAttacking = false
	elif anim_name == "dying":
		get_tree().change_scene("res://MainMenu/Special/YouDied.tscn")
	elif anim_name == "hit":
		if !is_on_floor():
			_play("hitAir")
	elif anim_name == "heavyFall":
		isBeingHit = false

#HEALTH STATE METHODS
func _hit_player(damage: int):
	hp -= damage

func _evaluate_death():
	if is_on_floor():
		_die()

func _die():
	$AnimationPlayer.play("dying")

#OTHERS
func _on_fallzone_body_entered(body):
	get_tree().change_scene("res://MainMenu/Special/YouDied.tscn")

func _get_HP():
	return hp

func _set_speed(value: int):
	motion.x = value * direction

