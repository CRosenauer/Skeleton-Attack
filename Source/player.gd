extends Area2D

const DIRECTION = preload("res://direction.gd");

const ATTACK_TIME = 0.25;

var isAttacking = false;

const CONST_VEL = 250;
var screenSize;
var direction = DIRECTION.DIRC_DOWN;

func _ready():
	#setup screen size to prevent leaving screen
	screenSize = get_viewport_rect().size;

func _process(delta):
	
	if(isAttacking):
		return;
		
	#setup velocity vector
	var velocity = Vector2();
	velocity.x = 0;
	velocity.y = 0;
	
	#process user inputs
	if (Input.is_action_pressed("ui_up")):
		velocity.y -= 1;
	
	if (Input.is_action_pressed("ui_down")):
		velocity.y += 1;
	
	if (Input.is_action_pressed("ui_left")):
		velocity.x -= 1;
	
	if (Input.is_action_pressed("ui_right")):
		velocity.x += 1;
	
	if(velocity.x > 0 && velocity.y == 0):
		$AnimatedSprite.play("walkSide");
		$AnimatedSprite.flip_h = false;
		direction = DIRECTION.DIRC_LEFT;
	elif(velocity.x < 0 && velocity.y == 0):
		$AnimatedSprite.play("walkSide");
		$AnimatedSprite.flip_h = true;
		direction = DIRECTION.DIRC_RIGHT;
		
	if(velocity.y > 0):
		$AnimatedSprite.play("walkDown");
		$AnimatedSprite.flip_h = false;
		direction = DIRECTION.DIRC_DOWN;
	elif(velocity.y < 0):
		$AnimatedSprite.play("walkUp");
		$AnimatedSprite.flip_h = false;
		direction = DIRECTION.DIRC_UP;
	
	if(velocity.x == 0 && velocity.y == 0):
		$AnimatedSprite.stop();
	
	#process inputs for attacking
	if(Input.is_action_pressed("act_action")):
		match (direction):
			DIRECTION.DIRC_DOWN:
				$AnimatedSprite.play("attackDown");
				$AnimatedSprite.flip_h = false;
				continue;
				
			DIRECTION.DIRC_LEFT:
				$AnimatedSprite.play("attackSide");
				$AnimatedSprite.flip_h = false;
				continue;
				
			DIRECTION.DIRC_RIGHT:
				$AnimatedSprite.play("attackSide");
				$AnimatedSprite.flip_h = true;
				continue;
				
			DIRECTION.DIRC_UP:
				$AnimatedSprite.play("attackUp");
				$AnimatedSprite.flip_h = false;
				continue;
				
			_:
				continue;
		
		$AttackTimer.wait_time = ATTACK_TIME;
		$AttackTimer.start();
		$Weapon.attack(direction);
		isAttacking = true;
		return;
	
	velocity = velocity.normalized() * CONST_VEL;
	
	position += velocity * delta;
	position.x = clamp(position.x, 0 + 7*4, screenSize.x - 7*4);
	position.y = clamp(position.y, 0 + 8*4 + 100, screenSize.y - 8*4);

func _on_AttackTimer_timeout():
	$Weapon.sheathe();
	$AttackCD.start();

func _on_AttackCD_timeout():
	match (direction):
		DIRECTION.DIRC_DOWN:
			$AnimatedSprite.play("walkDown");
			$AnimatedSprite.stop();
			$AnimatedSprite.flip_h = false;
			continue;
			
		DIRECTION.DIRC_LEFT:
			$AnimatedSprite.play("walkSide");
			$AnimatedSprite.stop();
			$AnimatedSprite.flip_h = false;
			continue;
			
		DIRECTION.DIRC_RIGHT:
			$AnimatedSprite.play("walkSide");
			$AnimatedSprite.stop();
			$AnimatedSprite.flip_h = true;
			continue;
			
		DIRECTION.DIRC_UP:
			$AnimatedSprite.play("walkUp");
			$AnimatedSprite.stop();
			$AnimatedSprite.flip_h = false;
			continue;
		
		_:
			continue;
	
	isAttacking = false;

func haltInputs():
	$Weapon.sheathe();
	$AttackTimer.stop();
	$AttackCD.stop();
	$AnimatedSprite.play("walkDown");
	$AnimatedSprite.stop();
	$AnimatedSprite.flip_h = false;
	isAttacking = true;
	direction = DIRECTION.DIRC_DOWN;
	
func continueInputs():
	isAttacking = false;
