extends KinematicBody2D

enum playerState{idle, run, jump, ataque, take_hit, death}
export (playerState) var currentState=playerState.idle
export (playerState) var previousState=null

#Para andar
const up = Vector2(0, -1)
const gravity = 30.0
const maxSpeed = 250
const maxGravity = 400.0
const jumpSpeed = 600
const weaponDamage = 20

var movement = Vector2()
#vida
var is_hit = false
var is_attacking=false
var moving_right = false

var left
var right
var jump
var ataque
var dead=false

onready var HitBox = get_node("attackArea/HitBox")
onready var Player_HitBox = get_node("CollisionShape2D");

#Mecânicas do personagem
func _physics_process(delta):
	if Input.is_action_just_pressed("ataque") and is_on_floor():
		Ataque()
	elif is_attacking == false:
		HandleInput()
		executeState()
		
		movement.y += gravity
		
		if movement.y > maxGravity:
			movement.y = maxGravity
		
		movement=move_and_slide(movement, up)

func executeState():
	match currentState:
		playerState.idle:
			if !is_on_floor():
				$AnimatedSprite.play("jump")
				movement.x=0
			else:
				$AnimatedSprite.play("idle")
				Player_HitBox.position.y = 17.25
				movement.x=0
			pass
		playerState.run:
			if is_on_floor():
				Player_HitBox.position.y = 17.25
				if left:
					movement.x=-maxSpeed
					$AnimatedSprite.set_flip_h(true)
					HitBox.position.x = -75
					Player_HitBox.position.x = 10
					moving_right = false
				if right:
					movement.x=maxSpeed
					$AnimatedSprite.set_flip_h(false)
					HitBox.position.x = 0
					Player_HitBox.position.x = 3
					moving_right = true
				if($AnimatedSprite.animation!="run"):
					$AnimatedSprite.play("run")
			else:
				if left:
					movement.x=-maxSpeed
					$AnimatedSprite.set_flip_h(true)
					HitBox.position.x = -75
					Player_HitBox.position.x = 10
					moving_right = false
				elif right:
					movement.x=maxSpeed
					$AnimatedSprite.set_flip_h(false)
					HitBox.position.x = 0
					Player_HitBox.position.x = 3
					moving_right = true
				if($AnimatedSprite.animation!="jump"):
					$AnimatedSprite.play("jump")
			pass
		playerState.jump:
			if(is_on_floor()):
				movement.y=-jumpSpeed
				$AnimatedSprite.play("jump")
			if left:
				movement.x=-maxSpeed
				$AnimatedSprite.set_flip_h(true)
			elif right:
				movement.x=maxSpeed
				$AnimatedSprite.set_flip_h(false)
			else:
				movement.x=0
			pass
#		playerState.ataque:
#			if is_on_floor() and movement.x == 0:
#				Ataque()
#			pass
		playerState.take_hit:
			if($AnimatedSprite.animation!="take_hit"):
				$AnimatedSprite.play("take_hit")
			if Lives.live<=0:
				dead=true
			else:
				movement.x = 40 if !moving_right else -40
			pass
		playerState.death:
			$AnimatedSprite.play("death")
			pass
	changeState()
	
func changeState():
	previousState=currentState
	
	match currentState:
		playerState.idle:
			if(left or right):
				currentState=playerState.run
#			if ataque:
#				currentState=playerState.ataque
			if jump:
				currentState=playerState.jump
			if dead:
				currentState=playerState.death
			elif is_hit:
				currentState=playerState.take_hit
			pass
		playerState.run:
			if!(left or right):
				currentState=playerState.idle
#			if ataque:
#				currentState=playerState.ataque
			if jump:
				currentState=playerState.jump
			if dead:
				currentState=playerState.death
			elif is_hit:
				currentState=playerState.take_hit
			pass
		playerState.jump:
			if(is_on_floor()):
				currentState=playerState.idle
			if(left or right):
				currentState=playerState.run
			if dead:
				currentState=playerState.death
			elif is_hit:
				currentState=playerState.take_hit
			pass
#		playerState.ataque:
#			if(!is_attacking):
#				currentState=playerState.idle
#			if dead:
#				currentState=playerState.death
#			elif is_hit:
#				currentState=playerState.take_hit
#			pass
		playerState.take_hit:
			if !is_hit:
				currentState=playerState.idle
			if dead:
				currentState=playerState.death
			pass
		playerState.death:
			pass

func HandleInput():
	left = Input.is_action_pressed("move_left")
	right = Input.is_action_pressed("move_right")
	jump = Input.is_action_just_pressed("jump")
#	ataque = Input.is_action_just_pressed("ataque")

func Ataque():
	if $AnimatedSprite.animation != "ataque" and !is_attacking:
		$AnimatedSprite.play("ataque")
		is_attacking = true

func position():
	var player_position = position.x
	return player_position

func TakeDamage(damage):
	if !is_hit:
		is_hit = true
		Lives.live -= damage
	
	if is_attacking:
		is_attacking = false

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "death":
		OS.window_fullscreen = !OS.window_fullscreen
		get_tree().change_scene("res://Assets/AsAventurasDeLeBaguette/Scenes/GameOverScreen.tscn")
		
	if $AnimatedSprite.animation == "ataque":
		$AnimatedSprite.play("idle")
		is_attacking=false

	if $AnimatedSprite.animation=="take_hit":
		is_hit=false
		$AnimatedSprite.play("idle")

func _on_attackArea_body_entered(body):
	if body.has_method("TakeDamage"):
		body.TakeDamage(weaponDamage)


func _on_AnimatedSprite_frame_changed():
	if $AnimatedSprite.animation == "ataque" and $AnimatedSprite.frame >=3 and $AnimatedSprite.frame <=7:
		HitBox.disabled = false;
	else:
		HitBox.disabled = true;
