extends Node2D

var party_name: String
var mp_nb: int

func setup(_party_name: String, image_path: String, image_path2: String):
	if ResourceLoader.exists(image_path):
		$PartyImage.texture = load(image_path)
		$PartyImageBlack.texture = load(image_path2)
	else:
		print("Texture not found: " + image_path)
	party_name = _party_name

func update(_mp_nb: int):
	mp_nb= _mp_nb
	$Text.bbcode_text ="[color=black][font_size=22]%s
[font_size=15]%s députés" % [party_name,str(mp_nb)]
