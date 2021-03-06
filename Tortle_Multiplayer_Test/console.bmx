''Console
Global consoleposy = h-220
Global consoleposx = 0

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

Global leveleditor = False


Type consolechat
	Field x:Int
	Field y:Int
	Field t:String

	Field r
	Field g
	Field b
EndType

Global consolelist:TList = New TList

Function ParseText:String(txt:String,n:Int)
	Local temp:String[] = txt.split(" ")
	
	Return temp[n-1]
EndFunction

Function create_console_msg(t:String,cmd_type:String = "",c = False, r = 255,g = 255,blue = 255)
	If Len(t) <> 0 Then
		For Local q:consolechat = EachIn consolelist
			q.y = q.y - 15
		Next

		Local b:consolechat = New consolechat
		b.t = t
		b.x = consoleposx+15
		b.y = consoleposy+165
		
		If c = False Then
			Select cmd_type
				Case "error"
					b.r = 255
					b.g = 0
					b.b = 0
				Case "command"
					b.r = 64
					b.g = 32
					b.b = 255
				Case "success"
					b.r = 0
					b.g = 255
					b.b = 0
				Case "warning"
					b.r = 255
					b.g = 255
					b.b = 0
				Default
					b.r = 255
					b.g = 255
					b.b = 255		
			EndSelect
		Else
			b.r = r
			b.g = g
			b.b = blue
		EndIf
				
		consolelist.addlast(b)
	EndIf
EndFunction

Function DrawText2(t:String,x,y,r,g,b)
	SetImageFont Null
	SetColor 64,64,64
	DrawText t,x+1,y+1
	SetColor r,g,b
	DrawText t,x,y
	
	SetColor 255,255,255
EndFunction


