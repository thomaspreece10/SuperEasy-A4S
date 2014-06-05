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
Const PROGRAMICON:String = "microcontroller.ico"



'closeup server on exit

Global A4SHelperApp:A4SHelperAppType
A4SHelperApp = New A4SHelperAppType
A4SHelperApp.Run()

Type A4SHelperAppType Extends wxApp 
	Field A4SHelperFrame:A4SHelperFrameType

	
	Method OnInit:Int()	
		wxImage.AddHandler( New wxICOHandler)			

		A4SHelperFrame = A4SHelperFrameType(New A4SHelperFrameType.Create(Null , wxID_ANY, "Arduino Scratch Server Starter", -1, -1, 450, 300))
		
		Return True

	End Method
	
	Method OnExit()
		TProcess.TerminateAll()
		Super.OnExit()
	End Method
	
End Type



Type A4SHelperFrameType Extends wxFrame

	Field PortComboBox:wxComboBox 
	Field ConsoleText:wxTextCtrl 
	Field ServerButton:wxButton
	Field ServerProcess:TProcess

	Method OnInit()

		Local Icon:wxIcon = New wxIcon.CreateFromFile(PROGRAMICON,wxBITMAP_TYPE_ICO)
		Self.SetIcon( Icon )
		
		Local vbox:wxBoxSizer = New wxBoxSizer.Create(wxVERTICAL)		
		Local MainPanel:wxPanel = New wxPanel.Create(Self , - 1)
		Local MainPanelvbox:wxBoxSizer = New wxBoxSizer.Create(wxVERTICAL)		

		
		MainPanel.setbackgroundColour(New wxColour.Create(255,255,255))

		
		Line1hbox:wxBoxSizer = New wxBoxSizer.Create(wxHORIZONTAL)	
		Local PText:wxStaticText = New wxStaticText.Create(MainPanel , wxID_ANY , "Port:" , -1 , -1 , - 1 , - 1 , wxALIGN_LEFT)
		PortComboBox = New wxComboBox.Create(MainPanel , wxID_ANY , "" , Null , - 1 , - 1 , - 1 , - 1 , wxCB_READONLY)
		Local RefreshPortsButton:wxButton = New wxButton.Create(MainPanel , RPB , "Refresh")	

		Line1hbox.Add(PText , 0 , wxEXPAND | wxLEFT | wxRIGHT | wxTOP , 4 )
		Line1hbox.Add(PortComboBox , 1 , wxEXPAND | wxLEFT | wxRIGHT | wxTOP , 4 )
		Line1hbox.Add(RefreshPortsButton , 0 , wxEXPAND | wxLEFT | wxRIGHT | wxTOP , 4 )
		MainPanelvbox.AddSizer(Line1hbox, 0 , wxEXPAND | wxLEFT | wxRIGHT | wxTOP , 4 )

		ConsoleText = New wxTextCtrl.Create(MainPanel, wxID_ANY , "" , -1 , -1 , -1 , -1 , wxTE_MULTILINE | wxTE_READONLY )	
		MainPanelvbox.Add(ConsoleText , 1 , wxEXPAND | wxLEFT | wxRIGHT | wxTOP , 4 )
		
		ServerButton = New wxButton.Create(MainPanel , SSB , "Start")	
		MainPanelvbox.Add(ServerButton , 0 , wxEXPAND | wxALL , 4 )
		
					
		MainPanel.SetSizer(MainPanelvbox)
		vbox.Add(MainPanel , 1 , wxEXPAND | wxLEFT | wxRIGHT | wxBOTTOM , 0 )		
		Self.SetSizer(vbox)
		
		Self.UpdatePorts()
		Self.center()
		Self.show()		
		
		Connect(RPB , wxEVT_COMMAND_BUTTON_CLICKED , UpdatePortsFun)
		Connect(SSB , wxEVT_COMMAND_BUTTON_CLICKED , UpdateServerFun)
			
	End Method
	

	
	Function UpdatePortsFun(event:wxEvent)
		Local A4SHelperFrame:A4SHelperFrameType = A4SHelperFrameType(event.parent)
		A4SHelperFrame.UpdatePorts()
	End Function
	
	Function UpdateServerFun(event:wxEvent)
		Local A4SHelperFrame:A4SHelperFrameType = A4SHelperFrameType(event.parent)
		
		If A4SHelperFrame.ServerButton.GetLabel() = "Start" Then
			A4SHelperFrame.ConsoleText.Clear()
			Local Port:String = A4SHelperFrame.PortComboBox.GetValue()
			Local MessageBox:wxMessageDialog 
			If Port = "" Or Port = " " Then
				MessageBox = New wxMessageDialog.Create(Null , "Please Select a Port" , "Error" , wxOK | wxICON_ERROR)
				MessageBox.ShowModal()
				MessageBox.Free()	
				Return 
			EndIf 
			A4SHelperFrame.ProcessServer(Port)
		Else
			TerminateProcess(A4SHelperFrame.ServerProcess)
		EndIf 
		
		
	End Function 
	
	Method ProcessServer(Port:String)
		ServerButton.SetLabel("Stop")
		Self.EnableCloseButton(False)
		
		Self.ConsoleText.AppendText("Running Server on "+Port+" ~n")
		Self.ServerProcess = createprocess("java -d32 -jar A4S.jar "+Port)
		Local s:String
		
		Repeat
			If ProcessStatus(ServerProcess)=1 Then 
				While ServerProcess.pipe.readavail()
					s=ServerProcess.pipe.ReadLine().Trim()
					If Instr(s,"Ready") Then
						ConsoleText.AppendText("~nServer is ready, you may now start scratch. ~n~n")
						ConsoleText.AppendText("To load the arduino blocks into scratch please open the ImportBlocks.sb2 file in Scratch. ~nThis can be done by going to File->Open in the offline Scratch Editor ~nor by File->'Upload from your Computer' in the online editor. ~n~n~n~n~n~n")
					Else
						ConsoleText.AppendText(s+" ~n ")
					EndIf 
					
				Wend
			Else	
				Exit
			EndIf	
			
			A4SHelperApp.Yield()
		Forever
		
		Self.EnableCloseButton(True)
		ServerButton.SetLabel("Start")
		ConsoleText.AppendText("Server Stopped")
		Return		
		
	End Method
	
	Method UpdatePorts()
		ConsoleText.Clear()
		ConsoleText.AppendText("Refreshing Ports... ")
		PortComboBox.Clear()
		Local COMPortsList:TList = GetPorts()
		For Port:String = EachIn COMPortsList
			PortComboBox.Append(Port)
		Next
		PortComboBox.SetSelection(0)
		
		If ListIsEmpty(COMPortsList) Then
			ConsoleText.AppendText("No COM ports found. ~nThis program will not find ports that are currently in use by another program. Please close any open programs that are using the port.~n")		
		Else
			If CountList(COMPortsList)=1 Then
				ConsoleText.AppendText(CountList(COMPortsList)+" COM port found. ~n")
			Else
				ConsoleText.AppendText(CountList(COMPortsList)+" COM ports found. ~n")
			EndIf
		EndIf
	End Method
	
End Type 


Function GetPorts:TList()

	Local COMPortsList:TList = CreateList()
	Local Port:wxSerialPort = wxSerialPort(New wxSerialPort.Create())
	Local a:Int
	
	For a=1 To 9
		If Port.Open("com"+a)=0 Then
			Print "Online: COM"+a
			ListAddLast(COMPortsList,"COM"+a)
			Port.Close()
		Else
			'Print "Offline: COM"+a
		EndIf
	Next
	
	For a=10 To 19
		If Port.Open("\\.\com"+a)=0 Then
			Print "Online: COM"+a
			ListAddLast(COMPortsList,"COM"+a)
			Port.Close()
		Else
			'Print "Offline: COM"+a		
		EndIf
			
	Next
	
	Return COMPortsList

End Function

