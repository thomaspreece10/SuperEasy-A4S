Framework BRL.StandardIO
Import wx.wxApp
Import wx.wxTimer
Import wx.wxStaticText
Import wx.wxTextCtrl
Import wx.wxComboBox
Import wx.wxPanel
Import wx.wxButton
Import wx.wxFrame
Import wx.wxMessageDialog
Import wx.wxNotebook 
Import wx.wxAboutBox

Import BaH.Serial
Import BaH.Volumes

Import brl.linkedlist 
Import pub.freeprocess
Import BRL.Retro
Import BRL.PolledInput
Import BRL.FileSystem
Import BRL.Blitz
Import BRL.System

Import "A4S-helperApp.o"

Const RPB:Int = 1
Const SSB:Int = 2
Const ST:Int = 3
Const RPB2:Int = 4
Const SSB2:Int = 5
Const TLOG:Int =6
Const AID:Int = 7
Const PCB1:Int = 8
Const PCB2:Int = 9
Const BCB:Int = 10
Const TADO:Int = 11
Const BACB:Int = 12
Const BACB2:Int = 13
Const PROGRAMICON:String = "Resources\microcontroller.ico"

Global EXPLAINTEXT1:String
Global EXPLAINTEXT2:String
Global EXPLAINTEXT3:String
Global APPWINTITLE:String
Global APPLOGTITLE:String
Global TAB1:String
Global TAB2:String
Global TAB3:String
Global LABEL1:String
Global LABEL2:String
Global LABEL3:String
Global LABEL4:String
Global LABEL5:String
Global MENU1:String
Global MENU2:String
Global MENU3:String
Global MENU4:String
Global MENU5:String
Global MENU6:String 
Global BUTTON1:String
Global BUTTON2:String
Global BUTTON3:String
Global BUTTON4:String
Global ERROR1:String
Global ERROR2:String
Global ERROR3:String
Global ERROR4:String
Global ERROR5:String
Global ERROR6:String
Global ERROR7:String
Global STATUS1:String
Global STATUS2:String
Global STATUS3:String
Global STATUS4:String
Global STATUS5:String
Global STATUS6:String
Global STATUS7:String
Global STATUS8:String
Global STATUS9:String



If FileType("LanguageFile.txt")=1 Then 
	ReadLanguage = ReadFile("LanguageFile.txt")
	
	ReadLine(ReadLanguage)
	
	EXPLAINTEXT1 = ReadLine(ReadLanguage)
	EXPLAINTEXT2 = ReadLine(ReadLanguage)
	EXPLAINTEXT3 = ReadLine(ReadLanguage)
	
	EXPLAINTEXT1 = Replace(EXPLAINTEXT1,"~~n","~n")
	EXPLAINTEXT2 = Replace(EXPLAINTEXT2,"~~n","~n")
	EXPLAINTEXT3 = Replace(EXPLAINTEXT3,"~~n","~n")			
	
	APPWINTITLE = ReadLine(ReadLanguage)
	APPLOGTITLE = ReadLine(ReadLanguage)
	TAB1 = ReadLine(ReadLanguage)
	TAB2 = ReadLine(ReadLanguage)
	TAB3 = ReadLine(ReadLanguage)
	LABEL1 = ReadLine(ReadLanguage)
	LABEL2 = ReadLine(ReadLanguage)
	LABEL3 = ReadLine(ReadLanguage)
	LABEL4 = ReadLine(ReadLanguage)
	LABEL5 = ReadLine(ReadLanguage)
	MENU1 = ReadLine(ReadLanguage)
	MENU2 = ReadLine(ReadLanguage)
	MENU3 = ReadLine(ReadLanguage)
	MENU4 = ReadLine(ReadLanguage)
	MENU5 = ReadLine(ReadLanguage)
	MENU6 = ReadLine(ReadLanguage)
	BUTTON1 = ReadLine(ReadLanguage)
	BUTTON2 = ReadLine(ReadLanguage)
	BUTTON3 = ReadLine(ReadLanguage)
	BUTTON4 = ReadLine(ReadLanguage)
	ERROR1 = ReadLine(ReadLanguage)
	ERROR2 = ReadLine(ReadLanguage)
	ERROR3 = ReadLine(ReadLanguage)
	ERROR4 = ReadLine(ReadLanguage)
	ERROR5 = ReadLine(ReadLanguage)
	ERROR6 = ReadLine(ReadLanguage)
	ERROR7 = ReadLine(ReadLanguage)
	STATUS1 = ReadLine(ReadLanguage)
	STATUS2 = ReadLine(ReadLanguage)
	STATUS3 = ReadLine(ReadLanguage)
	STATUS4 = ReadLine(ReadLanguage)
	STATUS5 = ReadLine(ReadLanguage)
	STATUS6 = ReadLine(ReadLanguage)
	STATUS7 = ReadLine(ReadLanguage)
	STATUS8 = ReadLine(ReadLanguage)
	STATUS9 = ReadLine(ReadLanguage)
	
	CloseFile(ReadLanguage)
