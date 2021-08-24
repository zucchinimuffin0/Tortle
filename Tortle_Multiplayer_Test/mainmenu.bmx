''Title screen

Global menuExited = False

''HideMouse()

Global titlescale:Float = 4


SetImageFont font

Type button
	Field x
	Field y
	Field width
	Field height
	Field t:String
	Field active
	Field clicked
EndType

Type window
	Field x
	Field y
	Field width
	Field height
	Field title:String
	Field visible
	
	Field children:TList
EndType


Global button_list:TList = New TList
Global window_list:TList = New TList


Global option_window:window = New window
option_window.x = 180
option_window.y = 150
option_window.width = 300
option_window.height = 400
option_window.title = "Settings"

window_list.addlast(option_window)

Global server_window:window = New window
server_window.x = 180
server_window.y = 150
server_window.width = 300
server_window.height = 400
server_window.title = "Multiplayer Servers"

window_list.addlast(server_window)


Global playbutton:button = New button
playbutton.x = 10
playbutton.y = 200
playbutton.t = "Play"
playbutton.width = TextWidth(playbutton.t)+30
playbutton.height = TextHeight(playbutton.t)+4
playbutton.active = True

button_list.addlast(playbutton)


Global multiplayer:button = New button
multiplayer.x = 10
multiplayer.y = 230
multiplayer.t = "Join Server"
multiplayer.width = TextWidth(playbutton.t)+30
multiplayer.height = TextHeight(playbutton.t)+4
multiplayer.active = True

button_list.addlast(multiplayer)


Global options:button = New button
options.x = 10
options.y = 260
options.t = "Settings"
options.width = TextWidth(playbutton.t)+30
options.height = TextHeight(playbutton.t)+4
options.active = True

button_list.addlast(options)


Global exitbutton:button = New button
exitbutton.x = 10
exitbutton.y = 290
exitbutton.t = "Exit"
exitbutton.width = TextWidth(playbutton.t)+30
exitbutton.height = TextHeight(playbutton.t)+4
exitbutton.active = True

button_list.addlast(exitbutton)


Global mousestate = 0

SetClsColor 135,206,250

HideMouse()

While Not menuExited
	Cls
	mousestate = 0
		
	SetColor 255,255,255
	DrawImage tester_img,w/2,h/2

	SetScale titlescale,titlescale
	DrawImage title_img,titlescale*ImageWidth(title_img)/2,titlescale*ImageHeight(title_img)/2
	SetScale 1,1
		
	handle_menu_buttons()
	
	handlewindows()
	
	If MouseHit(1) Then FlushMouse()
	
	Select mousestate
		Case 0
			DrawImage cursor1_img,MouseX(),MouseY()
		Case 1
			DrawImage cursor2_img,MouseX(),MouseY()
		Case 2
			DrawImage cursor3_img,MouseX(),MouseY()
	EndSelect
	
	Flip
Wend

optionsOpen = False
multiplayerOpen = False

Function handlewindows()
	For win:window = EachIn window_list
		If win.visible Then 
			DrawRect2 win.x,win.y,win.width,win.height,3, 128,128,128
			
			SetImageFont font2
			SetColor 180,180,180
			DrawText win.title,win.x+win.width/2-TextWidth(win.title)/2,win.y+3
			SetImageFont font
		EndIf
	Next
EndFunction

Function DrawRect2(x1,y1,w1,h1,thickness = 2,red = 255, green = 255, blue = 255)
	SetColor red,green,blue
	DrawRect x1,y1,w1,h1
	
	SetColor 255,255,255
	DrawRect x1,y1,thickness,h1
	DrawRect x1,y1,w1,thickness
	DrawRect x1,y1+h1-thickness,w1,thickness
	DrawRect x1+w1-thickness,y1,thickness,h1
EndFunction


Function handle_menu_buttons()
	For b:button = EachIn button_list
		
		If mouseinrect(b.x,b.y-ImageHeight(button_img)/2,ImageWidth(button_img),ImageHeight(button_img)) And b.active = True Then
			SetColor 128,128,128
			mousestate = 2
			
			If MouseHit(1) Then
				b.clicked = True
			EndIf
		Else
			SetColor 255,255,255		
		EndIf
				
		DrawImage button_img,b.x+ImageWidth(button_img)/2,b.y
		
		SetColor 150,150,150
		DrawText b.t,b.x+8,b.y+2-ImageHeight(button_img)/2
	Next
	
	
	If playbutton.clicked = True Then
		playbutton.clicked = False
		menuExited = True
		
	EndIf

	If multiplayer.clicked = True Then
		multiplayer.clicked = False
		server_window.visible = Not server_window.visible
		option_window.visible = False		
	EndIf
	
	If options.clicked = True Then
		options.clicked = False
		option_window.visible = Not option_window.visible
		server_window.visible = False	
	EndIf
	
	If exitbutton.clicked = True Then
		End
		
	EndIf
	
EndFunction

Function MouseInRect(x1,y1,w1,h1)
	If MouseX() > x1 And MouseX() < x1+w1 Then
		If MouseY() > y1 And MouseY() < y1+h1 Then
			Return True
		EndIf
	EndIf
EndFunction