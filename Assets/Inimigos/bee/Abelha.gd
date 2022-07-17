extends KinematicBody2D

#enum enemyState{walk, hit, ataque, death}
#export (enemyState) var currentState=enemyState.walk
#export (enemyState) var previousState=null

#const up = Vector2(0, -1)
var gravity = 450.0
var speed = 70
#const maxGravity = 600.0
const weaponDamage = 15

var movement = Vector2()
var moving_left
var is_attacking = false
var enemyLife=50
var is_hit = false
var dead = false
#var player_in_range = false

onready var HitBox = get_node("AttackArea/HitBox")
#onready var Vida = get_node("healthbar/vida")

#func _on_KinematicBody2D_ready():
#	Vida.value = enemyLife
#	moving_left = false if scale.x > 0 else true

func _process(delta):
	if dead:
		$AnimatedSprite.play("death");
	elif is_hit:
		movement.x=0
	else:
		if(!$DownRay.is_colliding() or $RightRay.is_colliding()):
			var collider = $RightRay.get_collider()
			if collider and collider.name == "Player":
				if $AnimatedSprite.animation != "ataque":
					$AnimatedSprite.play("ataque")
				movement.x=0
#				player_in_range = true
				is_attacking = true
			elif is_on_floor():
				moving_left = !moving_left
				scale.x = -scale.x
		elif !is_attacking:
#			player_in_range = false
			move_enemy()
	
func move_enemy():
	if $AnimatedSprite.animation != "walk":
		$AnimatedSprite.play("walk")
	movement.x = -speed if moving_left else speed
	movement.y += gravity

	movement = move_and_slide(movement, Vector2.UP)
		
func _on_AttackArea_body_entered(body):
	if body.has_method("TakeDamage"):
#		player_in_range = true
		body.TakeDamage(weaponDamage)
		
func after_hit():
	if $Player.has_method("position"):
		if $Player.player_position < position.x:
			moving_left = true
		else:
			moving_left = false

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "death":
		queue_free()
	if $AnimatedSprite.animation=="hit":
		$AnimatedSprite.play("walk")
		is_hit=false
		print("Animation_finished")
	if $AnimatedSprite.animation == "ataque":
		$AnimatedSprite.play("walk")
		is_attacking = false

func TakeDamage(damage):
	if !is_hit:
		enemyLife -= damage
		print(enemyLife)
#		Vida.value = enemyLife
		is_hit = true
		if !$AnimatedSprite.animation == "hit":
			$AnimatedSprite.play("hit")
#		movement.x = -40 if !moving_left else 40
		
	if enemyLife<=0:
		dead = true

func _on_AnimatedSprite_frame_changed():
	if($AnimatedSprite.animation == "ataque" and $AnimatedSprite.frame >= 2 and $AnimatedSprite.frame <= 3):
		HitBox.disabled = false
	else:
		HitBox.disabled = true

func _on_DamageArea_area_entered(area):
	if area.is_in_group("Sword"):
		TakeDamage(20)

#func _physics_process(delta):
#
#	var player_in_range = false
#
#	if(!$DownRay.is_colliding() or $RightRay.is_colliding()):
#		var collider = $RightRay.get_collider()
#		if collider and collider.name == "Player":
#			movement=Vector2.ZERO
#			player_in_range = true
#		elif is_on_floor():
#			player_in_range = false
#			moving_right = !moving_right
#			scale.x = -scale.x
#
#	executeState()
#	move_enemy()

#func executeState():
#	match currentState:
#		enemyState.walk:
#			if ($AnimatedSprite.animation != "walk"):
#				$AnimatedSprite.play("walk")
#			movement.x = maxSpeed if moving_right else -maxSpeed
#			pass
#		enemyState.ataque:
#			ataque()
#			pass
#		enemyState.hit:
#			if ($AnimatedSprite.animation != "hit"):
#				$AnimatedSprite.play("hit")
#				movement.x = -76 if moving_right else 76
#				movement.y = 50
#
#			if enemyLife<=0:
#				dead = true
#			pass
#
#		enemyState.death:
#			if dead:
#				if !$AnimatedSprite.animate == "death":
#					$AnimatedSprite.play("death")
#				movement.x=0
#			pass
#	changeState()
#
#func changeState():
#	previousState=currentState
#
#	match currentState:
#		enemyState.walk:
#			if is_hit:
#				currentState = enemyState.hit
#			if player_in_range:
#				currentState = enemyState.ataque
#			pass
#
#		enemyState.ataque:
#			if is_hit:
#				currentState = enemyState.hit
#			if !player_in_range:
#				currentState = enemyState.walk
#			pass
#
#		enemyState.hit:
#			if !is_hit:
#				currentState=enemyState.walk
#			if dead:
#				currentState=enemyState.death
#			pass
#
#		enemyState.death:
#			pass
#
