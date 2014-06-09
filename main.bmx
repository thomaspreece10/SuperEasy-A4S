Framework wx.wxApp
Import wx.wxTimer
Import wx.wxctb 
Import wx.wxStaticText
Import wx.wxTextCtrl
Import wx.wxComboBox
Import wx.wxPanel
Import wx.wxButton
Import wx.wxFrame
Import wx.wxMessageDialog
Import wx.wxNotebook 

Import brl.linkedlist 
Import pub.freeprocess
Import BRL.Retro
Import BRL.PolledInput
Import BRL.FileSystem
Import BRL.StandardIO
Import BRL.Blitz
Import BRL.System

Import "A4S-helperApp.o"

Const RPB:Int = 1
Const SSB:Int = 2
Const ST:Int = 3
Const RPB2:Int = 4
Const SSB2:Int = 5
Const TLOG:Int =6
Const PROGRAMICON:String = "microcontroller.ico"
Const EXPLAINTEXT1:String = "STEP 1: Before we can use Arduino in Scratch we must upload some instructions to our Arduino so Scratch can communicate with the Arduino properly. Note if you have already done this step in the past with the Arduino you currently have plugged in you do not need to do it again (unless you have uploaded some different code to it since you last used this program) so you can go straight to step 2. ~n~n"+ ..
"Firstly select the COM port your Arduino is plugged into, there is often only 1 selectable port so that is most likely your Arduino. If you select the wrong COM port the program will fail to upload so a trial and error approach may work to find out which COM port your Arduino is.~n~n"+..
"Next select the model of your Arduino board. It should say the model name on the actual board itself."+..
"Finally click upload and wait for the 'Status of Upload' to say finished then move onto step 2"

Const EXPLAINTEXT2:String = "STEP 2: Now we need to start the helper application that communicates between the Arduino and scratch. This must be running the whole while you are using Arduino in your scratch sketch.~n~n"+..
"As in step 1, select the COM port your Arduino is plugged into, there is often only 1 selectable port so that is most likely your Arduino. If you select the wrong COM port the program will fail to upload so a trial and error approach may work to find out which COM port your Arduino is. ~n~n"+..
"Now click Start Helper App and wait for 'Status of Helper App' to say 'Started!'~n~n"+..
"Now open Scratch. To load the Arduino blocks into scratch please open the ImportBlocks.sb2 file in Scratch. ~n"+..
"This can be done by going To File->Open in the offline Scratch Editor Or by File->'Upload from your Computer' in the online editor."

Global BOARDCHOICES:String[] = ["1 - Arduino Uno","2 - Arduino Leonardo","3 - Arduino Esplora","4 - Arduino Micro","5 - Arduino Duemilanove (328)","6 - Arduino Duemilanove (168)","7 - Arduino Nano (328)","8 - Arduino Nano (168)","9 - Arduino Mini (328)","10 - Arduino Mini (168)","11 - Arduino Pro Mini (328)","12 - Arduino Pro Mini (168)","13 - Arduino Mega 2560/ADK","14 - Arduino Mega 1280","15 - Arduino Mega 8","16 - Microduino Core+ (644)","17 - Freematics OBD-II Adapter"]

Global A4SHelperApp:A4SHelperAppType
A4SHelperApp = New A4SHelperAppType
A4SHelperApp.Run()

Type A4SHelperAppType Extends wxApp 
	Field A4SHelperFrame:A4SHelperFrameType

	
	Method OnInit:Int()	
		wxImage.AddHandler( New wxICOHandler)			

		A4SHelperFrame = A4SHelperFrameType(New A4SHelperFrameType.Create(Null , wxID_ANY, "Arduino Scratch Server Starter", -1, -1, 600, 380))
		
		Return True

	End Method
	
	Method OnExit()
		TProcess.TerminateAll()
		Super.OnExit()
	End Method
	
End Type



