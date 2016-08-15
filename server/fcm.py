from pyfcm import FCMNotification
import feedparser

''' === important constants === '''

tags = ['A Song of Ice and Fire', 'Ace Attorney', 'Ace of Diamond', 'Addams Family', 'Agents of SHIELD', 'Aldnoah.Zero',
	'Alex Rider', 'Alias', 'Almost Human', 'American Horror Story', 'Angel: The Series', 'Animorphs', 'Arrow (TV 2012)',
	'Arslan Senki', 'Artemis Fowl', 'As the World Turns', 'Assassination Classroom', 'Assassin\'s Creed', 
	'Attack on Titan', 'Avatar (TV)', 'Avatar: Legend of Korra', 'Avatar: The Last Airbender', 'Avengers (Marvel)', 
	'Baby-Sitters Club', 'Babylon 5 & related', 'Baccano!', 'Band of Brothers', 'Batman', 'Battlestar Galactica', 
	'Being Human (UK)', 'Being Human (US/Canada)', 'Big Hero 6', 'Big Windup!', 'BioShock', 'Black Butler', 
	'Black Widow', 'Blue Exorcist', 'Boondock Saints', 'Borderlands', 'Breaking Bad', 'Brokeback Mountain', 
	'Brooklyn Nine-Nine', 'Buffy the Vampire Slayer', 'Bungou Stray Dogs', 'Burn Notice', 'CSI', 'Call of Duty',
	'Canadian 6 Degrees', 'Captain America', 'Captive Prince', 'Cardcaptor Sakura', 'Carmilla', 'Check Please!', 
	'Chronicles of Narnia', 'Code Geass', 'Community (TV)', 'Criminal Minds', 'Crisis Core: Final Fantasy VII', 
	'D.Gray-man', 'DCU', 'DRAMAtical Murder', 'Dangan Ronpa', 'Danny Phantom', 'Days Of Our Lives', 'Deadpool', 
	'Death Note', 'Descendants', 'Destiny (Video Game)', 'Detective Conan', 'Devil May Cry', 'Digimon', 'Discworld',
	'Dishonored (Video Games)', 'Disney', 'Divergent', 'Dollhouse', 'Downtown Abbey', 'Dr. Who & related', 'Dragon Age',
	'Dragon Ball', 'Dungeons & Dragons', 'Durarara!!', 'Elder Scrolls V: Skyrim', 'Elementary (TV)', 'Emmerdale', 
	'Eureka (TV)', 'Fairy Tail', 'Fake News', 'Faking It (TV 2014)', 'Fallout (Video Games)', 'Fangirl', 
	'Fast and Furious', 'Fate/stay night', 'Final Fantasy I', 'Final Fantasy II', 'Final Fantasy III', 
	'Final Fantasy IV', 'Final Fantasy IX', 'Final Fantasy V', 'Final Fantasy VI', 'Final Fantasy VII', 
	'Final Fantasy VIII', 'Final Fantasy X', 'Final Fantasy X & Final Fantasy X-2', 'Final Fantasy X-2', 
	'Final Fantasy XI', 'Final Fantasy XII', 'Final Fantasy XIII series', 'Final Fantasy XIV', 'Final Fantasy XV', 
	'Fire Emblem: Awakening', 'Fire Emblem: Fates', 'Fire Emblem: Path of Radiance/Radiant Dawn', 
	'Five Nights at Freddy\'s', 'Free!', 'Fringe (TV)', 'Fruits Basket', 'Fullmetal Alchemist', 'Game of Thrones',
	'Gangsta.', 'Gekkan Shoujo Nozaki-kun', 'General Hospital', 'Generation Kill', 'Ghostbusters', 'Gilmore Girls',
	'Gintama', 'Girl Genius', 'Girl Meets World', 'Glee', 'Good Omens', 'Gotham', 'Grand Theft Auto', 'Gravity Falls',
	'Green Arrow', 'Green Lantern', 'Grey\'s Anatomy', 'Grimm (TV)', 'Guardians of Childhood & related', 
	'Guardians of the Galaxy', 'Gundam & related', 'Haikyuu!!', 'Halo & related', 'Hamilton', 'Hannibal Lecter', 
	'Harry Potter', 'Hatoful Boyfriend', 'Hawkeye (Comics)', 'Hellsing', 'Hetalia: Axis Powers', 'High School Musical',
	'Highlander', 'Hikaru no Go', 'Homeland', 'Homestuck', 'Hornblower (TV)', 'House M.D.', 'How I Met Your Mother', 
	'How to Get Away With Murder', 'How to Train Your Dragon', 'Hunger Games', 'Hunter x Hunter', 'In the Flesh (TV)',
	'Infernal Devices', 'Inspector Morse & related', 'InuYasha', 'Invader Zim', 'Iron Man', 'James Bond', 
	'Jessica Jones (TV)', 'JoJo\'s Bizarre Adventure', 'Jupiter Ascending (2015)', 'Jurassic Park', 'Justice League', 
	'K', 'Kagerou Project', 'Kamen Rider', 'Karneval', 'Katekyou Hitman Reborn!', 'Kid Icarus', 'Kill la Kill', 
	'Kim Possible (Cartoon)', 'Kingdom Hearts', 'Kingsman: The Secret Service', 'Kuroko\'s Basketball', 'Labyrinth (1986)',
	'Law & Order: SVU', 'League of Legends', 'Legend of the Seeker', 'Les Miserables', 'Leverage', 'Lewis (TV)', 
	'Life is Strange', 'Life on Mars & related', 'Lord of the Rings', 'Lost Girl', 'Love Live! School Idol Project', 
	'MS Paint Adventures', 'Magi', 'Major Crimes (TV)', 'Maleficent', 'Marvel', 'Marvel (Movies)', 
	'Marvel Cinematic Universe', 'Mass Effect', 'Mega Man', 'Mekakucity Actors', 'Metal Gear', 'Metalopocalypse', 
	'Mighty Morphin Power Rangers', 'Minecraft', 'Miraculous Ladybug', 'Miss Fisher\'s Murder Mysteries', 
	'Mission: Impossible', 'Mortal Instruments', 'Mortal Kombat', 'My Hero Academia', 'My Little Pony', 'My Mad Fat Diary',
	'NCIS', 'Naruto', 'Natsume\'s Book of Friends', 'Neon Genesis Evangelion', 'Nightwing (Comics)', 'No. 6', 'Noragami',
	'Numb3rs', 'Once Upon a Time (TV)', 'One Piece', 'One-Punch Man', 'Orphan Black (TV)', 'Osomatsu-san', 
	'Ouran High School Host Club', 'Outlander & related', 'Outsiders (Ambiguous)', 'Overwatch', 'Pacific Rim', 
	'Pandora Hearts', 'Paranatural', 'Parks and Recreation', 'Penny Dreadful', 'Percy Jackson and the Olympians & related',
	'Person of Interest', 'Persona 3', 'Persona 4', 'Persona 5', 'Phantom of the Opera', 'Pirates of the Caribbean',
	'Pokemon', 'Pokemon Adventures', 'Portal (Video Game)', 'Power Rangers', 'Pretty Little Liars', 'Pride and Prejudice',
	'Primeval', 'Prince of Tennis', 'Princess Tutu', 'Prison Break', 'Professor Layton series', 'Psycho-Pass', 
	'Puella Magi Madoka Magica', 'Queer as Folk (US)', 'Ranma 1/2', 'Raven Cycle', 'Red Dwarf', 'Red Robin (Comics)', 
	'Reign (TV)', 'Resident Evil', 'Revolution (TV)', 'Revolutionary Girl Utena', 'Rick and Morty', 'Rizzoli & Isles',
	'Robin Hood', 'Rune Factory (Video Games)', 'Rurouni Kenshin', 'Sailor Moon', 'Saint Seiya', 'Saints Row', 'Saiyuki',
	'Sanctuary (TV)', 'Sengoku Basara', 'Sense8 (TV)', 'Seraph of the End', 'Shadowhunter Chronicles', 'Shakespeare',
	'Shameless (US)', 'Sherlock Holmes & related', 'Silent Hill', 'Silicon Valley', 'Simon Snow', 'Smallville', 
	'Sonic the Hedgehog', 'Sons of Anarchy', 'Soul Eater', 'South Park', 'Spartacus (TV)', 'Spider-Man', 
	'Stand Still Stay Silent', 'Star Trek', 'Star Wars', 'Star vs. the Forces of Evil', 'Starchy & Hutch', 'Stargate',
	'Steven Universe', 'Suikoden', 'Superman', 'Supernatural', 'Tales of Graces', 'Tales of Symphonia', 'Tales of Vesperia',
	'Tales of Xilla', 'Tales of Zestiria', 'Tales of the Abyss', 'Team Fortress 2', 'Teen Titans', 'Teen Wolf (TV)',
	'Teenage Mutant Ninja Turtles', 'Terminator', 'Terror in Resonance', 'The 100', 'The A-Team', 'The Almighty Johnsons',
	'The Big Bang Theory', 'The Blacklist', 'The Devil Wears Prada', 'The Dresden Files', 'The Eagle (Ambiguous)', 
	'The Evil Within (Video Game)', 'The Flash', 'The Following', 'The Fosters (TV 2013)', 'The Good Wife (TV)', 
	'The Hobbit', 'The Incredible Hulk', 'The Legend of Zelda', 'The Librarians (TV 2014)', 'The Losers (2010)', 
	'The Magnificent Seven (TV)', 'The Man From UNCLE.', 'The Martian', 'The Maze Runner', 'The Mentalist', 
	'The Mindy Project', 'The Newsroom (US TV)', 'The Office (US)', 'The Originals (TV)', 'The Pacific (TV)', 
	'The Professionals', 'The Sandman (Comics)', 'The Sentinel', 'The Silmarillion', 'The Vampire Diaries', 
	'The Walking Dead & related', 'The West Wing', 'The Witcher', 'Thor', 'Three Musketeers', 'Thunderbirds', 
	'Tin Man (2007)', 'Tokyo Ghoul', 'Torchwood', 'Tortall', 'Touhou Project', 'Touken Ranbu', 'Transformers', 'Tron', 
	'True Blood', 'True Detective', 'Tsubasa: Reservoir Chronicles', 'Under the Red Hood', 'Undertale', 
	'Until Dawn (Video Game)', 'Uta no Prince-sama', 'Vampire Knight', 'Veronica Mars', 'Vikings (TV)', 
	'Voltron: Legendary Defender', 'Warcraft', 'Warriors', 'Watchmen', 'Winter Soldier (Comics)', 'Wonder Woman', 
	'X-men', 'Xena: Warrior Princess', 'Yona of the Dawn', 'Young Justice', 'Yowamushi Pedal', 'Yu Yu Hakusho', 
	'Yu-Gi-Oh! (series)', 'Zero Escape (Video Games)', 'xxxHoLic']

