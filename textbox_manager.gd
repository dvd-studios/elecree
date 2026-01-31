extends CanvasLayer

func show_text(text: String):
	get_node("TextBox").show()
	get_node("TextBox/VBoxContainer/Label").text = text

func hide_text():
	get_node("TextBox").hide()
	get_node("TextBox/VBoxContainer/Label").text = ""