Type A4SHelperFrameType Extends wxFrame

	Field PortComboBox:wxComboBox 
	Field BoardComboBox:wxComboBox 

	Field UploadButton:wxButton 
	
	Field PortComboBox2:wxComboBox 	
	Field ServerButton:wxButton
	Field UploadProcess:TProcess
	Field ServerProcess:TProcess

	Field StatusText:wxStaticText	
	Field StatusText2:wxStaticText
	
	Field A4SHelperLog:A4SHelperLogType
	Field MenuBar:wxMenuBar 

	Method OnInit()	
		MenuBar = New wxMenuBar.Create()
		Local FileMenu:wxMenu = New wxMenu.Create()
		FileMenu.Append(wxID_CLOSE, "&Quit")
		Local ViewMenu:wxMenu = New wxMenu.Create()
		ViewMenu.Append(TLOG, "&Debug Log")
		MenuBar.Append(FileMenu, "&File")
		MenuBar.Append(ViewMenu, "&View")
		Self.SetMenuBar(MenuBar)
		

		 
		A4SHelperLog = A4SHelperLogType(New A4SHelperLogType.Create(Null , wxID_ANY, "Log", -1, -1, 600, 450))

		Local Icon:wxIcon = New wxIcon.CreateFromFile(PROGRAMICON,wxBITMAP_TYPE_ICO)
		Self.SetIcon( Icon )
		
		Local vbox:wxBoxSizer = New wxBoxSizer.Create(wxVERTICAL)		
		
		Local Tabs:wxNotebook = New wxNotebook.Create(Self, wxID_ANY , -1 , -1 , -1 , -1 , 0)

		
		Local UploadPanel:wxPanel = New wxPanel.Create(Tabs , - 1)
		Local UploadPanelvbox:wxBoxSizer = New wxBoxSizer.Create(wxVERTICAL)	
		
		Local S1_TextPanel:wxPanel = New wxPanel.Create(UploadPanel , - 1)
		Local S1_TextPanelvbox:wxBoxSizer = New wxBoxSizer.Create(wxVERTICAL)	
		Local S1_ExplainText1:wxStaticText = 	New wxStaticText.Create(S1_TextPanel , wxID_ANY , EXPLAINTEXT1 , -1 , -1 , - 1 , - 1 , wxALIGN_LEFT)
		
		S1_TextPanel.setbackgroundcolour(New wxColour.createcolour(255,255,255))
		S1_TextPanelvbox.Add(S1_ExplainText1 , 1 , wxEXPAND | wxALL , 4 )
		S1_TextPanel.SetSizer(S1_TextPanelvbox)
		
		

		Line1hbox:wxBoxSizer = New wxBoxSizer.Create(wxHORIZONTAL)	
		Local PText:wxStaticText = New wxStaticText.Create(UploadPanel , wxID_ANY , "Port:" , -1 , -1 , - 1 , - 1 , wxALIGN_LEFT)
		PortComboBox = New wxComboBox.Create(UploadPanel , wxID_ANY , "" , Null , - 1 , - 1 , - 1 , - 1 , wxCB_READONLY)
		Local RefreshPortsButton:wxButton = New wxButton.Create(UploadPanel , RPB , "Refresh")	

		Line1hbox.Add(PText , 0 , wxEXPAND | wxLEFT | wxRIGHT | wxTOP , 4 )
		Line1hbox.Add(PortComboBox , 1 , wxEXPAND | wxLEFT | wxRIGHT | wxTOP , 4 )
		Line1hbox.Add(RefreshPortsButton , 0 , wxEXPAND | wxLEFT | wxRIGHT | wxTOP , 4 )
		
		Line2hbox:wxBoxSizer = New wxBoxSizer.Create(wxHORIZONTAL)	
		Local BText:wxStaticText = New wxStaticText.Create(UploadPanel , wxID_ANY , "Board:" , -1 , -1 , - 1 , - 1 , wxALIGN_LEFT)
		BoardComboBox = New wxComboBox.Create(UploadPanel , wxID_ANY , BOARDCHOICES[0] , BOARDCHOICES , - 1 , - 1 , - 1 , - 1 , wxCB_READONLY)		
		
		Line2hbox.Add(BText , 0 , wxEXPAND | wxLEFT | wxRIGHT | wxTOP , 4 )
		Line2hbox.Add(BoardComboBox , 1 , wxEXPAND | wxLEFT | wxRIGHT | wxTOP , 4 )		
		
		UploadPanelvbox.Add(S1_TextPanel , 10 , wxEXPAND | wxALL , 4 )
		UploadPanelvbox.AddSizer(Line1hbox, 0 , wxEXPAND | wxLEFT | wxRIGHT | wxTOP , 4 )
		UploadPanelvbox.AddSizer(Line2hbox, 0 , wxEXPAND | wxLEFT | wxRIGHT | wxTOP , 4 )
		
		Line3hbox:wxBoxSizer = New wxBoxSizer.Create(wxHORIZONTAL)
		Local SText:wxStaticText = New wxStaticText.Create(UploadPanel , wxID_ANY , "Status of Upload: " , -1 , -1 , - 1 , - 1 , wxALIGN_LEFT)
		StatusText:wxStaticText = New wxStaticText.Create(UploadPanel , wxID_ANY , "" , -1 , -1 , - 1 , - 1 , wxALIGN_LEFT)
		StatusText.SetLabel("Not Started Yet")
		StatusText.SetForegroundColour(New wxColour.createcolour(255,0,0))	
		
		Line3hbox.Add(SText , 0 , wxEXPAND | wxLEFT | wxRIGHT | wxTOP , 4 )
		Line3hbox.Add(StatusText , 1 , wxEXPAND | wxLEFT | wxRIGHT | wxTOP , 4 )
		UploadPanelvbox.AddSizer(Line3hbox, 0 , wxEXPAND | wxALL , 4 )		

		UploadButton = New wxButton.Create(UploadPanel , SSB , "Start Upload")
		UploadButton.setbackgroundcolour(New wxColour.createcolour(70,255,140))
		UploadButton.setfont(New wxFont.CreateWithAttribs(12,0,0,0)) 

		
		UploadPanelvbox.Add(UploadButton , 0 , wxEXPAND | wxALL , 4 )
	
		UploadPanel.SetSizer(UploadPanelvbox)
		
		Tabs.AddPage(UploadPanel,"Step 1 - Upload")
		
				
		
		Local MainPanel:wxPanel = New wxPanel.Create(Tabs , - 1)
		Local MainPanelvbox:wxBoxSizer = New wxBoxSizer.Create(wxVERTICAL)		

		Local S2_TextPanel:wxPanel = New wxPanel.Create(MainPanel , - 1)
		Local S2_TextPanelvbox:wxBoxSizer = New wxBoxSizer.Create(wxVERTICAL)	
		Local S2_ExplainText2:wxStaticText = 	New wxStaticText.Create(S2_TextPanel , wxID_ANY , EXPLAINTEXT2 , -1 , -1 , - 1 , - 1 , wxALIGN_LEFT)
		
		S2_TextPanel.setbackgroundcolour(New wxColour.createcolour(255,255,255))
		S2_TextPanelvbox.Add(S2_ExplainText2 , 1 , wxEXPAND | wxALL , 4 )
		S2_TextPanel.SetSizer(S2_TextPanelvbox)

		MainPanelvbox.Add(S2_TextPanel , 7 , wxEXPAND | wxALL , 4 )
		
		Line1hbox2:wxBoxSizer = New wxBoxSizer.Create(wxHORIZONTAL)	
		Local PText2:wxStaticText = New wxStaticText.Create(MainPanel , wxID_ANY , "Port:" , -1 , -1 , - 1 , - 1 , wxALIGN_LEFT)
		PortComboBox2 = New wxComboBox.Create(MainPanel , wxID_ANY , "" , Null , - 1 , - 1 , - 1 , - 1 , wxCB_READONLY)
		Local RefreshPortsButton2:wxButton = New wxButton.Create(MainPanel , RPB2 , "Refresh")	

		Line1hbox2.Add(PText2 , 0 , wxEXPAND | wxLEFT | wxRIGHT | wxTOP , 4 )
		Line1hbox2.Add(PortComboBox2 , 1 , wxEXPAND | wxLEFT | wxRIGHT | wxTOP , 4 )
		Line1hbox2.Add(RefreshPortsButton2 , 0 , wxEXPAND | wxLEFT | wxRIGHT | wxTOP , 4 )
		MainPanelvbox.AddSizer(Line1hbox2, 0 , wxEXPAND | wxLEFT | wxRIGHT | wxTOP , 4 )


		
		Line2hbox2:wxBoxSizer = New wxBoxSizer.Create(wxHORIZONTAL)
		Local SText2:wxStaticText = New wxStaticText.Create(MainPanel , wxID_ANY , "Status of Helper App: " , -1 , -1 , - 1 , - 1 , wxALIGN_LEFT)
		StatusText2:wxStaticText = New wxStaticText.Create(MainPanel , wxID_ANY , "" , -1 , -1 , - 1 , - 1 , wxALIGN_LEFT)
		StatusText2.SetLabel("Stopped")
		StatusText2.SetForegroundColour(New wxColour.createcolour(255,0,0))	
		
		Line2hbox2.Add(SText2 , 0 , wxEXPAND | wxLEFT | wxRIGHT | wxTOP , 4 )
		Line2hbox2.Add(StatusText2 , 1 , wxEXPAND | wxLEFT | wxRIGHT | wxTOP , 4 )
		MainPanelvbox.AddSizer(Line2hbox2, 0 , wxEXPAND | wxALL , 4 )
		

		ServerButton = New wxButton.Create(MainPanel , SSB2 , "Start Helper App")	
		MainPanelvbox.Add(ServerButton , 0 , wxEXPAND | wxALL , 4 )
		ServerButton.setbackgroundcolour(New wxColour.createcolour(70,255,140))
		ServerButton.setfont(New wxFont.CreateWithAttribs(12,0,0,0)) 

					
		MainPanel.SetSizer(MainPanelvbox)
		
		Tabs.AddPage(MainPanel,"Step 2 - Server")
		
		
		vbox.Add(Tabs , 1 , wxEXPAND | wxLEFT | wxRIGHT | wxBOTTOM , 0 )		
		Self.SetSizer(vbox)
		
		Self.UpdatePorts(1)
		Self.center()
		Self.show()		
		
		Connect(RPB , wxEVT_COMMAND_BUTTON_CLICKED , UpdatePortsFun,"1")
		Connect(RPB2 , wxEVT_COMMAND_BUTTON_CLICKED , UpdatePortsFun,"2")
		Connect(SSB , wxEVT_COMMAND_BUTTON_CLICKED , UploadFun)
		Connect(SSB2 , wxEVT_COMMAND_BUTTON_CLICKED , ServerFun)
			
		Connect(TLOG , wxEVT_COMMAND_MENU_SELECTED, ShowLogFun)
		Connect(wxID_CLOSE, wxEVT_COMMAND_MENU_SELECTED, CloseFun)			
			
		ConnectAny(wxEVT_CLOSE , CloseFun)
	End Method
	
	Function ShowLogFun(event:wxEvent)
		Local A4SHelperFrame:A4SHelperFrameType = A4SHelperFrameType(event.parent)
		A4SHelperFrame.A4SHelperLog.Show(1)
	End Function
	
	Function CloseFun(event:wxEvent)
		Local A4SHelperFrame:A4SHelperFrameType = A4SHelperFrameType(event.parent)
		If A4SHelperFrame.UploadButton.GetLabel() = "Start Upload" Then
			
		Else 
			Local MessageBox:wxMessageDialog 
			MessageBox = New wxMessageDialog.Create(Null, "Closing now may cause damage to your Arduino if you do not wait for it to finish. Do you still wish to close?" , "Question", wxYES_NO | wxNO_DEFAULT | wxICON_QUESTION)
			If MessageBox.ShowModal() = wxID_YES Then
				
			Else
				Return 
			EndIf
		EndIf 

		A4SHelperFrame.A4SHelperLog.Destroy()
		A4SHelperApp.OnExit()
		End 		
		
	End Function 
	
	Function UploadFun(event:wxEvent)
		Local A4SHelperFrame:A4SHelperFrameType = A4SHelperFrameType(event.parent)
		
		If A4SHelperFrame.UploadButton.GetLabel() = "Start Upload" Then
			Local Port:String = A4SHelperFrame.PortComboBox.GetValue()
			Local Board:Int = Int(A4SHelperFrame.BoardComboBox.GetValue())
			Local MessageBox:wxMessageDialog 
			If Port = "" Or Port = " " Or Board=0 Then
				MessageBox = New wxMessageDialog.Create(Null , "Please Select a Port and Board" , "Error" , wxOK | wxICON_ERROR)
				MessageBox.ShowModal()
				MessageBox.Free()	
				Return 
			EndIf 
			A4SHelperFrame.ProcessUpload(Port,Board)
		Else
			MessageBox = New wxMessageDialog.Create(Null, "Cancelling now may cause damage to your Arduino if you do not wait for it to finish. Do you still wish to cancel?" , "Question", wxYES_NO | wxNO_DEFAULT | wxICON_QUESTION)
			If MessageBox.ShowModal() = wxID_YES Then
				A4SHelperFrame.StatusText.SetLabel("Stopped By User")
				A4SHelperFrame.A4SHelperLog.AddText("Process Terminated By User~n")	
				TerminateProcess(A4SHelperFrame.UploadProcess)
			EndIf
			MessageBox.Free()	
		EndIf 
		
		
	End Function 
	
	Method ProcessUpload(Port:String,Board:Int)
		A4SHelperLog.AddText("===============Uploading===============~n")	
		UploadButton.SetLabel("Stop")
		UploadButton.setbackgroundcolour(New wxColour.createcolour(255,100,100))
		A4SHelperLog.AddText("Starting Upload on "+Port+" ~n")
		StatusText.SetLabel("Started")
		StatusText.SetForegroundColour(New wxColour.createcolour(255,140,0))			
		ChangeDir("ArduinoUploader")
		Self.UploadProcess = createprocess("ArduinoUploader  StandardFirmata\StandardFirmata.ino "+Board+" "+Port,1)
		Local s:String
		
		Repeat
			If ProcessStatus(UploadProcess)=1 Then 
				ProcessUploadCMDOutput(UploadProcess,A4SHelperLog,StatusText)
			Else	
				ProcessUploadCMDOutput(UploadProcess,A4SHelperLog,StatusText)
				Delay 100
				Exit
			EndIf	
			
			A4SHelperApp.Yield()
		Forever

		If StatusText.GetLabel()="Finished" Or StatusText.GetLabel()="Stopped By User" Then
		
		Else
			StatusText.SetLabel("Error (see log)")
			StatusText.SetForegroundColour(New wxColour.createcolour(255,0,0))
		EndIf 
		UploadButton.SetLabel("Start Upload")
		UploadButton.setbackgroundcolour(New wxColour.createcolour(70,255,140))
		TerminateProcess(UploadProcess)
		ChangeDir("..")
		
		A4SHelperLog.AddText("~n~n===============Finished Uploading===============~n")	
		Return		
		
	End Method
	
	
	
	Function ProcessUploadCMDOutput(Process:TProcess,Console:A4SHelperLogType,Status:wxStaticText)
		Local s:String
		Local a:Int = 0
		Local Totals:String = ""
		While Process.pipe.readavail() Or Process.err.readavail()	
			While Process.pipe.readavail()
				s=Process.pipe.ReadString (Process.pipe.ReadAvail())
				If EmptyString(s) Then 
				
				Else
					Totals = Totals + s
					If Instr(Totals, "avrdude.exe done.  Thank you.") Then
						Status.SetLabel("Finished")
						Status.SetForegroundColour(New wxColour.createcolour(0,120,0))							
					ElseIf Instr(Totals,"Writing") Then 
						If Status.GetLabel()="Stopped By User" Then 
						
						Else
							Status.SetLabel("Uploading...")
							Status.SetForegroundColour(New wxColour.createcolour(255,140,0))						
						EndIf 
					ElseIf Instr(Totals,"Compiliation") Then
						If Status.GetLabel()="Stopped By User" Then 
						
						Else					
							Status.SetLabel("Compiling...")
							Status.SetForegroundColour(New wxColour.createcolour(255,140,0))	
						EndIf
					EndIf 
					Console.AddText(s)	
				EndIf 
			Wend 
			
			While Process.err.readavail()
				s=Process.err.ReadString (Process.err.ReadAvail())
				If EmptyString(s) Then 
				
				Else
					Console.AddText(s)	
				EndIf	
			Wend
			A4SHelperApp.Yield()
		Wend

		
	End Function
	
	Function EmptyString(Text:String)
		If Text = "" Or Text = " " Then 
			Return 1
		EndIf
		Local Empty=True
		For a=1 To Len(Text)
			If Mid(Text,a,1)=Chr(10) Or Mid(Text,a,1)=" " Then
			
			Else
				Empty = False 
				Exit
			EndIf
		Next
		
		Return Empty
	End Function
	
	Function ProcessServerCMDOutput(Process:TProcess,Console:A4SHelperLogType,Status:wxStaticText)
		Local s:String
		While Process.pipe.readavail() Or Process.err.readavail()
			If Process.pipe.readavail() Then
				s=Process.pipe.ReadString (Process.pipe.ReadAvail())
				If EmptyString(s) Then
				
				Else
					If Instr(s,"Ready") Then
						Status.SetLabel("Started!")
						Status.SetForegroundColour(New wxColour.createcolour(0,120,0))				
						Console.AddText(s+" ~n")
						Console.AddText("Helper App is ready, you may now start scratch. ~n")			
					Else
						Console.AddText(s+" ~n")
					EndIf 		
				EndIf 	
			EndIf
			
			If Process.err.readavail() Then
				s=Process.err.ReadString (Process.err.ReadAvail())
				If EmptyString(s) Then
				
				Else			
					Console.AddText(s+" ~n")		
				EndIf 					
			EndIf 
			A4SHelperApp.Yield()			
		Wend
	End Function	

	Function UpdatePortsFun(event:wxEvent)
		Local A4SHelperFrame:A4SHelperFrameType = A4SHelperFrameType(event.parent)
		Obj:Object = Object(event.userdata)
		Num:Int = Int(String(Obj))
		A4SHelperFrame.UpdatePorts(Num)
	End Function
	
	Function ServerFun(event:wxEvent)
		Local A4SHelperFrame:A4SHelperFrameType = A4SHelperFrameType(event.parent)
		
		If A4SHelperFrame.ServerButton.GetLabel() = "Start Helper App" Then

			Local Port:String = A4SHelperFrame.PortComboBox2.GetValue()
			Local MessageBox:wxMessageDialog 
			If Port = "" Or Port = " " Then
				MessageBox = New wxMessageDialog.Create(Null , "Please Select a Port" , "Error" , wxOK | wxICON_ERROR)
				MessageBox.ShowModal()
				MessageBox.Free()	
				Return 
			EndIf 
			A4SHelperFrame.ProcessServer(Port)
		Else
			A4SHelperFrame.A4SHelperLog.AddText("Process Terminated By User~n")	
			A4SHelperFrame.StatusText2.SetLabel("Stopped By User")
			TerminateProcess(A4SHelperFrame.ServerProcess)
		EndIf 
	End Function 
	
	Method ProcessServer(Port:String)
		A4SHelperLog.AddText("===============Starting Helper App===============~n")	
		StatusText2.SetLabel("Starting...")
		StatusText2.SetForegroundColour(New wxColour.createcolour(255,140,0))
		
		ServerButton.setbackgroundcolour(New wxColour.createcolour(255,100,100))
		ServerButton.SetLabel("Stop")

		
		A4SHelperLog.AddText("Running Helper App on "+Port+" ~n")
		Self.ServerProcess = createprocess("java -d32 -jar A4S.jar "+Port)
		Local s:String
		
		Repeat
			If ProcessStatus(ServerProcess)=1 Then 
				ProcessServerCMDOutput(ServerProcess,A4SHelperLog,StatusText2)
			Else	
				ProcessServerCMDOutput(ServerProcess,A4SHelperLog,StatusText2)		
				Exit
			EndIf	
			
			A4SHelperApp.Yield()
		Forever
		
		If StatusText2.GetLabel()="Started!" Or StatusText2.GetLabel()="Stopped By User" Then
			StatusText2.SetLabel("Stopped")
			StatusText2.SetForegroundColour(New wxColour.createcolour(255,0,0))		
		Else
			StatusText2.SetLabel("Error (see log)")
			StatusText2.SetForegroundColour(New wxColour.createcolour(255,0,0))
		EndIf 


		ServerButton.SetLabel("Start Helper App")
		ServerButton.setbackgroundcolour(New wxColour.createcolour(70,255,140))

		
		A4SHelperLog.AddText("===============Helper App Stopped===============~n")	
		Return		
		
	End Method
	
	Method UpdatePorts(Num)
		Local COMPortsList:TList = GetPorts()
		A4SHelperLog.AddText("===============Refreshing Ports===============~n")	

		
		PortComboBox.Clear()
		PortComboBox2.Clear()
	
		For Port:String = EachIn COMPortsList
			PortComboBox.Append(Port)
			PortComboBox2.Append(Port)
		Next
		PortComboBox.SetSelection(0)
		PortComboBox2.SetSelection(0)
		
		If ListIsEmpty(COMPortsList) Then
			A4SHelperLog.AddText("No COM ports found. ~nThis program will not find ports that are currently in use by another program. Please close any open programs that are using the port.~n")		
		Else
			If CountList(COMPortsList)=1 Then
				A4SHelperLog.AddText(CountList(COMPortsList)+" COM port found. ~n")
			Else
				A4SHelperLog.AddText(CountList(COMPortsList)+" COM ports found. ~n")			
			EndIf
		EndIf
	
		A4SHelperLog.AddText("===============Finished Refreshing Ports===============~n")
	End Method
	