keys = [2007008,
	1034737,
	1486363,
	108038,
	879346,
	2631558,
	114706,
	206112,
	882899,
	303506,
	934,
	131276,
	587792,
	69214,
	131285,
	18886,
	911149,
	56917,
	721553,
	1091121,
	166591,
	65,
	727114,
	957664,
	230714,
	13314,
	9151,
	236208,
	7473,
	352740,
	448892,
	2009747,
	873654,
	37215,
	155456,
	604153,
	247670,
	223663,
	133445,
	142166,
	1968629,
	1099950,
	1346,
	4594871,
	10213,
	86438,
	37210,
	582433,
	578887,
	3516977,
	4186,
	5405707,
	1147379,
	287734,
	34408,
	775667,
	9892,
	14088,
	2870,
	390,
	3634928,
	1633246,
	47474,
	199121,
	662604,
	925984,
	5154319,
	816757,
	964594,
	21944,
	481231,
	131997,
	10788043,
	154229,
	263316,
	14136,
	170944,
	105412,
	827055,
	19877,
	579568,
	90773,
	309473,
	440981,
	152669,
	261760,
	55873,
	25575,
	1781878,
	870188,
	1109537,
	157745,
	274395,
	24854,
	24864,
	14198,
	14036,
	13892,
	14205,
	14042,
	8210,
	10795,
	10596,
	103329,
	13855,
	24865,
	287,
	448770,
	711325,
	933850,
	782522,
	5493837,
	172695,
	2730336,
	865923,
	10406377,
	3103,
	2954180,
	242462,
	423753,
	2632233,
	26671,
	3165,
	215082,
	884,
	62494,
	21914,
	721159,
	13154,
	114591,
	2818614,
	5443632,
	524391,
	848190,
	5455680,
	114,
	299272,
	930011,
	777706,
	624039,
	758208,
	7205540,
	6637939,
	735779,
	136512,
	431982,
	484757,
	266,
	12845,
	305075,
	434477,
	3549,
	290625,
	117807,
	9775,
	272,
	10313,
	3046868,
	125633,
	452309,
	22959,
	813142,
	850435,
	1100985,
	13184,
	43537,
	739806,
	380372,
	5466945,
	1487281,
	4212458,
	3409358,
	4945534,
	614804,
	491649,
	796030,
	15830,
	244259,
	939813,
	1146205,
	63584,
	4182,
	3883994,
	519363,
	14621,
	1014,
	483836,
	54428,
	102330,
	5280,
	262567,
	4153523,
	249183,
	741433,
	144106,
	796047,
	129342,
	603432,
	554058,
	1348854,
	7266,
	96137,
	414093,
	49548,
	215080,
	1749187,
	28625,
	18810,
	11263,
	254648,
	582724,
	500110,
	110196,
	116265,
	701010,
	3828398,
	17199,
	763581,
	951,
	13999,
	309920,
	112929,
	525714,
	479394,
	1327257,
	1747,
	379999,
	10767,
	1199183,
	883659,
	7048385,
	482937,
	2943377,
	1553899,
	3406514,
	872785,
	20555,
	1124470,
	46414,
	1909262,
	658827,
	287761,
	13896,
	13665,
	4231202,
	233118,
	223664,
	448284,
	61493,
	83491,
	541,
	126098,
	6762709,
	5009,
	94259,
	3045,
	4917,
	111275,
	644159,
	226819,
	1039,
	21571,
	628622,
	1196,
	258664,
	1157470,
	104798,
	594995,
	95038,
	1357661,
	129781,
	101645,
	535185,
	2737,
	2529660,
	59203,
	362807,
	5074,
	10565,
	59739,
	5381302,
	3094364,
	850338,
	202578,
	245573,
	105692,
	4089308,
	1772539,
	1109601,
	187,
	451725,
	22404,
	14184,
	35537,
	291621,
	130638,
	3697829,
	1801,
	101375,
	4076489,
	11778,
	135886,
	1197580,
	21128,
	431213,
	27,
	470458,
	28057,
	5324,
	520763,
	3535484,
	3699,
	44716,
	4945690,
	258526,
	1064218,
	109503,
	2486805,
	4585787,
	1343765,
	304320,
	775959,
	1129372,
	54476,
	726686,
	627240,
	3134381,
	2850393,
	719523,
	919104,
	1001902,
	541478,
	730108,
	1387845,
	3605093,
	126504,
	78546,
	5882645,
	5439781,
	3163988,
	12984,
	566569,
	512641,
	4405,
	813205,
	4124108,
	1673,
	774727,
	273,
	230931,
	2233012,
	6906220,
	450,
	299357,
	625992,
	230438,
	105286,
	33061,
	2129537,
	203,
	115633,
	257095,
	4122599,
	219012,
	217263,
	9902,
	1322077,
	11007,
	153784,
	6541412,
	6302834,
	398188,
	11974,
	1582930,
	781463,
	10104017,
	827052,
	116711,
	103350,
	722204,
	1283234,
	250093,
	4794,
	694407,
	4878889,
	1149757,
	941637,
	1346123,
	765738,
	4039]

