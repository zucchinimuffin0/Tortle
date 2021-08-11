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


