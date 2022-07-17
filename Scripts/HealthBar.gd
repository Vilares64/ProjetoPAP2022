extends Control

func _ready():
	Lives.live = 100

func _physics_process(delta):
		$ProgressBar.value = Lives.live
