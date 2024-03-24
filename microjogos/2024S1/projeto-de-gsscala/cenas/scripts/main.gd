extends Node2D

signal win
signal lose

const WIDTH = 1920
const HEIGHT = 1080

var index = 0
var combo_list = ["UD","UL","UR","UA","DL","DR","DA","LR","LA","RA"]

var translated_combos = []

var dicionario = {
	"U" : "cima",
	"D" : "baixo",
	"A" : "acao",
	"L" : "esquerda",
	"R" : "direita"
}

# Called when the node enters the scene tree for the first time.
func _ready():
	
	match Global.language:
		Global.LANGUAGE.EN:
			NotificationCenter.notify("MATCH THE COMBOS!")
		Global.LANGUAGE.PT:
			NotificationCenter.notify("ACERTE OS COMBOS!")
	$"hero".play("default")
	$"boss".play("fly")
	randomize()
	combo_list.shuffle()
	
	combo_list = combo_list.slice(0, 8)
	
	
	for combo in combo_list:
		var temp = []
		for l in combo:
			temp.append(dicionario.get(l))
		translated_combos.append(temp)
	update_animations()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if index > 7:
		return
		
	if not false in translated_combos[index].map(func(x): return Input.is_action_pressed(x)):
		index += 1
		$"boss".play("hit")
		$AudioStreamPlayer2.play()
		#increase panning speed
		if index > 7:
			register_win()
			NotificationCenter.notify("VC VENCEU!")
			$AudioStreamPlayer3.play()
			$"boss".play("death")
			$"arrow_left".play("false")
			$"arrow_right".play("false")
			$"arrow_up".play("false")
			$"arrow_down".play("false")
			$"action".play("false")
			#TODO Remove Before PR merge
			#get_parent().get_tree().quit()
			#return
		else:
			update_animations()



func register_win():
	emit_signal("win")


func register_lose():
	emit_signal("lose")
	
func update_animations():
	if "esquerda" in translated_combos[index]:
		$"arrow_left".play("true")
	else:
		$"arrow_left".play("false")
	if "direita" in translated_combos[index]:
		$"arrow_right".play("true")
	else:
		$"arrow_right".play("false")
	if "cima" in translated_combos[index]:
		$"arrow_up".play("true")
	else:
		$"arrow_up".play("false")
	if "baixo" in translated_combos[index]:
		$"arrow_down".play("true")
	else:
		$"arrow_down".play("false")
	if "acao" in translated_combos[index]:
		$"action".play("true")
	else:
		$"action".play("false")


func _on_boss_animation_finished():
	if index < 8 :
			$"boss".play("fly")
	else:
			$"boss".queue_free()
