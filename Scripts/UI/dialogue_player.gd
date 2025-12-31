extends Node2D

var characters = {
	"qewbi" : $Player, #notably not qewbi, not necessarily
	"gacy" : "",
	"onion" : "",
	"didi" : "",
	"tess" : "",
}

func play_dialogue(chain:Dialogue.textbox):
	pass

func char_enter(character):
	#fade in background and textbox
	pass
	
func char_exit(character):
	#for each enabled character, fade them out
	pass

func char_fade(character):
	#if character is invisible, move them in
	#if other characters are visible, fade them and lower them
	#if character is faded, unfade them and raise them
	pass
	
func play_text(textbox:Dialogue.textbox):
	pass
