extends Area2D

signal sig_mobHit(Mob);

var index = 0;

const SCORE_INCR = 100;

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("enemies");

func _process(delta):
	pass;

func death():
	queue_free();

func _on_Mob_area_shape_entered(_area_id, _area, _area_shape, _self_shape):
	$Sprite.visible = false;
	$HurtBox.set_deferred("disabled", true);
	emit_signal("sig_mobHit", self);
