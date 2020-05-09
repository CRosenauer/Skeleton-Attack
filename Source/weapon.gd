extends Area2D

const DIRECTION = preload("res://direction.gd");

func _ready():
	pass;

func _process(delta):
	pass;

func attack(direction):
	match direction:
		DIRECTION.DIRC_UP:
			$Sprite.visible = true;
			$Sprite.flip_v  = true;
			$Sprite.rotation_degrees = 0;
			$HitBox.rotation_degrees = 0;
			$HitBox.disabled = false;
			position.y = -14 * 4;
			position.x = -2 * 4;
		DIRECTION.DIRC_DOWN:
			$Sprite.visible = true;
			$Sprite.flip_v  = false;
			$Sprite.rotation_degrees = 0;
			$HitBox.rotation_degrees = 0;
			$HitBox.disabled = false;
			position.y = 13 * 4;
			position.x = 1 * 4;
		DIRECTION.DIRC_LEFT:
			$Sprite.visible = true;
			$Sprite.flip_v  = false;
			$Sprite.rotation_degrees = 270;
			$HitBox.rotation_degrees = 90;
			$HitBox.disabled = false;
			position.x = 12 * 4;
			position.y = 1 * 4;
		DIRECTION.DIRC_RIGHT:
			$Sprite.visible = true;
			$Sprite.flip_v  = false;
			$Sprite.rotation_degrees = 90;
			$HitBox.rotation_degrees = 90;
			$HitBox.disabled = false;
			position.x = -12 * 4;
			position.y = 1 * 4;
		_: #default case
			pass;

func sheathe():
	$Sprite.visible = false;
	$Sprite.flip_v  = false;
	$Sprite.rotation_degrees = 0;
	$HitBox.rotation_degrees = 0;
	position.x = 0;
	position.y = 0;
	$HitBox.disabled = true;
