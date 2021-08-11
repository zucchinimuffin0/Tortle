Const w = 800
Const h = 600

Graphics w,h

Global mapLoaded = -1

AutoMidHandle True 
AutoImageFlags MASKEDIMAGE|MIPMAPPEDIMAGE

Global grass_img:TImage = LoadImage:TImage("assets\tile\grass.png")
Global dirt_img:TImage = LoadImage:TImage("assets\tile\dirt.png")
Global water_img:TImage = LoadImage:TImage("assets\tile\water.png")


SetMaskColor 255,0,255

Global char_img:TImage = LoadAnimImage:TImage("assets\character\character.png",22,23,0,4)

Global testmap[32,32]
testmap[4,5] = 2


''console
Global consoleopen = False
Global editingMap = False

Global cmd:String = ""
Global lastkey
Global lastcmd:String = ""

Global cheatsEnabled = False

Global cursor:String = "_"
Global cursorblink
Global cursorblinkrate = 120
Global maxchars = 64


''scale variables
Global scale = 2

''player variables
Global xoffset:Float = 0.0
Global yoffset:Float = 0.0

Global xvel:Float = 0.0
Global yvel:Float = 0.0



Global accel:Float = 0.08
Global friction:Float = 0.9

Global canmove = False

Global frame:Float = 0

Type consolechat
	Field x
	Field y
	Field t:String

	Field r
	Field g
	Field b
EndType

Global consolelist:TList = New TList

While Not KeyDown(KEY_ESCAPE)
	Cls
	
	canmove = True 
	
	SetScale scale,scale
	
	drawCurrentMap()
	
	If KeyHit(KEY_TILDE) Then 
		FlushKeys()
		consoleopen = Not consoleopen
	EndIf
	
	
	player_draw()
	
	
	SetScale 1,1
	If consoleopen Then 
		console()
		drawconsole()
	EndIf
	SetScale scale,scale
	
	player_control()
	
	Flip
Wend
End

Function player_draw()
	DrawImage char_img,w/2,h/2,frame
EndFunction

Function player_control()
	
	If canmove Then
		If KeyDown(KEY_W) Then
			yvel = yvel + accel
			frame = frame + 0.1
		EndIf
		If KeyDown(KEY_A) Then
			xvel = xvel + accel
			frame = frame + 0.1
		EndIf
		If KeyDown(KEY_S) Then
			yvel = yvel - accel
			frame = frame + 0.1
		EndIf
		If KeyDown(KEY_D) Then
			xvel = xvel - accel
			frame = frame + 0.1
		EndIf
	EndIf
	xoffset = xoffset + xvel
	yoffset = yoffset + yvel
	
	xvel = xvel * friction
	yvel = yvel * friction
	
	If frame >= 4 Then frame = 0
EndFunction

Function create_console_msg(t:String,cmd_type:String = "")
	If Len(t) <> 0 Then
		For Local h:consolechat = EachIn consolelist
			h.y = h.y - 15
		Next

		Local b:consolechat = New consolechat
		b.t = t
		b.x = 15
		b.y = 165
		
		Select cmd_type
			Case "error"
				b.r = 255
				b.g = 0
				b.b = 0
			Case "command"
				b.r = 64
				b.g = 32
				b.b = 255
			Default
				b.r = 255
				b.g = 255
				b.b = 255		
		EndSelect
				
		consolelist.addlast(b)
	EndIf

EndFunction

Function consolecommands()
	Local response:String
	Local cmd_type:String
		
	If lastcmd <> "" Then
		Select Left(lastcmd,6)
			Case "cheats"
				If Right(lastcmd,1) = "1" Then 
					cheatsenabled = True
					
					response = "Cheats set to "+cheatsenabled
					cmd_type = "command"
				ElseIf Right(lastcmd,1) = "0" Then 
					cheatsenabled = False
				
					response = "Cheats set to "+cheatsenabled
					cmd_type = "command"
				Else
					response = "Invalid syntax for '"+lastcmd+"'"
					cmd_type = "error"
				EndIf
				
			Default
				response = "Unknown command '"+lastcmd+"'"
				cmd_type = "error"
		EndSelect
	EndIf
	
	create_console_msg(response,cmd_type)
	
	lastcmd = ""
EndFunction

Function drawconsole()
	SetColor 128,128,128
	DrawRect 8,200,maxchars*TextWidth("W")+2,15
	
	DrawRect 8,8,maxchars*TextWidth("W")+2,180
	
	cursorblink = cursorblink - 1
	If cursorblink <= 0 Then cursorblink = cursorblinkrate
	
	SetColor 255,255,255
	If cursorblink < cursorblinkrate/2 Then
	 	DrawText cmd+cursor,10,200
	Else
		DrawText cmd,10,200
	EndIf

	For c:consolechat = EachIn consolelist
		SetColor c.r,c.g,c.b
		DrawText c.t,c.x,c.y
	Next
	
	SetColor 255,255,255
EndFunction

Function console:String()
	canmove = False
	
	'Local lastcmd$
	
	lastkey = GetChar()
	
	If lastkey <> KEY_TILDE And lastkey <> 0 And lastkey <> KEY_BACKSPACE And Len(cmd) < maxchars Then
		cmd = cmd + Chr(lastkey)
	EndIf
	
	If KeyHit(KEY_BACKSPACE) Then
		If Len(cmd) > 0 Then
			cmd = Left(cmd,Len(cmd)-1)
		EndIf
	EndIf
	
	If KeyHit(KEY_ENTER) Then
		lastcmd = cmd
		cmd = ""
		
		For Local h:consolechat = EachIn consolelist
			h.y = h.y - 15
		Next
				
		Local b:consolechat = New consolechat
		b.r = 255
		b.g = 255
		b.b = 255
		
		b.t = lastcmd
		b.x = 15
		b.y = 165
		consolelist.addlast(b)
		
		lastcmd = Trim(Lower(lastcmd))
		
		consolecommands()
	EndIf
EndFunction

Function drawCurrentMap()
	Local map[0,0]
	
	Select mapLoaded
		Case -1
			map = testmap
	EndSelect
	
	For x = 0 To 31
		For y = 0 To 31
			Select map[x,y]
				Case 0
					DrawImage grass_img,(x*32+xoffset)*scale,(y*32+yoffset)*scale
				Case 1
					DrawImage dirt_img,(x*32+xoffset)*scale,(y*32+yoffset)*scale
				Case 2
					DrawImage water_img,(x*32+xoffset)*scale,(y*32+yoffset)*scale
			EndSelect
		Next
	Next
EndFunction
