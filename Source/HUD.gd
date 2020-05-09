extends Node2D

const HUD_HEIGHT = 100;

func _ready():
	gameOver();
	pass;


func _process(delta):
	pass;

func setScore(string):
	$GameplayText/ScoreLabel.text = "SCORE\n" + str(string);

func setHighScore(string):
	$GameplayText/HighScoreLabel.text = "HIGH SCORE\n" + str(string);

func setTimer(string):
	$GameplayText/TimerLabel.text = "TIME\n" + str(ceil(string));

func gameStart():
	$GameplayText/TimerLabel.visible = true;
	
	$StartText/Title.visible = false;
	$StartText/Instructions.visible = false;

func gameOver():
	$GameplayText/TimerLabel.visible = false;
	
	$StartText/Title.visible = true;
	$StartText/Instructions.visible = true;
