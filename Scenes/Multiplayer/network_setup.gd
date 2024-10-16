extends Control

@export var ip_address = "127.0.0.1"
@export var port = 29860
@export var max_Clients = 4
@export var peer = null

@export var player_ip_address = ""

@export var synchronized = false
@export var running = false
@export var playerId = null

@export var Player_Scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	
	if OS.get_name() == "Windows":
		player_ip_address = IP.get_local_addresses()[3]
	elif OS.get_name() == "Android":
		player_ip_address = IP.get_local_addresses()[0]
	else:
		player_ip_address = IP.get_local_addresses()[3]
		
	for ip in IP.get_local_addresses():
		if ip.begins_with("192.168.") and not ip.ends_with(".1"):
			player_ip_address = ip

func add_player(id) -> void:
	GameManager.spawn_player(id)

func peer_connected(id):
	print("Player Connected " + str(id) + " " + player_ip_address)
	add_player(id)
	

func peer_disconnected(id):
	print("Player Disconnected " + str(id))

func connected_to_server():
	print("Connected to Server!")
	send_player_information.rpc_id(1, $BoxContainer/Name.text, playerId)

func connection_failed():
	print("Connection Failed!")

@rpc("any_peer")
func send_player_information(name, id):
	if !GameManager.Players.has(id):
		GameManager.Players[id] = {
			"name": name,
			"id": id,
			"ip_address": player_ip_address
		}

	if multiplayer.is_server():
		for i in GameManager.Players:
			send_player_information.rpc(GameManager.Players[i].name, i)

func start_game(playerId):
	var scene = load("res://Scenes/Main.tscn").instantiate()
	get_tree().root.add_child(scene)
	scene.spawn_player(playerId)
	self.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_join_pressed() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_client(ip_address, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	
	playerId = multiplayer.get_unique_id()
	call_deferred("start_game", playerId)
	

func _on_host_pressed() -> void:
	peer = ENetMultiplayerPeer.new()
	
	var error = peer.create_server(port, max_Clients)
	
	if error != OK:
		print("Cannot host: " + error)
		return
	
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)
	print("Server Started!")
	
	playerId = multiplayer.get_unique_id()
	send_player_information($BoxContainer/Name.text, playerId)
	
	call_deferred("start_game", playerId)