End Type 


Type A4SHelperLogType Extends wxFrame 
	Field LogBox:wxTextCtrl
	
	Method OnInit()
		Local Icon:wxIcon = New wxIcon.CreateFromFile(PROGRAMICON,wxBITMAP_TYPE_ICO)
		Self.SetIcon( Icon )		
		Local hbox:wxBoxSizer = New wxBoxSizer.Create(wxVERTICAL)
		LogBox = New wxTextCtrl.Create(Self, wxID_ANY, "", -1 , -1 , -1 , -1, wxTE_READONLY | wxTE_MULTILINE | wxTE_BESTWRAP)
		hbox.Add(LogBox,  1 , wxEXPAND, 0)		
		SetSizer(hbox)
		Centre()	
		Show(0)	
		ConnectAny(wxEVT_CLOSE , CloseLog)
	End Method
	
	Function CloseLog(event:wxEvent)
		Log1:A4SHelperLogType = A4SHelperLogType(event.parent)
		Log1.Show(0)
	End Function

	Method AddText(Tex:String)
		LogBox.AppendText(Tex)	
	End Method
	
End Type



Function GetPorts:TList()

	Local COMPortsList:TList = CreateList()
	Local Port:wxSerialPort = wxSerialPort(New wxSerialPort.Create())
	Local a:Int
	
	For a=1 To 9
		If Port.Open("com"+a)=0 Then
			ListAddLast(COMPortsList,"COM"+a)
			Port.Close()
		Else

		EndIf
	Next
	
	For a=10 To 19
		If Port.Open("\\.\com"+a)=0 Then
			ListAddLast(COMPortsList,"COM"+a)
			Port.Close()
		Else

		EndIf
			
	Next
	
	Return COMPortsList

End Function