Else
	EXPLAINTEXT1 = "Firstly we need to install the drivers of our Arduino board. If you have already done this before please proceed to step 2. Also if you are in a school this may have already been done for you, please confirm with your teacher as to whether you need to do this step.~n~n"+..
	"INSTRUCTIONS ~n~n"+..
	"A) Plug one end of your USB cable into the Arduino and the other into a USB socket on your computer. The power light on the LED will light up and you may get a 'Found New Hardware' message from Windows. Ignore this message and cancel any attempts that Windows makes to try and install drivers automatically for you.~n~n"+..
	"B) We now load up the Device Manager. This is accessed in different ways depending on your version of Windows. In Windows Vista/7, you first have to open the Control Panel, then select View by: 'Large icons', and you should find 'Device Manager' in the list. In Windows XP, first open Control Panel then click 'Administrative Tools' then 'Computer Management' and then select 'Device Manager' from the list on the left.~n~n"+..
	"C) Under the section 'Other Devices' you should see an icon for 'unknown device' with a little yellow warning triangle next to it. This is your Arduino.~n~n"+..
	"D) Right-click on the device and select the top menu option (Update Driver Software...). You will then be prompted in Windows Vista/7 to either 'Search Automatically for updated driver software' or 'Browse my computer for driver software'. Or prompted in Windows XP to 'Install the software automatically' or 'Install from a list or specific location'. Select the option 'Browse my computer for driver software'/'Install from a list or specific location' and navigate to the drivers folder contained within this programs folder.~n~n"+..
	"E) Click 'Next' and you may get a security warning, if so, allow the software to be installed. Once the software has been installed, you will get a confirmation message.~n~n"+..
	"F) Now proceed to step 2.~n~n"+..
	"[Credit for the above text goes to: https://learn.adafruit.com/lesson-0-getting-started/installing-arduino-windows]"
	
	EXPLAINTEXT2 = "Before we can use Arduino in Scratch we must upload some instructions to our Arduino so Scratch can communicate with the Arduino properly. Note if you have already done this step in the past with the Arduino you currently have plugged in you do not need to do it again (unless you have uploaded some different code to it since you last used this program) so you can go straight to step 2. ~n~n"+ ..
	"INSTRUCTIONS ~n~n"+..
	"A) Firstly select the COM port your Arduino is plugged into, there is often only 1 selectable port so that is most likely your Arduino. If you select the wrong COM port the program will fail to upload so a trial and error approach may work to find out which COM port your Arduino is.~n~n"+..
	"B) Next select the model of your Arduino board. It should say the model name on the actual board itself.~n~n"+..
	"C) Finally click upload and wait for the 'Status of Upload' to say finished then move onto step 2"
	EXPLAINTEXT3 = "Now we need to start the helper application that communicates between the Arduino and scratch. This must be running the whole time while you are using Arduino in your scratch sketch.~n~n"+..
	"INSTRUCTIONS ~n~n"+..
	"A) As in step 2, select the COM port your Arduino is plugged into, there is often only 1 selectable port so that is most likely your Arduino. If you select the wrong COM port the program will fail to upload so a trial and error approach may work to find out which COM port your Arduino is. ~n~n"+..
	"B) Now click Start Helper App and wait for 'Status of Helper App' to say 'Started!'~n~n"+..
	"C) Now open Scratch. To load the Arduino blocks into scratch please open the ImportBlocks.sb2 file in Scratch. ~n"+..
	"This can be done by going To File->Open in the offline Scratch Editor Or by File->'Upload from your Computer' in the online editor."
	APPWINTITLE = "Arduino Scratch Server Starter"
	APPLOGTITLE = "Log"
	
	TAB1 = "Step 1 - Arduino Driver"
	TAB2 = "Step 2 - Uploading"
	TAB3 = "Step 3 - Start Server"
	LABEL1 = "Port: "
	LABEL2 = "Refresh"
	LABEL3 = "Board: "
	LABEL4 = "Status of Upload: "
	LABEL5 = "Status of Helper App: "
	MENU1 = "&Quit"
	MENU2 = "&Debug Log"
	MENU3 = "&File"
	MENU4 = "&View"
	MENU5 = "&About"
	MENU6 = "&Toggle Advanced Options"
	BUTTON1 = "Start Upload"
	BUTTON2 = "Finished Upload. Upload Again?"
	BUTTON3 = "Stop"
	BUTTON4 = "Start Helper App"
	
	ERROR1 = "Please Select a Port and Board"
	ERROR2 = "Closing now may cause damage to your Arduino if you do not wait for it to finish. Do you still wish to close?"
	ERROR3 = "Please Select a Port"
	ERROR4 = "Helper App could not start. Please make sure you have java installed on your system!"
	ERROR5 = "ArduinoUploader could not start."
	ERROR6 = "Error"
	ERROR7 = "Failed to generate Firmata code"
	
	STATUS1 = "Not Started Yet"
	STATUS2 = "Stopped"
	STATUS3 = "Stopped By User"
	STATUS4 = "Error (see log)"
	STATUS5 = "Finished"
	STATUS6 = "Uploading..."
	STATUS7 = "Compiling..."
	STATUS8 = "Started!"
	STATUS9 = "Starting..."	

EndIf 

Global PortSelection:Int = 0
Global BoardSelection:Int = 0
Global BaudSelection:Int = 9

'Check if settings file available

If FileType(GetUserAppDir()+"\A4S")=2 Then
	'Continue
Else
	'Create Directory
	CreateDir(GetUserAppDir()+"\A4S")
	'Check that directory actually created
	If FileType(GetUserAppDir()+"\A4S")=2 Then
		'Continue
	Else	
		Notify("Error Creating User Folder",True)
		Return 
	EndIf
EndIf 

If FileType(GetUserAppDir()+"\A4S\Settings.txt")=1 Then 
	'Continue
