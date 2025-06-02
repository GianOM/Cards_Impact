extends Panel

@onready var chat_log: RichTextLabel = $VBoxContainer/Chat_Log
@onready var chat_line: LineEdit = $VBoxContainer/Chat_Line




func _on_chat_line_text_submitted(new_text: String) -> void:
	add_text_to_chat_log.rpc(new_text)
		
@rpc("any_peer","reliable","call_local")
func add_text_to_chat_log(My_Text: String):
		if My_Text != "":
			#"\n" É UMA QUEBRA DE LINHA
			#LobbyMultiplayer.List_of_Players[multiplayer.get_remote_sender_id()].name
			chat_log.text += str(LobbyMultiplayer.List_of_Players[multiplayer.get_remote_sender_id()].name) + ": " + My_Text + "\n"
			chat_line.text = ""
	