Function consolecommands()
	Local response:String
	Local cmd_type:String
	
	If lastcmd <> "" Then
		Local args = Len(lastcmd.split(" "))
		''if parsetext(lastcmd,1)
		If args > 1 Then
	
			Select Lower(parsetext(lastcmd,1))
				
				Case "/cheats"
					
					If parsetext(lastcmd,2) = "1" Then 
						cheatsenabled = True					
						cmd_type = "command"
					
					ElseIf parsetext(lastcmd,2) = "0" Then 
						cheatsenabled = False
						cmd_type = "command"
					
					Else
						response = "Invalid syntax for '"+lastcmd+"'"
						cmd_type = "error"
					
					EndIf
	
					response = "Cheats set to "+cheatsenabled


	 			Case "/loadmap"
					Local map[,] = loadmap(parsetext(lastcmd,2))
					Local stuff[,] = loadmap(Left(parsetext(lastcmd,2),Len(parsetext(lastcmd,2))-3)+"stf")
					
					If map <> Null Then curmap = map
					If stuff <> Null Then curstuff = stuff
										
				Case "/tp"
					If args = 2 Or args > 3 Then
						response = "Invalid arguments for '"+lastcmd+"'"
						cmd_type = "error"
					ElseIf args = 3
						If cheatsenabled Then
							Local px = Int(parsetext(lastcmd,2))
							Local py = Int(parsetext(lastcmd,3))
							
							xoffset = -px*32
							yoffset = -py*32
							response = "Teleported player to "+px+" "+py
							cmd_type = "command"
						Else
							response = "You do not have permission to use this command"
							cmd_type = "error"							
						EndIf
					EndIf

				Case "/connect"
					
					If args = 3 Then
						If Not GNetConnect(host,parsetext(lastcmd,2),Int(parsetext(lastcmd,3))) Then
							response = "Failed to connect to server"
							cmd_type = "error"
						Else
							response = "Connected to server "+parsetext(lastcmd,2)+" at port "+parsetext(lastcmd,3)
							cmd_type = "success"					
						EndIf
					EndIf
				Case "/setname"
						If Len(parsetext(lastcmd,2)) < 20 Then
							
							Local c = 0
							
							For i = 0 To Len(parsetext(lastcmd,2))
								Select findchar(parsetext(lastcmd,2),i)
									Case "/",";",",","|"
										c = c + 1
								EndSelect
							Next
							
							If c = 0 Then
								plr_name = parsetext(lastcmd,2)						
								SetGNetString localPlayer,SLOT_NAME,plr_name
									
								response = "Set name to "+parsetext(lastcmd,2)
								cmd_type = "command"
							Else
								response = "Name cannot contain special characters"
								cmd_type = "error"
							EndIf
							
						Else
							response = "Names can only be max 20 characters"
							cmd_type = "error"
						EndIf

				Case "/setcolor"
					If args = 4 Then
						Local pr = Byte(parsetext(lastcmd,2))
						Local pg = Byte(parsetext(lastcmd,3))
						Local pb = Byte(parsetext(lastcmd,4))
						
						plr_r = pr
						plr_g = pg
						plr_b = pb
						
						SetGNetInt localPlayer,SLOT_R,plr_r
						SetGNetInt localPlayer,SLOT_G,plr_g
						SetGNetInt localPlayer,SLOT_B,plr_b
						
					EndIf
				Case "/listen"
					If Int(parsetext(lastcmd,2)) > 9999 And Int(parsetext(lastcmd,2) < 99999)
						GAMEPORT = Int(parsetext(lastcmd,2))
						If Not GNetListen(host,GAMEPORT) Then
							response = "Hosting failed"
							cmd_type = "error"
						Else
							response = "Hosting on port "+GAMEPORT
							cmd_type = "success"
						EndIf
					EndIf
							
				Default
					If Left(parsetext(lastcmd,1),1) = "/" Then
						response = "Unknown command '"+lastcmd+"'"
						cmd_type = "error"
					EndIf


			EndSelect

		Else

			Select Lower(parsetext(lastcmd,1))
				Case "/cheats"
					response = "Invalid syntax for '"+lastcmd+"'"
					cmd_type = "error"
					
				Case "/loadmap"
					response = "Invalid syntax for '"+lastcmd+"'"
					cmd_type = "error"
					
				Case "/listen"
					If Not GNetListen(host,GAMEPORT) Then
						response = "Hosting failed"
						cmd_type = "error"
					Else
						response = "Hosting on port "+GAMEPORT
						cmd_type = "success"
					EndIf
					
				Case "/connect"
					If Not GNetConnect(host,"localhost",GAMEPORT) Then
						response = "Failed to connect to server"
						cmd_type = "error"				
					EndIf
					
				Case "/setname"
					response = "You must supply a name"
					cmd_type = "error"
				Default
					If Left(parsetext(lastcmd,1),1) = "/" Then
						response = "Unknown command '"+lastcmd+"'"
						cmd_type = "error"				
					EndIf

			EndSelect
		EndIf
	EndIf
	
	create_console_msg(response,cmd_type)
	
	lastcmd = ""
EndFunction

Function drawconsole()
	SetScale 1,1
	SetColor 128,128,128
	DrawRect consoleposx+8,consoleposy+200,maxchars*TextWidth("W")+2,15
	
	''DrawRect 8,0,maxchars*TextWidth("W")+2,188
	
	cursorblink = cursorblink - 1
	If cursorblink <= 0 Then cursorblink = cursorblinkrate
	
	If cursorblink < cursorblinkrate/2 Then
	 	DrawText2 cmd+cursor,consoleposx+10,consoleposy+200,255,255,255
	Else
		DrawText2 cmd,consoleposx+10,consoleposy+200,255,255,255
	EndIf

	For c:consolechat = EachIn consolelist
		DrawText2 c.t,c.x,c.y,c.r,c.g,c.b
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
		
		''For Local q:consolechat = EachIn consolelist
		''	q.y = q.y - 15
		''Next
				
		''Local b:consolechat = New consolechat
		''b.r = 255
		''b.g = 255
		''b.b = 255
		
		Local chat:String = plr_name+": "+lastcmd
		
		If lastcmd[..1] <> "/" Then SetGNetString(localPlayer,SLOT_CHAT,chat)
		
		''b.t = chat
		''b.x = consoleposx+15
		''b.y = consoleposy+165
		''consolelist.addlast(b)
		
		lastcmd = Trim((lastcmd))
		
		consolecommands()
	EndIf	
EndFunction