Else 
	'CreateFile
	UpdateSettings()
	If FileType(GetUserAppDir()+"\A4S\Settings.txt")=1 Then 
	
	Else
		Notify("Error Creating User settings file",True)
		Return 		
	EndIf
EndIf

Local SettingsFile:TStream 
SettingsFile = ReadFile(GetUserAppDir()+"\A4S\Settings.txt")
PortSelection = Int(ReadLine(SettingsFile))
BoardSelection = Int(ReadLine(SettingsFile))
BaudSelection = Int(ReadLine(SettingsFile))
CloseFile(SettingsFile)


Global BOARDCHOICES:String[] = ["1 - Arduino Uno","2 - Arduino Leonardo","3 - Arduino Esplora","4 - Arduino Micro","5 - Arduino Duemilanove (328)","6 - Arduino Duemilanove (168)","7 - Arduino Nano (328)","8 - Arduino Nano (168)","9 - Arduino Mini (328)","10 - Arduino Mini (168)","11 - Arduino Pro Mini (328)","12 - Arduino Pro Mini (168)","13 - Arduino Mega 2560/ADK","14 - Arduino Mega 1280","15 - Arduino Mega 8","16 - Microduino Core+ (644)","17 - Freematics OBD-II Adapter"]
Global BAUDCHOICES:String[] = ["300","1200","2400", "4800", "9600", "14400", "19200", "28800", "38400", "57600", "115200"]

Global A4SHelperApp:A4SHelperAppType
A4SHelperApp = New A4SHelperAppType
A4SHelperApp.Run()

