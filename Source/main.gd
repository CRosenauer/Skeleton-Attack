extends Node

export (PackedScene) var Mob;

const SPAWN_POS = [Vector2(171, 183), Vector2(171, 350),
				   Vector2(171, 517), Vector2(512, 183),
				   Vector2(512, 517), Vector2(853, 183),
				   Vector2(853, 350), Vector2(853, 517)];

#list to confirm if a mob is currently occurpying a certain spawn slot
var mobList = [false, false, false, false, false, false, false, false];

var highScore;
var score;

var playing = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	highScore = 0;
	score = 0;
	$HUD.setScore(score);
	$HUD.setTimer($GameTimer.time_left);
	$HUD.setHighScore(highScore);
	reset();
	randomize();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$HUD.setScore(score);
	$HUD.setTimer($GameTimer.time_left);
	
	if(!playing && Input.is_action_pressed("act_action")):
		start();
		Input.action_release("act_action");
	

func _on_SpawnTimer_timeout():
	$SpawnTimer.start($SpawnTimer.wait_time);
	
	var index = randi() % 8
	
	var tempIndex = index;
	while(mobList[tempIndex]):
		tempIndex += 1;
		if(tempIndex > 7):
			tempIndex = 0;
			
		if(tempIndex == index):
			return;
	
	#signify spawn is occupied
	index = tempIndex;
	var spawnPosition = SPAWN_POS[index];
	mobList[index] = true;
	
	var newMob = Mob.instance();
	newMob.position = spawnPosition;
	newMob.index = index;
	add_child(newMob);
	newMob.connect("sig_mobHit", self, "_on_Mob_sig_mobHit");

func _on_Mob_sig_mobHit(p_Mob):
	score += p_Mob.SCORE_INCR;
	mobList[p_Mob.index] = false;
	p_Mob.queue_free();
	$HitSound.play();
	pass;
	
func _on_GameTimer_timeout():
	gameOver();

func gameOver():
	reset();
	
	if( score > highScore ):
		highScore = score;
		$HUD.setHighScore(highScore);
	
	for i in mobList:
		mobList[i] = false;
	
	score = 0;
	
	$HUD.gameOver();
	$Player.visible = false;

func reset():
	$Player.position.x = $StartPosition.position.x;
	$Player.position.y = $StartPosition.position.y;
	
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.queue_free();
		
	$SpawnTimer.stop();
	
	$Player._on_AttackTimer_timeout();
	
	#disable movement inputs
	$Player.haltInputs();
	$Player.visible = false;
	
	playing = false;

func start():
	$SpawnTimer.start($SpawnTimer.wait_time);
	$GameTimer.start();
	$Player.continueInputs();
	$HUD.gameStart();
	$Player.position = $StartPosition.position;
	$Player.visible = true;
	playing = true;