push_service = FCMNotification(api_key="<omitted>")

''' === reading/writing functions === '''

def strip_newlines(strings):
	stripped = list()
	for string in strings:
		stripped.append(string.rstrip('\n'))
	return stripped

def read_files():
	last_checked = list()
	last_id = list()
	with open('/home/richard/FCM/last_checked.txt', 'r') as last_checked_file, open('/home/richard/FCM/last_id.txt', 'r') as last_id_file:
		last_checked = strip_newlines(last_checked_file.readlines())
		last_id = strip_newlines(last_id_file.readlines())
		last_checked_file.close()
		last_id_file.close()
	return last_checked, last_id

def write_files(last_checked, last_id):
	with open('/home/richard/FCM/last_checked.txt', 'w') as last_checked_file, open('/home/richard/FCM/last_id.txt', 'w') as last_id_file:
		for checked in new_checked:
			last_checked_file.write('%s\n' % checked)
		for _id in new_ids:
			last_id_file.write('%s\n' % _id)
		last_checked_file.close()
		last_id_file.close()

''' === extracting functions === '''

def extract_ships(string):
	if '<li>Relationships:' in string:
		if '<li>Additional Tags:' in string:
			temp = extract_helper(string, '<li>Relationships: <a', '<li>Additional Tags:')
		else:
			temp = extract_helper(string, '<li>Relationships: <a', '</ul>')
		return repeat_extract(temp, '\">', '</a>')
	else:
		return "no relationships"