Type A4SHelperAppType Extends wxApp 
	Field A4SHelperFrame:A4SHelperFrameType

	
	Method OnInit:Int()	
		wxImage.AddHandler( New wxICOHandler)			

		A4SHelperFrame = A4SHelperFrameType(New A4SHelperFrameType.Create(Null , wxID_ANY, APPWINTITLE, -1, -1, 600, 490))
		
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
	Field BaudComboBox:wxComboBox 
	Field BaText:wxStaticText

	Field UploadButton:wxButton 
	
	Field PortComboBox2:wxComboBox 	
	Field ServerButton:wxButton
	Field BaudComboBox2:wxComboBox 
	Field BaText2:wxStaticText	
	Field UploadProcess:TProcess
	Field ServerProcess:TProcess

	Field StatusText:wxStaticText	
	Field StatusText2:wxStaticText
	
	Field A4SHelperLog:A4SHelperLogType
	Field MenuBar:wxMenuBar
	
	Field AdvancedOptionsShown = True   

	Method OnInit()	
		MenuBar = New wxMenuBar.Create()
		Local FileMenu:wxMenu = New wxMenu.Create()
		FileMenu.Append(AID, MENU5)
		FileMenu.Append(wxID_CLOSE, MENU1)
		
		Local ViewMenu:wxMenu = New wxMenu.Create()
		ViewMenu.Append(TLOG, MENU2)
		ViewMenu.Append(TADO, MENU6)
		MenuBar.Append(FileMenu, MENU3)
		MenuBar.Append(ViewMenu, MENU4)
		Self.SetMenuBar(MenuBar)
		

		 
		A4SHelperLog = A4SHelperLogType(New A4SHelperLogType.Create(Null , wxID_ANY, APPLOGTITLE, -1, -1, 600, 450))

		Local Icon:wxIcon = New wxIcon.CreateFromFile(PROGRAMICON,wxBITMAP_TYPE_ICO)
		Self.SetIcon( Icon )
		
		Local vbox:wxBoxSizer = New wxBoxSizer.Create(wxVERTICAL)		
		
		Local Tabs:wxNotebook = New wxNotebook.Create(Self, wxID_ANY , -1 , -1 , -1 , -1 , 0)


		Local DriverPanel:wxPanel = New wxPanel.Create(Tabs , - 1)
		Local DriverPanelvbox:wxBoxSizer = New wxBoxSizer.Create(wxVERTICAL)	

	
		Local S1_TextPanel:wxPanel = New wxPanel.Create(DriverPanel , - 1)
		Local S1_TextPanelvbox:wxBoxSizer = New wxBoxSizer.Create(wxVERTICAL)	
		Local S1_ExplainText1:wxTextCtrl = 	New wxTextCtrl.Create(S1_TextPanel , wxID_ANY , EXPLAINTEXT1 , -1 , -1 , - 1 , - 1 , wxTE_MULTILINE| wxTE_READONLY)
		
		'S1_ExplainText1.setbackgroundcolour(New wxColour.createcolour(255,255,240))
		
		S1_TextPanel.setbackgroundcolour(New wxColour.createcolour(240,240,240))
		S1_TextPanelvbox.Add(S1_ExplainText1 , 1 , wxEXPAND | wxALL , 4 )
		S1_TextPanel.SetSizer(S1_TextPanelvbox)
		
		DriverPanelvbox.Add(S1_TextPanel , 1 , wxEXPAND | wxALL , 4 )

		DriverPanel.SetSizer(DriverPanelvbox)

		
		Tabs.AddPage(DriverPanel,TAB1)
		
		
		Local UploadPanel:wxPanel = New wxPanel.Create(Tabs , - 1)
		Local UploadPanelvbox:wxBoxSizer = New wxBoxSizer.Create(wxVERTICAL)	
		
		Local S2_TextPanel:wxPanel = New wxPanel.Create(UploadPanel , - 1)
		Local S2_TextPanelvbox:wxBoxSizer = New wxBoxSizer.Create(wxVERTICAL)	
		Local S2_ExplainText1:wxTextCtrl = 	New wxTextCtrl.Create(S2_TextPanel , wxID_ANY , EXPLAINTEXT2 , -1 , -1 , - 1 , - 1 , wxTE_MULTILINE| wxTE_READONLY )
		
		'S2_ExplainText1.setbackgroundcolour(New wxColour.createcolour(255,255,240))
		S2_TextPanel.setbackgroundcolour(New wxColour.createcolour(240,240,240))
		S2_TextPanelvbox.Add(S2_ExplainText1 , 1 , wxEXPAND | wxALL , 4 )
		S2_TextPanel.SetSizer(S2_TextPanelvbox)
		
		

		Line1hbox:wxBoxSizer = New wxBoxSizer.Create(wxHORIZONTAL)	
		Local PText:wxStaticText = New wxStaticText.Create(UploadPanel , wxID_ANY , LABEL1 , -1 , -1 , - 1 , - 1 , wxALIGN_LEFT)
		PortComboBox = New wxComboBox.Create(UploadPanel , PCB1 , "" , Null , - 1 , - 1 , - 1 , - 1 , wxCB_READONLY)
		Local RefreshPortsButton:wxButton = New wxButton.Create(UploadPanel , RPB , LABEL2)	

		Line1hbox.Add(PText , 0 , wxEXPAND | wxLEFT | wxRIGHT | wxTOP , 4 )
		Line1hbox.Add(PortComboBox , 1 , wxEXPAND | wxLEFT | wxRIGHT | wxTOP , 4 )
		Line1hbox.Add(RefreshPortsButton , 0 , wxEXPAND | wxLEFT | wxRIGHT | wxTOP , 4 )
		
		Line2hbox:wxBoxSizer = New wxBoxSizer.Create(wxHORIZONTAL)	
		Local BText:wxStaticText = New wxStaticText.Create(UploadPanel , wxID_ANY , LABEL3 , -1 , -1 , - 1 , - 1 , wxALIGN_LEFT)
		BoardComboBox = New wxComboBox.Create(UploadPanel , BCB , BOARDCHOICES[BoardSelection] , BOARDCHOICES , - 1 , - 1 , - 1 , - 1 , wxCB_READONLY)		
		
		Line2hbox.Add(BText , 0 , wxEXPAND | wxLEFT | wxRIGHT | wxTOP , 4 )
		Line2hbox.Add(BoardComboBox , 1 , wxEXPAND | wxLEFT | wxRIGHT | wxTOP , 4 )		
		
		UploadPanelvbox.Add(S2_TextPanel , 10 , wxEXPAND | wxALL , 4 )
		UploadPanelvbox.AddSizer(Line1hbox, 0 , wxEXPAND | wxLEFT | wxRIGHT | wxTOP , 4 )
		UploadPanelvbox.AddSizer(Line2hbox, 0 , wxEXPAND | wxLEFT | wxRIGHT | wxTOP , 4 )
		
		Line4hbox:wxBoxSizer = New wxBoxSizer.Create(wxHORIZONTAL)	
		BaText = New wxStaticText.Create(UploadPanel , wxID_ANY , "Baud Rate: " , -1 , -1 , - 1 , - 1 , wxALIGN_LEFT)
		BaudComboBox = New wxComboBox.Create(UploadPanel , BACB , BAUDCHOICES[BaudSelection] , BAUDCHOICES , - 1 , - 1 , - 1 , - 1 , wxCB_READONLY)		
		
		Line4hbox.Add(BaText , 0 , wxEXPAND | wxLEFT | wxRIGHT | wxTOP , 4 )
		Line4hbox.Add(BaudComboBox , 1 , wxEXPAND | wxLEFT | wxRIGHT | wxTOP , 4 )	
		UploadPanelvbox.AddSizer(Line4hbox, 0 , wxEXPAND | wxALL , 4 )	
		
		Line3hbox:wxBoxSizer = New wxBoxSizer.Create(wxHORIZONTAL)
		Local SText:wxStaticText = New wxStaticText.Create(UploadPanel , wxID_ANY , LABEL4 , -1 , -1 , - 1 , - 1 , wxALIGN_LEFT)
		StatusText:wxStaticText = New wxStaticText.Create(UploadPanel , wxID_ANY , "" , -1 , -1 , - 1 , - 1 , wxALIGN_LEFT)
		StatusText.SetLabel(STATUS1)
		StatusText.SetForegroundColour(New wxColour.createcolour(255,0,0))	
		
		Line3hbox.Add(SText , 0 , wxEXPAND | wxLEFT | wxRIGHT | wxTOP , 4 )
		Line3hbox.Add(StatusText , 1 , wxEXPAND | wxLEFT | wxRIGHT | wxTOP , 4 )
		UploadPanelvbox.AddSizer(Line3hbox, 0 , wxEXPAND | wxALL , 4 )		



		


		UploadButton = New wxButton.Create(UploadPanel , SSB , BUTTON1)
		UploadButton.setbackgroundcolour(New wxColour.createcolour(70,255,140))
		Local UploadFont:wxFont = UploadButton.GetFont()
		UploadFont.SetPointSize(12)
		UploadButton.setfont(UploadFont) 

		
		UploadPanelvbox.Add(UploadButton , 0 , wxEXPAND | wxALL , 4 )
	
		UploadPanel.SetSizer(UploadPanelvbox)
		
		Tabs.AddPage(UploadPanel,TAB2)
		
				
		
		Local MainPanel:wxPanel = New wxPanel.Create(Tabs , - 1)
		Local MainPanelvbox:wxBoxSizer = New wxBoxSizer.Create(wxVERTICAL)		

		Local S3_TextPanel:wxPanel = New wxPanel.Create(MainPanel , - 1)
		Local S3_TextPanelvbox:wxBoxSizer = New wxBoxSizer.Create(wxVERTICAL)	
		Local S3_ExplainText2:wxTextCtrl = 	New wxTextCtrl.Create(S3_TextPanel , wxID_ANY , EXPLAINTEXT3 , -1 , -1 , - 1 , - 1 , wxTE_MULTILINE| wxTE_READONLY )
		
		S3_TextPanel.setbackgroundcolour(New wxColour.createcolour(240,240,240))
		S3_TextPanelvbox.Add(S3_ExplainText2 , 1 , wxEXPAND | wxALL , 4 )
		S3_TextPanel.SetSizer(S3_TextPanelvbox)

		'S3_ExplainText2.setbackgroundcolour(New wxColour.createcolour(255,255,240))
		
		MainPanelvbox.Add(S3_TextPanel , 7 , wxEXPAND | wxALL , 4 )
		
		Line1hbox2:wxBoxSizer = New wxBoxSizer.Create(wxHORIZONTAL)	
		Local PText2:wxStaticText = New wxStaticText.Create(MainPanel , wxID_ANY , LABEL1 , -1 , -1 , - 1 , - 1 , wxALIGN_LEFT)
		PortComboBox2 = New wxComboBox.Create(MainPanel , PCB2 , "" , Null , - 1 , - 1 , - 1 , - 1 , wxCB_READONLY)
		Local RefreshPortsButton2:wxButton = New wxButton.Create(MainPanel , RPB2 , LABEL2)	

		Line1hbox2.Add(PText2 , 0 , wxEXPAND | wxLEFT | wxRIGHT | wxTOP , 4 )
		Line1hbox2.Add(PortComboBox2 , 1 , wxEXPAND | wxLEFT | wxRIGHT | wxTOP , 4 )
		Line1hbox2.Add(RefreshPortsButton2 , 0 , wxEXPAND | wxLEFT | wxRIGHT | wxTOP , 4 )
		MainPanelvbox.AddSizer(Line1hbox2, 0 , wxEXPAND | wxLEFT | wxRIGHT | wxTOP , 4 )

		Line3hbox2:wxBoxSizer = New wxBoxSizer.Create(wxHORIZONTAL)	
		BaText2 = New wxStaticText.Create(MainPanel , wxID_ANY , "Baud Rate: " , -1 , -1 , - 1 , - 1 , wxALIGN_LEFT)
		BaudComboBox2 = New wxComboBox.Create(MainPanel , BACB2 , BAUDCHOICES[BaudSelection] , BAUDCHOICES , - 1 , - 1 , - 1 , - 1 , wxCB_READONLY)		
		
		Line3hbox2.Add(BaText2 , 0 , wxEXPAND | wxLEFT | wxRIGHT | wxTOP , 4 )
		Line3hbox2.Add(BaudComboBox2 , 1 , wxEXPAND | wxLEFT | wxRIGHT | wxTOP , 4 )	
		MainPanelvbox.AddSizer(Line3hbox2, 0 , wxEXPAND | wxALL , 4 )	
		
		Line2hbox2:wxBoxSizer = New wxBoxSizer.Create(wxHORIZONTAL)
		Local SText2:wxStaticText = New wxStaticText.Create(MainPanel , wxID_ANY , LABEL5 , -1 , -1 , - 1 , - 1 , wxALIGN_LEFT)
		StatusText2:wxStaticText = New wxStaticText.Create(MainPanel , wxID_ANY , "" , -1 , -1 , - 1 , - 1 , wxALIGN_LEFT)
		StatusText2.SetLabel(STATUS2)
		StatusText2.SetForegroundColour(New wxColour.createcolour(255,0,0))	
		
		Line2hbox2.Add(SText2 , 0 , wxEXPAND | wxLEFT | wxRIGHT | wxTOP , 4 )
		Line2hbox2.Add(StatusText2 , 1 , wxEXPAND | wxLEFT | wxRIGHT | wxTOP , 4 )
		MainPanelvbox.AddSizer(Line2hbox2, 0 , wxEXPAND | wxALL , 4 )
		

		ServerButton = New wxButton.Create(MainPanel , SSB2 , BUTTON4)	
		MainPanelvbox.Add(ServerButton , 0 , wxEXPAND | wxALL , 4 )
		ServerButton.setbackgroundcolour(New wxColour.createcolour(70,255,140))
		Local ServerFont:wxFont = ServerButton.GetFont()
		ServerFont.SetPointSize(12)
		ServerButton.setfont(ServerFont) 
					
		MainPanel.SetSizer(MainPanelvbox)
		
		Tabs.AddPage(MainPanel,TAB3)
		
		
		vbox.Add(Tabs , 1 , wxEXPAND | wxLEFT | wxRIGHT | wxBOTTOM , 0 )		
		Self.SetSizer(vbox)
		
		Self.UpdatePorts()
		Self.center()
		Self.show()		
		If BaudComboBox.GetSelection() = 9 Then 
			Self.ToggleAdvancedOptions()
		EndIf 
		
		Connect(PCB1 , wxEVT_COMMAND_COMBOBOX_SELECTED , PortUpdatedFun , "1")
		Connect(PCB2 , wxEVT_COMMAND_COMBOBOX_SELECTED , PortUpdatedFun , "2")

		Connect(BACB , wxEVT_COMMAND_COMBOBOX_SELECTED , BaudUpdatedFun , "1")
		Connect(BACB2 , wxEVT_COMMAND_COMBOBOX_SELECTED , BaudUpdatedFun , "2")		
		
		Connect(BCB , wxEVT_COMMAND_COMBOBOX_SELECTED , BoardUpdatedFun )		
		
		
		Connect(RPB , wxEVT_COMMAND_BUTTON_CLICKED , UpdatePortsFun)
		Connect(RPB2 , wxEVT_COMMAND_BUTTON_CLICKED , UpdatePortsFun)
		Connect(SSB , wxEVT_COMMAND_BUTTON_CLICKED , UploadFun)
		Connect(SSB2 , wxEVT_COMMAND_BUTTON_CLICKED , ServerFun)
			
		Connect(TLOG , wxEVT_COMMAND_MENU_SELECTED, ShowLogFun)
		Connect(TADO , wxEVT_COMMAND_MENU_SELECTED, ToggleAdvancedOptionsFun)		
		Connect(wxID_CLOSE, wxEVT_COMMAND_MENU_SELECTED, CloseFun)			
		Connect(AID, wxEVT_COMMAND_MENU_SELECTED, AboutFun)	
			
		ConnectAny(wxEVT_CLOSE , CloseFun)
	End Method
	
	Function ToggleAdvancedOptionsFun(event:wxEvent)
		Local A4SHelperFrame:A4SHelperFrameType = A4SHelperFrameType(event.parent)
		A4SHelperFrame.ToggleAdvancedOptions()
	End Function
	
	Method ToggleAdvancedOptions()
		If AdvancedOptionsShown=True Then
			BaudComboBox.show(0)
			BaText.show(0)
			BaudComboBox2.show(0)
			BaText2.show(0)
			AdvancedOptionsShown = False
		Else
			BaudComboBox.show(1)
			BaText.show(1)
			BaudComboBox2.show(1)
			BaText2.show(1)	
			AdvancedOptionsShown = True 
		EndIf 
	End Method
	
	Function BoardUpdatedFun(event:wxEvent)
		Local A4SHelperFrame:A4SHelperFrameType = A4SHelperFrameType(event.parent)
		Local Selection:Int = A4SHelperFrame.BoardComboBox.GetSelection()
		
		If Selection = wxNOT_FOUND Then

		Else
			BoardSelection = Selection
			UpdateSettings()
		EndIf 
		
	End Function

	Function BaudUpdatedFun(event:wxEvent)
		Local A4SHelperFrame:A4SHelperFrameType = A4SHelperFrameType(event.parent)
		Local ComboNum = Int(String(event.userData))
		Local Selection:Int
		
		If ComboNum = 1 Then 
			Selection = A4SHelperFrame.BaudComboBox.GetSelection()
		Else
			Selection = A4SHelperFrame.BaudComboBox2.GetSelection()
		EndIf
		
		If Selection = wxNOT_FOUND Then
		
		Else
			BaudSelection = Selection
			UpdateSettings()
			A4SHelperFrame.BaudComboBox.SetSelection(Selection)
			A4SHelperFrame.BaudComboBox2.SetSelection(Selection)
		EndIf 
		
	End Function
	
	Function PortUpdatedFun(event:wxEvent)
		Local A4SHelperFrame:A4SHelperFrameType = A4SHelperFrameType(event.parent)
		Local ComboNum = Int(String(event.userData))
		Local Selection:Int
		
		If ComboNum = 1 Then 
			Selection = A4SHelperFrame.PortComboBox.GetSelection()
		Else
			Selection = A4SHelperFrame.PortComboBox2.GetSelection()
		EndIf
		
		If Selection = wxNOT_FOUND Then
		
		Else
			PortSelection = Selection
			UpdateSettings()
			A4SHelperFrame.PortComboBox.SetSelection(Selection)
			A4SHelperFrame.PortComboBox2.SetSelection(Selection)
		EndIf 
		
	End Function
	
	Function AboutFun(event:wxEvent)
		Local Icon:wxIcon = New wxIcon.CreateFromFile(PROGRAMICON,wxBITMAP_TYPE_ICO)
		Local Info:wxAboutDialogInfo = New wxAboutDialogInfo.Create()
		Info.seticon(Icon)
		Info.setDescription("This is an application that handles automatically all the complicated parts of using Arduino with Scratch")

		Info.addDeveloper("Thomas Preece")
		Info.addDocWriter("Thomas Preece")
		Info.addDocWriter("Simon Monk")

		Info.setName("A4S")
		Info.setVersion("V1.0")
		Info.setWebsite("http://thomaspreece.com","Lead developers personal website")
		wxAboutBox(Info)
	End Function
	
	Function ShowLogFun(event:wxEvent)
		Local A4SHelperFrame:A4SHelperFrameType = A4SHelperFrameType(event.parent)
		A4SHelperFrame.A4SHelperLog.Show(1)
	End Function
	
	Function CloseFun(event:wxEvent)
		Local A4SHelperFrame:A4SHelperFrameType = A4SHelperFrameType(event.parent)
		If A4SHelperFrame.UploadButton.GetLabel() = BUTTON1 Or A4SHelperFrame.UploadButton.GetLabel() = BUTTON2 Then
			
		Else 
			Local MessageBox:wxMessageDialog 
			MessageBox = New wxMessageDialog.Create(Null, ERROR2 , "Question", wxYES_NO | wxNO_DEFAULT | wxICON_QUESTION)
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
		
		If A4SHelperFrame.UploadButton.GetLabel() = BUTTON1 Or A4SHelperFrame.UploadButton.GetLabel() = BUTTON2 Then
			Local Port:String = A4SHelperFrame.PortComboBox.GetValue()
			Local Board:Int = Int(A4SHelperFrame.BoardComboBox.GetValue())
			Local Baud:String = A4SHelperFrame.BaudComboBox.GetValue()
			Local MessageBox:wxMessageDialog 
			If Port = "" Or Port = " " Or Board=0 Then
				MessageBox = New wxMessageDialog.Create(Null , ERROR1 , ERROR6 , wxOK | wxICON_ERROR)
				MessageBox.ShowModal()
				MessageBox.Free()	
				Return 
			EndIf 
			If Baud = "" Or Baud = " " Then 
				Baud="57600"
			EndIf
			A4SHelperFrame.ProcessUpload(ExtractPort(Port),Board,Baud)
		Else
			MessageBox = New wxMessageDialog.Create(Null, ERROR2 , "Question", wxYES_NO | wxNO_DEFAULT | wxICON_QUESTION)
			If MessageBox.ShowModal() = wxID_YES Then
				A4SHelperFrame.StatusText.SetLabel(STATUS3)
				A4SHelperFrame.A4SHelperLog.AddText("Process Terminated By User~n")	
				TerminateProcess(A4SHelperFrame.UploadProcess)
			EndIf
			MessageBox.Free()	
		EndIf 
		
		
	End Function 
	
	Method ProcessUpload(Port:String,Board:Int,Baud:String)
		Local MessageBox:wxMessageDialog 
		A4SHelperLog.AddText("===============Uploading===============~n")	
		UploadButton.SetLabel(BUTTON3)
		UploadButton.setbackgroundcolour(New wxColour.createcolour(255,100,100))
		A4SHelperLog.AddText("Starting Upload on "+Port+" ~n")
		StatusText.SetLabel("Started")
		StatusText.SetForegroundColour(New wxColour.createcolour(255,140,0))	
		If ModifyFirmataSource(Baud)=1 Then
			MessageBox = New wxMessageDialog.Create(Null , ERROR7 , ERROR6 , wxOK | wxICON_ERROR)
			MessageBox.ShowModal()
			MessageBox.Free()	
			UploadButton.SetLabel(BUTTON1)
			UploadButton.setbackgroundcolour(New wxColour.createcolour(70,255,140))
		
			StatusText.SetLabel(STATUS4)
			StatusText.SetForegroundColour(New wxColour.createcolour(255,0,0))
			A4SHelperLog.AddText("Failed to generate Firmata Source")
			Return
		EndIf
		ChangeDir("ArduinoUploader")
		Self.UploadProcess = createprocess("ArduinoUploader  "+Chr(34)+GetUserAppDir()+"\A4S\StandardFirmata\StandardFirmata.ino"+Chr(34)+" "+Board+" "+Port,1)
		Local s:String
		
		If UploadProcess = Null Then 
			MessageBox = New wxMessageDialog.Create(Null , ERROR5 , ERROR6 , wxOK | wxICON_ERROR)
			MessageBox.ShowModal()
			MessageBox.Free()	
			UploadButton.SetLabel(BUTTON1)
			UploadButton.setbackgroundcolour(New wxColour.createcolour(70,255,140))
		
			StatusText.SetLabel(STATUS4)
			StatusText.SetForegroundColour(New wxColour.createcolour(255,0,0))
			A4SHelperLog.AddText("ArduinoUploader could not start. This probabily means ArduinoUploader.exe is missing or corrupt. Please reinstall ArduinoUploader.~n")
			Return 

		EndIf 
		
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

		If StatusText.GetLabel()=STATUS5 Or StatusText.GetLabel()=STATUS3 Then
		
		Else
			StatusText.SetLabel(STATUS4)
			StatusText.SetForegroundColour(New wxColour.createcolour(255,0,0))
		EndIf 
		UploadButton.SetLabel(BUTTON2)
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
						Status.SetLabel(STATUS5)
						Status.SetForegroundColour(New wxColour.createcolour(0,120,0))							
					ElseIf Instr(Totals,"Writing") Then 
						If Status.GetLabel()=STATUS3 Then 
						
						Else
							Status.SetLabel(STATUS6)
							Status.SetForegroundColour(New wxColour.createcolour(255,140,0))						
						EndIf 
					ElseIf Instr(Totals,"Compiliation") Then
						If Status.GetLabel()=STATUS3 Then 
						
						Else					
							Status.SetLabel(STATUS7)
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
						Status.SetLabel(STATUS8)
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
		A4SHelperFrame.UpdatePorts()
	End Function
	
	Function ServerFun(event:wxEvent)
		Local A4SHelperFrame:A4SHelperFrameType = A4SHelperFrameType(event.parent)
		
		If A4SHelperFrame.ServerButton.GetLabel() = BUTTON4 Then

			Local Port:String = A4SHelperFrame.PortComboBox2.GetValue()
			Local Baud:String = A4SHelperFrame.BaudComboBox2.GetValue()
			Local MessageBox:wxMessageDialog 
			If Port = "" Or Port = " " Then
				MessageBox = New wxMessageDialog.Create(Null , ERROR3 , ERROR6 , wxOK | wxICON_ERROR)
				MessageBox.ShowModal()
				MessageBox.Free()	
				Return 
			EndIf 
			If Baud = "" Or Baud = " " Then
				Baud = "57600"
			EndIf 
			A4SHelperFrame.ProcessServer(ExtractPort(Port),Baud)
		Else
			A4SHelperFrame.A4SHelperLog.AddText("Process Terminated By User~n")	
			A4SHelperFrame.StatusText2.SetLabel("Stopped By User")
			TerminateProcess(A4SHelperFrame.ServerProcess)
		EndIf 
	End Function 
	
	Method ProcessServer(Port:String,Baud:String)
		Local MessageBox:wxMessageDialog 
			
		A4SHelperLog.AddText("===============Starting Helper App===============~n")	
		StatusText2.SetLabel(STATUS9)
		StatusText2.SetForegroundColour(New wxColour.createcolour(255,140,0))
		
		ServerButton.setbackgroundcolour(New wxColour.createcolour(255,100,100))
		ServerButton.SetLabel(BUTTON3)

		
		A4SHelperLog.AddText("Running Helper App on "+Port+" ~n")
		Self.ServerProcess = createprocess("java -d32 -jar A4S.jar "+Port+" "+Baud)
		
		If ServerProcess = Null Then 
			MessageBox = New wxMessageDialog.Create(Null , ERROR4 , ERROR6 , wxOK | wxICON_ERROR)
			MessageBox.ShowModal()
			MessageBox.Free()	
			ServerButton.SetLabel(BUTTON4)
			ServerButton.setbackgroundcolour(New wxColour.createcolour(70,255,140))			
			StatusText2.SetLabel(STATUS4)
			StatusText2.SetForegroundColour(New wxColour.createcolour(255,0,0))
			A4SHelperLog.AddText("Helper App could not start. ~nPlease make sure you have java installed on your system. Also please make sure that the java executable files have been added to PATH environment variable. The PATH variable will be set correctly if you can run java.exe from a commandline. ~n")
			Return 
		EndIf
		
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
		
		If StatusText2.GetLabel()=STATUS8 Or StatusText2.GetLabel()=STATUS3 Then
			StatusText2.SetLabel(STATUS2)
			StatusText2.SetForegroundColour(New wxColour.createcolour(255,0,0))		
		Else
			StatusText2.SetLabel(STATUS4)
			StatusText2.SetForegroundColour(New wxColour.createcolour(255,0,0))
		EndIf 


		ServerButton.SetLabel(BUTTON4)
		ServerButton.setbackgroundcolour(New wxColour.createcolour(70,255,140))

		
		A4SHelperLog.AddText("===============Helper App Stopped===============~n")	
		Return		
		
	End Method
	
	Method UpdatePorts()
		Local COMPortsList:TList = GetPorts()
		A4SHelperLog.AddText("===============Refreshing Ports===============~n")	

	
		PortComboBox.Clear()
		PortComboBox2.Clear()
	
		For Port:String = EachIn COMPortsList
			PortComboBox.Append(Port)
			PortComboBox2.Append(Port)
		Next
		If CountList(COMPortsList)-1<PortSelection Then 
			PortSelection=0
		EndIf 
		
		PortComboBox.SetSelection(PortSelection)
		PortComboBox2.SetSelection(PortSelection)
		
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

