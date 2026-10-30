extends Node2D

#Abandoning this system because I sincerely doubt it will be needed
#like, hollow knight can render thousands and thousands of entities without getting bothered
#it'll be fine if i don't have a centralized dialogue manager right

'var characters = {
	"qewbi" : visibility.HIDDEN, #notably not qewbi, not necessarily
	"gacy" : visibility.HIDDEN,
	"onion" : visibility.HIDDEN,
	"didi" : visibility.HIDDEN,
	"tess" : visibility.HIDDEN,
}
enum visibility {HIDDEN, FADED, VISIBLE}'


func play_dialogue(char_name : String, text : String):
	#unhide dialogue
	if not $Background.visible:
		$Background.visible = true
		$Text.visible = true
		$Nametag.visible = true
	
	play_text(char_name, text)
	
	'for char in characters.keys():
		if char == char_name.to_lower():
			pass'
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
	
func play_text(char_name : String, text : String):
	$Text.visible_characters = 0
	$Text.text = text
	$Nametag.text = char_name
	for i in range(text.length()):
		$Text.visible_characters +=1
	pass

func exit_dialogue():
	$Background.visible = false
	$Text.visible = false
	$Nametag.visible = false
