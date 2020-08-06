extends Control

var characterkeys = {
	A = 'ARRON',
	R = 'ROSE',
	RO = 'ROSE',
	GRD = 'GUARD',
	L = 'LYRA',
	N = 'NORBERT',
	G = 'GOBLIN',
	EM = 'EMBER',
	F = 'FLAK',
	W = 'Great Willow',
	ER = 'Erika',
	D = 'DEMITRIUS',
	I = 'IOLA',
	'???': '???',
	RI = 'RILU',
	Dwarf = 'Dwarf',
	DK = 'DwarvenKing',
	FQ = 'FaeryQueen'
};

var characterportraits = {
	A = 'ArronSmile',
	R = 'RoseNormal',
	RO = 'RoseNormal',
	GRD = 'Guard',
	L = 'Lyra',
	N = 'NorbertNormal',
	G = 'Goblin',
	EM = 'EmberFriendly',
	F = 'Flak',
	W = 'Null',
	ER = 'ErikaNormal',
	D = 'Demitrius',
	I = 'IolaNeutral',
	RI = 'RiluNormal',
	'???': 'RiluNormal',
	Dwarf = 'Dwarf',
	DK = 'KingDwarf',
	FQ = 'FaeryQueen'
};

func _on_Button_pressed():
	$result.text = "[\n";
	var input = $input.text.replace('  ', ' ').split('\n');
	
	for l in input:
		var tmp = l.split(' - ');
		$result.text += "{";
		$result.text += '"effect":"text",';
		var name;
		var portrait;
		if tmp.size() > 1:
			name = characterkeys[tmp[0]];
			portrait = '"%s"' % characterportraits[tmp[0]];
		else:
			name = 'narrator'
			portrait = 'null'
		$result.text += '"portrait":%s,' % portrait;
		$result.text += '"sound":null,';
		
		$result.text += '"source":"%s",' % name;
		$result.text += '"value":"%s"' % tmp[tmp.size()-1];
		$result.text += "},\n";
		pass
	$result.text += "]";
	pass 