Function ExtractPort:String(Text:String)
	For a=1 To Len(Text)
		If Mid(Text,a,1)="-" Then
			Return Left(Text,a-2)
		EndIf 
	Next
End Function

Function GetPorts:TList()
	Local COMPortsList:TList = CreateList()
	Local Ports:TList = TSerial.listPorts()

	For Local Port:TSerialPortInfo = EachIn Ports
		If Left(Port.portName,3)="COM" Then
			ListAddFirst(COMPortsList,Port.portName+" - "+Port.productName)
		EndIf
	Next

	Return COMPortsList
Rem
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
EndRem
End Function


Function UpdateSettings()
	Local SettingsFile:TStream
	SettingsFile = WriteFile(GetUserAppDir()+"\A4S\Settings.txt")
	WriteLine(SettingsFile,PortSelection)
	WriteLine(SettingsFile,BoardSelection)
	WriteLine(SettingsFile,BaudSelection)
	CloseFile(SettingsFile)
End Function

Function ModifyFirmataSource(Baud:String)
	Print "Started"
	If FileType("ArduinoUploader\StandardFirmataTemplate\StandardFirmataTemplate.ino") = 1 Then
	
	Else
		Return 1
	EndIf 
	If FileType(GetUserAppDir()+"\A4S\StandardFirmata")=2 Then
	
	Else
		CreateDir(GetUserAppDir()+"\A4S\StandardFirmata")
	EndIf
	
	Local NewFirmata:TStream
	Local OldFirmata:TStream 
	Local Line:String
	NewFirmata = WriteFile(GetUserAppDir()+"\A4S\StandardFirmata\StandardFirmata.ino")
	OldFirmata = ReadFile("ArduinoUploader\StandardFirmataTemplate\StandardFirmataTemplate.ino")
	Repeat
		Line = ReadLine(OldFirmata)
		If Instr(Line,"##BaudRatePlaceHolder##") Then
			Line = Replace(Line,"##BaudRatePlaceHolder##",Baud)
		EndIf
		WriteLine(NewFirmata,Line)
		If Eof(OldFirmata) Then Exit 
	Forever
	CloseFile(OldFirmata)
	CloseFile(NewFirmata)
	Return 0
End Function

