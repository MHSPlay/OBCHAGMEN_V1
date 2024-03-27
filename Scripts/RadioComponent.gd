extends AudioStreamPlayer3D

var tracks = [
	"res://Sounds/Music/Radio/Drop.wav",
	"res://Sounds/Music/Radio/Exercise.wav",
	"res://Sounds/Music/Radio/Lost.wav",
	"res://Sounds/Music/Radio/Stranger.wav",
	"res://Sounds/Music/Radio/Synths.wav",
	"res://Sounds/Music/Radio/Terrorizer.wav",
	"res://Sounds/Music/Radio/OST LOADING OBSHAGMEN.wav",
	"res://Sounds/Music/Radio/Over The Radio.wav",
	"res://Sounds/Music/Radio/It’s A Scream, Baby.wav" 
]

var transition_track = "res://Sounds/Music/Radio/SwitchTrack.wav"
var current_track_index = -1

func _ready():
	play_next_track()

func play_next_track():
	current_track_index += 1

	if current_track_index >= tracks.size():
		current_track_index = 0

	# skip next track
	stream = load(transition_track)
	play()
	await get_tree().create_timer(2.1).timeout
	
	# play tracks
	var next_track = load(tracks[current_track_index])
	stream = next_track
	play()

func _on_finished():
	play_next_track()