def extract_helper(string, startRef='', endRef=''):
	start = string.find(startRef) + len(startRef)
	end = string.find(endRef, start)

	if startRef == '': return string[:-end]
	if endRef == '': return string[start:]

	return string[start:end]

def repeat_extract(string, startRef, endRef):
	extracted = extract_helper(string, startRef, endRef)
	temp = extract_helper(string, endRef)
	while startRef in temp:
		extracted += (", %s" % extract_helper(temp, startRef, endRef))
		temp = extract_helper(temp, endRef)
	return extracted

def char_helper(s):
	string = s.replace('&amp;', '&')
	string = string.replace('&#x27;', '\'')
	string = string.replace('&quot;', '\"')
	return string

''' === feed checking function === '''

def check_feed(index):
	print("in check_feed for index %d" % index)
	url = 'https://archiveofourown.org/tags/%s/feed.atom' % str(keys[index])

	_id = ''
	if (len(last_id) > index):
		_id = last_id[index] # ok even if last_id[index] is empty b/c this is ONLY about assignment

	checked = ''
	if (len(last_checked) > index) and (last_checked[index] != ''):
		checked = last_checked[index]
		try:
			parsed = feedparser.parse(url, modified=checked)
		except:
			print("unable to parse feed: %s" % url)
			return checked, _id
	else:
		try:
			parsed = feedparser.parse(url)
		except:
			print("unable to parse feed: %s" % url)
			return checked, _id

	print("status %d" % parsed.status)

	if parsed.status == 304:
		# should be impossible for there not to be a last_checked or last_id in this case
		# b/c that could only happen if the feed is empty... 
		return checked, _id

	last_checked_pos = len(parsed.entries)-1
	for i in range(0, len(parsed.entries)): # excludes end index
		if parsed.entries[i].id == _id:
			last_checked_pos = i

	print("last_checked_pos: %d" % last_checked_pos)

	# b/c sometimes the feed doesn't give 304 even when there isn't a new fic
	if last_checked_pos == 0:
		return checked, _id

	for n in range(0, last_checked_pos):
		title = char_helper(parsed.entries[n].title)
		ships = char_helper(extract_ships(parsed.entries[n].summary))
		message = "New in %s: %s - %s" % (tags[index], title, ships)
		message = message.encode('ascii', 'ignore')
		print(message)
		payload = { 'title': title, 'link': parsed.entries[n].link }
		push_service.notify_topic_subscribers(topic_name=str(keys[index]), message_body=message, data_message=payload)

	try:
		checked = parsed.modified
	except:
		print("no last-modified header?")
		pass

	return checked, parsed.entries[0].id

''' === do the thing === '''

new_checked = list()
new_ids = list()

if (len(tags) == len(keys)): # a safeguard
	last_checked, last_id = read_files()
	for index in range(0, len(tags)):
		modified, newest_id = check_feed(index=index)
		new_checked.append(modified)
		new_ids.append(newest_id)
	print('\n\n\n') # so that the output log is easier to read
	write_files(last_checked, last_id)
else:
	print("length of tags is not equal to length of keys")

