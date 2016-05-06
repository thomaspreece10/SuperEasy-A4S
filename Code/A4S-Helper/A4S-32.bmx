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
Import BaH.Locale

Import brl.linkedlist 
Import pub.freeprocess
Import BRL.Retro
Import BRL.PolledInput
Import BRL.FileSystem
Import BRL.Blitz
Import BRL.System

?Win32
Import "A4S-helperApp.o"
?

?Linux
Import "-ldl"
?

'Run Java as 32 Bit? 1 = Yes, 0 = No
Const Java32Bit = 1

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
'1000+ reserved for Language menu
?Win32
Const Slash:String="\"
?Not Win32
Const Slash:String="/"
?

Const VERSION:String = "V1.6.1"

?Win32
Global AppResources:String=""
Global UserAppDir:String = GetUserAppDir()
Global UserDocumentsDir:String = GetUserDocumentsDir()
Global PROGRAMICON:String = "Resources"+Slash+"microcontroller.ico"
Global JavaLocation:String = "JRE/bin/java.exe"
?Linux
Global AppResources:String=""
Global UserAppDir:String = GetUserDocumentsDir()
Global UserDocumentsDir:String = GetUserDocumentsDir()
Global PROGRAMICON:String = "Resources"+Slash+"microcontroller.ico"
Global JavaLocation:String = "JRE/bin/java"
?MacOS
Global AppResources:String= ExtractDir(AppFile) + "/../Resources/"
Global UserAppDir:String = GetUserAppDir()
Global UserDocumentsDir:String = GetUserDocumentsDir()
Global PROGRAMICON:String = "microcontroller.ico"
Global JavaLocation:String = ""
?
ChangeDir(AppResources)

LoadLocaleFile("LanguageFile.blf")

SetCurrentLocale(GetDefaultLocale())

Global PortSelection:Int = 0
Global BoardSelection:Int = 0
Global BaudSelection:Int = 9
Global Language:String = ""
Global ShowFirstTab:Int = True
Global ShowSecondTab:Int = True

If FileType("Tabs.txt") = 1 Then 
	Local TabSettingsFile:TStream 
	TabSettingsFile = ReadFile("Tabs.txt")
	ReadLine(TabSettingsFile)
	ReadLine(TabSettingsFile)
	ReadLine(TabSettingsFile)
	ReadLine(TabSettingsFile)
	ShowFirstTab=1-Int(ReadLine(TabSettingsFile))
	ReadLine(TabSettingsFile)
	ShowSecondTab=1-Int(ReadLine(TabSettingsFile))
	CloseFile(TabSettingsFile)
EndIf 

If FileType(UserAppDir+Slash+"SuperEasy-A4S")=2 Then
	'Continue
Else
	'Create Directory
	CreateDir(UserAppDir+Slash+"SuperEasy-A4S")
	'Check that directory actually created
	If FileType(UserAppDir+Slash+"SuperEasy-A4S")=2 Then
		'Continue
	Else	
		Notify("Error Creating User Folder",True)
	EndIf
EndIf 

If FileType(UserAppDir+Slash+"SuperEasy-A4S"+Slash+"Settings.txt")=1 Then 
	'Continue
Else 
	'CreateFile
	UpdateSettings()
	If FileType(UserAppDir+Slash+"SuperEasy-A4S"+Slash+"Settings.txt")=1 Then 
	
	Else
		Notify("Error Creating User settings file",True)	
	EndIf
EndIf

Local SettingsFile:TStream 
SettingsFile = ReadFile(UserAppDir+Slash+"SuperEasy-A4S"+Slash+"Settings.txt")
PortSelection = Int(ReadLine(SettingsFile))
BoardSelection = Int(ReadLine(SettingsFile))
BaudSelection = Int(ReadLine(SettingsFile))
Language = String(ReadLine(SettingsFile))
CloseFile(SettingsFile)

If Language = GetCurrentLocale() Then 
	'Continue
Else
	Local ValidLocales:String[] = GetAvailableLocales()
	Local Locale:String 
	For Locale = EachIn ValidLocales 
		If Language = Locale Then 
			SetCurrentLocale(Language)
			Exit
		EndIf 
	Next
EndIf

Language = GetCurrentLocale()

Global BOARDCHOICES:String[] = ["1 - Arduino Uno","2 - Arduino Leonardo","3 - Arduino Esplora","4 - Arduino Micro","5 - Arduino Duemilanove (328)","6 - Arduino Duemilanove (168)","7 - Arduino Nano (328)","8 - Arduino Nano (168)","9 - Arduino Mini (328)","10 - Arduino Mini (168)","11 - Arduino Pro Mini (328)","12 - Arduino Pro Mini (168)","13 - Arduino Mega 2560/ADK","14 - Arduino Mega 1280","15 - Arduino Mega 8","16 - Microduino Core+ (644)","17 - Freematics OBD-II Adapter"]
Global BAUDCHOICES:String[] = ["300","1200","2400", "4800", "9600", "14400", "19200", "28800", "38400", "57600", "115200"]

Global A4SHelperApp:A4SHelperAppType
A4SHelperApp = New A4SHelperAppType
A4SHelperApp.Run()

Type A4SHelperAppType Extends wxApp 
	Field A4SHelperFrame:A4SHelperFrameType

	
	Method OnInit:Int()	
		wxImage.AddHandler( New wxICOHandler)			

		A4SHelperFrame = A4SHelperFrameType(New A4SHelperFrameType.Create(Null , wxID_ANY, GetLocaleText("AppTitle"), -1, -1, 600, 490))
		
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
		
		?Not Win32
		Local MessageBox:wxMessageDialog 
		
		CreateSb2Status = CreateSb2Files()
		
		If CreateSb2Status = 1 Then 
			MessageBox = New wxMessageDialog.Create(Null , GetLocaleText("ErrorFindScratchFiles") , GetLocaleText("StatusError") , wxOK | wxICON_ERROR)
			MessageBox.ShowModal()
			MessageBox.Free()	
			Return
		ElseIf CreateSb2Status = 2 Then
			MessageBox = New wxMessageDialog.Create(Null , GetLocaleText("ErrorCopyScratchFiles") , GetLocaleText("StatusError") , wxOK | wxICON_ERROR)
			MessageBox.ShowModal()
			MessageBox.Free()	
			Return
		EndIf 
		
		?	
			
		MenuBar = New wxMenuBar.Create()
		Local FileMenu:wxMenu = New wxMenu.Create()
		FileMenu.Append(AID, GetLocaleText("MenuAbout"))
		FileMenu.Append(wxID_CLOSE, GetLocaleText("MenuQuit"))
		
		Local ViewMenu:wxMenu = New wxMenu.Create()
		ViewMenu.Append(TLOG, GetLocaleText("MenuDebugLog"))
		ViewMenu.Append(TADO, GetLocaleText("MenuTAdvOpt"))
	
		Local LanguageMenu:wxMenu = New wxMenu.Create()
		Local AvailableLocales:String[] = GetAvailableLocales()
		Local Locale:String
		Local i:Int = 0 
		For Locale = EachIn AvailableLocales
			LanguageMenu.Append(1000+i,Locale+" - "+GetLanguage(Locale))
			Connect(1000+i , wxEVT_COMMAND_MENU_SELECTED , SetLanguageFun, Locale)
			i=i+1
		Next 
		
		
		MenuBar.Append(FileMenu, GetLocaleText("MenuFile"))
		MenuBar.Append(ViewMenu, GetLocaleText("MenuView"))
		MenuBar.Append(LanguageMenu, GetLocaleText("MenuLanguage"))		
		Self.SetMenuBar(MenuBar)
		

		 
		A4SHelperLog = A4SHelperLogType(New A4SHelperLogType.Create(Null , wxID_ANY, GetLocaleText("AppLogTitle"), -1, -1, 600, 450))

		Local Icon:wxIcon = New wxIcon.CreateFromFile(PROGRAMICON,wxBITMAP_TYPE_ICO)
		Self.SetIcon( Icon )
		
		Local vbox:wxBoxSizer = New wxBoxSizer.Create(wxVERTICAL)		
		
		Local Tabs:wxNotebook = New wxNotebook.Create(Self, wxID_ANY , -1 , -1 , -1 , -1 , 0)


		Local DriverPanel:wxPanel = New wxPanel.Create(Tabs , - 1)
		Local DriverPanelvbox:wxBoxSizer = New wxBoxSizer.Create(wxVERTICAL)	

		
		Local S1_TextPanel:wxPanel = New wxPanel.Create(DriverPanel , - 1)
		Local S1_TextPanelvbox:wxBoxSizer = New wxBoxSizer.Create(wxVERTICAL)
		
			
			
		?Win32
		Local S1_ExplainText1:wxTextCtrl = 	New wxTextCtrl.Create(S1_TextPanel , wxID_ANY , GetLocaleText("Tab1ExplainText_WIN") , -1 , -1 , - 1 , - 1 , wxTE_MULTILINE| wxTE_READONLY)
		?Mac
		Local S1_ExplainText1:wxTextCtrl = 	New wxTextCtrl.Create(S1_TextPanel , wxID_ANY , GetLocaleText("Tab1ExplainText_MAC") , -1 , -1 , - 1 , - 1 , wxTE_MULTILINE| wxTE_READONLY)		
		?Linux
		Local S1_ExplainText1:wxTextCtrl = 	New wxTextCtrl.Create(S1_TextPanel , wxID_ANY , GetLocaleText("Tab1ExplainText_LIN") , -1 , -1 , - 1 , - 1 , wxTE_MULTILINE| wxTE_READONLY)
		?		
		'S1_ExplainText1.setbackgroundcolour(New wxColour.createcolour(255,255,240))
		
		S1_TextPanel.setbackgroundcolour(New wxColour.createcolour(240,240,240))
		S1_TextPanelvbox.Add(S1_ExplainText1 , 1 , wxEXPAND | wxALL , 4 )
		S1_TextPanel.SetSizer(S1_TextPanelvbox)
		
		DriverPanelvbox.Add(S1_TextPanel , 1 , wxEXPAND | wxALL , 4 )

		DriverPanel.SetSizer(DriverPanelvbox)
		
		Local TabNumber:Int = 1

		If ShowFirstTab=True Then 
			?Win32
			Tabs.AddPage(DriverPanel,GetLocaleText("TabStep")+" "+TabNumber+" "+GetLocaleText("Tab1_WIN"))
			?Mac
			Tabs.AddPage(DriverPanel,GetLocaleText("TabStep")+" "+TabNumber+" "+GetLocaleText("Tab1_MAC"))		
			?Linux
			Tabs.AddPage(DriverPanel,GetLocaleText("TabStep")+" "+TabNumber+" "+GetLocaleText("Tab1_LIN"))
			?
			TabNumber = TabNumber + 1
		EndIf
 
		
		Local UploadPanel:wxPanel = New wxPanel.Create(Tabs , - 1)
		Local UploadPanelvbox:wxBoxSizer = New wxBoxSizer.Create(wxVERTICAL)	
		
		Local S2_TextPanel:wxPanel = New wxPanel.Create(UploadPanel , - 1)
		Local S2_TextPanelvbox:wxBoxSizer = New wxBoxSizer.Create(wxVERTICAL)	
		
		?Win32
		Local S2_ExplainText1:wxTextCtrl = 	New wxTextCtrl.Create(S2_TextPanel , wxID_ANY , GetLocaleText("Tab2ExplainText_WIN") , -1 , -1 , - 1 , - 1 , wxTE_MULTILINE| wxTE_READONLY )
		?Mac
		Local S2_ExplainText1:wxTextCtrl = 	New wxTextCtrl.Create(S2_TextPanel , wxID_ANY , GetLocaleText("Tab2ExplainText_MAC") , -1 , -1 , - 1 , - 1 , wxTE_MULTILINE| wxTE_READONLY )		
		?Linux	
		Local S2_ExplainText1:wxTextCtrl = 	New wxTextCtrl.Create(S2_TextPanel , wxID_ANY , GetLocaleText("Tab2ExplainText_LIN") , -1 , -1 , - 1 , - 1 , wxTE_MULTILINE| wxTE_READONLY )
		?
				
		'S2_ExplainText1.setbackgroundcolour(New wxColour.createcolour(255,255,240))
		S2_TextPanel.setbackgroundcolour(New wxColour.createcolour(240,240,240))
		S2_TextPanelvbox.Add(S2_ExplainText1 , 1 , wxEXPAND | wxALL , 4 )
		S2_TextPanel.SetSizer(S2_TextPanelvbox)
		
		

		Line1hbox:wxBoxSizer = New wxBoxSizer.Create(wxHORIZONTAL)	
		Local PText:wxStaticText = New wxStaticText.Create(UploadPanel , wxID_ANY , GetLocaleText("Port") , -1 , -1 , - 1 , - 1 , wxALIGN_LEFT)
		PortComboBox = New wxComboBox.Create(UploadPanel , PCB1 , "" , Null , - 1 , - 1 , - 1 , - 1 , wxCB_READONLY)
		Local RefreshPortsButton:wxButton = New wxButton.Create(UploadPanel , RPB , GetLocaleText("Refresh"))	

		Line1hbox.Add(PText , 0 , wxEXPAND | wxLEFT | wxRIGHT | wxTOP , 4 )
		Line1hbox.Add(PortComboBox , 1 , wxEXPAND | wxLEFT | wxRIGHT | wxTOP , 4 )
		Line1hbox.Add(RefreshPortsButton , 0 , wxEXPAND | wxLEFT | wxRIGHT | wxTOP , 4 )
		
		?Win32
		Line2hbox:wxBoxSizer = New wxBoxSizer.Create(wxHORIZONTAL)	
		Local BText:wxStaticText = New wxStaticText.Create(UploadPanel , wxID_ANY , GetLocaleText("Board") , -1 , -1 , - 1 , - 1 , wxALIGN_LEFT)
		BoardComboBox = New wxComboBox.Create(UploadPanel , BCB , BOARDCHOICES[BoardSelection] , BOARDCHOICES , - 1 , - 1 , - 1 , - 1 , wxCB_READONLY)		
		
		Line2hbox.Add(BText , 0 , wxEXPAND | wxLEFT | wxRIGHT | wxTOP , 4 )
		Line2hbox.Add(BoardComboBox , 1 , wxEXPAND | wxLEFT | wxRIGHT | wxTOP , 4 )		
		?
		
		UploadPanelvbox.Add(S2_TextPanel , 10 , wxEXPAND | wxALL , 4 )
		UploadPanelvbox.AddSizer(Line1hbox, 0 , wxEXPAND | wxLEFT | wxRIGHT | wxTOP , 4 )

		?Win32
		UploadPanelvbox.AddSizer(Line2hbox, 0 , wxEXPAND | wxLEFT | wxRIGHT | wxTOP , 4 )
		?
				
		Line4hbox:wxBoxSizer = New wxBoxSizer.Create(wxHORIZONTAL)	
		BaText = New wxStaticText.Create(UploadPanel , wxID_ANY , "Baud Rate: " , -1 , -1 , - 1 , - 1 , wxALIGN_LEFT)
		BaudComboBox = New wxComboBox.Create(UploadPanel , BACB , BAUDCHOICES[BaudSelection] , BAUDCHOICES , - 1 , - 1 , - 1 , - 1 , wxCB_READONLY)		
		
		Line4hbox.Add(BaText , 0 , wxEXPAND | wxLEFT | wxRIGHT | wxTOP , 4 )
		Line4hbox.Add(BaudComboBox , 1 , wxEXPAND | wxLEFT | wxRIGHT | wxTOP , 4 )	
		UploadPanelvbox.AddSizer(Line4hbox, 0 , wxEXPAND | wxALL , 4 )	
		
		Line3hbox:wxBoxSizer = New wxBoxSizer.Create(wxHORIZONTAL)
		?Win
		Local SText:wxStaticText = New wxStaticText.Create(UploadPanel , wxID_ANY , GetLocaleText("UploadStatus_WIN") , -1 , -1 , - 1 , - 1 , wxALIGN_LEFT)
		?Mac
		Local SText:wxStaticText = New wxStaticText.Create(UploadPanel , wxID_ANY , GetLocaleText("UploadStatus_MAC") , -1 , -1 , - 1 , - 1 , wxALIGN_LEFT)		
		?Linux
		Local SText:wxStaticText = New wxStaticText.Create(UploadPanel , wxID_ANY , GetLocaleText("UploadStatus_LIN") , -1 , -1 , - 1 , - 1 , wxALIGN_LEFT)
		?		
		StatusText:wxStaticText = New wxStaticText.Create(UploadPanel , wxID_ANY , "" , -1 , -1 , - 1 , - 1 , wxALIGN_LEFT)
		StatusText.SetLabel(GetLocaleText("StatusNotStarted"))
		StatusText.SetForegroundColour(New wxColour.createcolour(255,0,0))	
		
		Line3hbox.Add(SText , 0 , wxEXPAND | wxLEFT | wxRIGHT | wxTOP , 4 )
		Line3hbox.Add(StatusText , 1 , wxEXPAND | wxLEFT | wxRIGHT | wxTOP , 4 )
		UploadPanelvbox.AddSizer(Line3hbox, 0 , wxEXPAND | wxALL , 4 )		



		

		?Win
		UploadButton = New wxButton.Create(UploadPanel , SSB , GetLocaleText("ButtonUpload_WIN"))
		?Mac
		UploadButton = New wxButton.Create(UploadPanel , SSB , GetLocaleText("ButtonUpload_MAC"))		
		?Linux
		UploadButton = New wxButton.Create(UploadPanel , SSB , GetLocaleText("ButtonUpload_LIN"))		
		?
		UploadButton.setbackgroundcolour(New wxColour.createcolour(70,255,140))
		Local UploadFont:wxFont = UploadButton.GetFont()
		UploadFont.SetPointSize(12)
		UploadButton.setfont(UploadFont) 

		
		UploadPanelvbox.Add(UploadButton , 0 , wxEXPAND | wxALL , 4 )
	
		UploadPanel.SetSizer(UploadPanelvbox)
		
		If ShowSecondTab=True Then 
			Tabs.AddPage(UploadPanel,GetLocaleText("TabStep")+" "+TabNumber+" "+GetLocaleText("Tab2"))
			TabNumber = TabNumber + 1
		EndIf 
				
		
		Local MainPanel:wxPanel = New wxPanel.Create(Tabs , - 1)
		Local MainPanelvbox:wxBoxSizer = New wxBoxSizer.Create(wxVERTICAL)		

		Local S3_TextPanel:wxPanel = New wxPanel.Create(MainPanel , - 1)
		Local S3_TextPanelvbox:wxBoxSizer = New wxBoxSizer.Create(wxVERTICAL)	
		Local S3_ExplainText2:wxTextCtrl = 	New wxTextCtrl.Create(S3_TextPanel , wxID_ANY , GetLocaleText("Tab3ExplainText") , -1 , -1 , - 1 , - 1 , wxTE_MULTILINE| wxTE_READONLY )
		
		S3_TextPanel.setbackgroundcolour(New wxColour.createcolour(240,240,240))
		S3_TextPanelvbox.Add(S3_ExplainText2 , 1 , wxEXPAND | wxALL , 4 )
		S3_TextPanel.SetSizer(S3_TextPanelvbox)

		'S3_ExplainText2.setbackgroundcolour(New wxColour.createcolour(255,255,240))
		
		MainPanelvbox.Add(S3_TextPanel , 7 , wxEXPAND | wxALL , 4 )
		
		Line1hbox2:wxBoxSizer = New wxBoxSizer.Create(wxHORIZONTAL)	
		Local PText2:wxStaticText = New wxStaticText.Create(MainPanel , wxID_ANY , GetLocaleText("Port") , -1 , -1 , - 1 , - 1 , wxALIGN_LEFT)
		PortComboBox2 = New wxComboBox.Create(MainPanel , PCB2 , "" , Null , - 1 , - 1 , - 1 , - 1 , wxCB_READONLY)
		Local RefreshPortsButton2:wxButton = New wxButton.Create(MainPanel , RPB2 , GetLocaleText("Refresh"))	

		Line1hbox2.Add(PText2 , 0 , wxEXPAND | wxLEFT | wxRIGHT | wxTOP , 4 )
		Line1hbox2.Add(PortComboBox2 , 1 , wxEXPAND | wxLEFT | wxRIGHT | wxTOP , 4 )
		Line1hbox2.Add(RefreshPortsButton2 , 0 , wxEXPAND | wxLEFT | wxRIGHT | wxTOP , 4 )
		MainPanelvbox.AddSizer(Line1hbox2, 0 , wxEXPAND | wxLEFT | wxRIGHT | wxTOP , 4 )

		Line3hbox2:wxBoxSizer = New wxBoxSizer.Create(wxHORIZONTAL)	
		BaText2 = New wxStaticText.Create(MainPanel , wxID_ANY , GetLocaleText("BaudRate") , -1 , -1 , - 1 , - 1 , wxALIGN_LEFT)
		BaudComboBox2 = New wxComboBox.Create(MainPanel , BACB2 , BAUDCHOICES[BaudSelection] , BAUDCHOICES , - 1 , - 1 , - 1 , - 1 , wxCB_READONLY)		
		
		Line3hbox2.Add(BaText2 , 0 , wxEXPAND | wxLEFT | wxRIGHT | wxTOP , 4 )
		Line3hbox2.Add(BaudComboBox2 , 1 , wxEXPAND | wxLEFT | wxRIGHT | wxTOP , 4 )	
		MainPanelvbox.AddSizer(Line3hbox2, 0 , wxEXPAND | wxALL , 4 )	
		
		Line2hbox2:wxBoxSizer = New wxBoxSizer.Create(wxHORIZONTAL)
		Local SText2:wxStaticText = New wxStaticText.Create(MainPanel , wxID_ANY , GetLocaleText("HelperStatus") , -1 , -1 , - 1 , - 1 , wxALIGN_LEFT)
		StatusText2:wxStaticText = New wxStaticText.Create(MainPanel , wxID_ANY , "" , -1 , -1 , - 1 , - 1 , wxALIGN_LEFT)
		StatusText2.SetLabel(GetLocaleText("StatusStopped"))
		StatusText2.SetForegroundColour(New wxColour.createcolour(255,0,0))	
		
		Line2hbox2.Add(SText2 , 0 , wxEXPAND | wxLEFT | wxRIGHT | wxTOP , 4 )
		Line2hbox2.Add(StatusText2 , 1 , wxEXPAND | wxLEFT | wxRIGHT | wxTOP , 4 )
		MainPanelvbox.AddSizer(Line2hbox2, 0 , wxEXPAND | wxALL , 4 )
		

		ServerButton = New wxButton.Create(MainPanel , SSB2 , GetLocaleText("ButtonStartHelper"))	
		MainPanelvbox.Add(ServerButton , 0 , wxEXPAND | wxALL , 4 )
		ServerButton.setbackgroundcolour(New wxColour.createcolour(70,255,140))
		Local ServerFont:wxFont = ServerButton.GetFont()
		ServerFont.SetPointSize(12)
		ServerButton.setfont(ServerFont) 
					
		MainPanel.SetSizer(MainPanelvbox)
		
		Tabs.AddPage(MainPanel,GetLocaleText("TabStep")+" "+TabNumber+" "+GetLocaleText("Tab3"))
		
		
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
		
		?Win32
		Connect(BCB , wxEVT_COMMAND_COMBOBOX_SELECTED , BoardUpdatedFun )		
		?
		
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
	
	Function SetLanguageFun(event:wxEvent)
		Language = (String(event.userData)) 
		UpdateSettings()
		Local MessageBox:wxMessageDialog 
		MessageBox = New wxMessageDialog.Create(Null , GetLocaleText("RestartMessage") , GetLocaleText("ErrorTitle") , wxOK | wxICON_INFO)
		MessageBox.ShowModal()
		MessageBox.Free()	
		End 	
	End Function 
	
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
		' Hack to get linux to update window when baud is shown
		?Linux
		Local x:Int
		Local y:Int
		size = Self.GetSize(x,y)
		x = x + 1
		Self.SetSize(x,y)	
		?
	End Method
	
	?Win32
	Function BoardUpdatedFun(event:wxEvent)
		Local A4SHelperFrame:A4SHelperFrameType = A4SHelperFrameType(event.parent)
		Local Selection:Int = A4SHelperFrame.BoardComboBox.GetSelection()
		
		If Selection = wxNOT_FOUND Then

		Else
			BoardSelection = Selection
			UpdateSettings()
		EndIf 
		
	End Function
	?

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
		Info.setDescription(GetLocaleText("AboutApp"))

		Info.addDeveloper("Thomas Preece")
		Info.addDocWriter("Thomas Preece")
		Info.addDocWriter("Simon Monk")

		Info.setName("SuperEasy-A4S")
		Info.setVersion(VERSION)
		Info.setWebsite("http://thomaspreece.com",GetLocaleText("DevWeb"))
		wxAboutBox(Info)
	End Function
	
	Function ShowLogFun(event:wxEvent)
		Local A4SHelperFrame:A4SHelperFrameType = A4SHelperFrameType(event.parent)
		A4SHelperFrame.A4SHelperLog.Show(1)
	End Function
	
	Function CloseFun(event:wxEvent)
		Local A4SHelperFrame:A4SHelperFrameType = A4SHelperFrameType(event.parent)
		
		?Win
		Local BUTTON1:String = 	GetLocaleText("ButtonUpload_WIN")
		Local BUTTON2:String = GetLocaleText("ButtonFinished_WIN")
		Local ERROR2:String = GetLocaleText("ErrorClose_WIN")
		?Mac
		Local BUTTON1:String = 	GetLocaleText("ButtonUpload_MAC")
		Local BUTTON2:String = GetLocaleText("ButtonFinished_MAC")
		Local ERROR2:String = GetLocaleText("ErrorClose_MAC")		
		?Linux
		Local BUTTON1:String = 	GetLocaleText("ButtonUpload_LIN")
		Local BUTTON2:String = GetLocaleText("ButtonFinished_LIN")
		Local ERROR2:String = GetLocaleText("ErrorClose_LIN")		
		?

		If A4SHelperFrame.UploadButton.GetLabel() = BUTTON1 Or A4SHelperFrame.UploadButton.GetLabel() = BUTTON2 Then
			
		Else 
			Local MessageBox:wxMessageDialog 
			MessageBox = New wxMessageDialog.Create(Null, ERROR2 , GetLocaleText("QuestionTitle") , wxYES_NO | wxNO_DEFAULT | wxICON_QUESTION)
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
		
		?Win
		Local BUTTON1:String = GetLocaleText("ButtonUpload_WIN")
		Local BUTTON2:String = GetLocaleText("ButtonFinished_WIN")
		Local ERROR2:String = GetLocaleText("ErrorClose_WIN")
		?Mac
		Local BUTTON1:String = GetLocaleText("ButtonUpload_MAC")
		Local BUTTON2:String = GetLocaleText("ButtonFinished_MAC")
		Local ERROR2:String = GetLocaleText("ErrorClose_MAC")		
		?Linux
		Local BUTTON1:String = GetLocaleText("ButtonUpload_LIN")
		Local BUTTON2:String = GetLocaleText("ButtonFinished_LIN")
		Local ERROR2:String = GetLocaleText("ErrorClose_LIN")		
		?	
		
		If A4SHelperFrame.UploadButton.GetLabel() = BUTTON1 Or A4SHelperFrame.UploadButton.GetLabel() = BUTTON2 Then
			Local Port:String = A4SHelperFrame.PortComboBox.GetValue()
			?Win32
			Local Board:Int = Int(A4SHelperFrame.BoardComboBox.GetValue())
			?Not Win32
			Local Board:Int = 1
			?
			
			Local Baud:String = A4SHelperFrame.BaudComboBox.GetValue()
			Local MessageBox:wxMessageDialog 
			If Port = "" Or Port = " " Or Board=0 Then
				MessageBox = New wxMessageDialog.Create(Null , GetLocaleText("ErrorPortBoard") , GetLocaleText("ErrorTitle") , wxOK | wxICON_ERROR)
				MessageBox.ShowModal()
				MessageBox.Free()	
				Return 
			EndIf 
			If Baud = "" Or Baud = " " Then 
				Baud="57600"
			EndIf
			A4SHelperFrame.ProcessUpload(ExtractPort(Port),Board,Baud)
		Else
			MessageBox = New wxMessageDialog.Create(Null, ERROR2 , GetLocaleText("QuestionTitle"), wxYES_NO | wxNO_DEFAULT | wxICON_QUESTION)
			If MessageBox.ShowModal() = wxID_YES Then
				A4SHelperFrame.StatusText.SetLabel(GetLocaleText("StatusStoppedUser"))
				A4SHelperFrame.A4SHelperLog.AddText("Process Terminated By User~n")	
				TerminateProcess(A4SHelperFrame.UploadProcess)
			EndIf
			MessageBox.Free()	
		EndIf 
		
		
	End Function 
	
	Method ProcessUpload(Port:String,Board:Int,Baud:String)
		Local MessageBox:wxMessageDialog 
		A4SHelperLog.AddText("===============Uploading===============~n")	
		UploadButton.SetLabel(GetLocaleText("ButtonStop"))
		UploadButton.setbackgroundcolour(New wxColour.createcolour(255,100,100))
		A4SHelperLog.AddText("Starting Upload on "+Port+" ~n")
		StatusText.SetLabel(GetLocaleText("StatusStartedNormal"))
		StatusText.SetForegroundColour(New wxColour.createcolour(255,140,0))	
		Local ModifySourceStatus:Int = ModifyFirmataSource(Baud)
		If ModifySourceStatus = 0	
		
		Else 
			MessageBox = New wxMessageDialog.Create(Null , GetLocaleText("ErrorGenArduinoCode")+": "+ModifySourceStatus , GetLocaleText("ErrorTitle") , wxOK | wxICON_ERROR)
			MessageBox.ShowModal()
			MessageBox.Free()	
			?Win
			UploadButton.SetLabel(GetLocaleText("ButtonUpload_WIN"))
			?Mac
			UploadButton.SetLabel(GetLocaleText("ButtonUpload_MAC"))			
			?Linux
			UploadButton.SetLabel(GetLocaleText("ButtonUpload_LIN"))			
			?
			UploadButton.setbackgroundcolour(New wxColour.createcolour(70,255,140))
		
			StatusText.SetLabel(GetLocaleText("StatusError"))
			StatusText.SetForegroundColour(New wxColour.createcolour(255,0,0))
			A4SHelperLog.AddText("Failed to generate Firmata Source")
			Return
		EndIf
		?Win32
		A4SHelperLog.AddText("Starting: ArduinoUploader.exe  "+Chr(34)+UserAppDir+"\SuperEasy-A4S\StandardFirmata\StandardFirmata.ino"+Chr(34)+" "+Board+" "+Port+" ~n")
		ChangeDir("ArduinoUploader")
		Self.UploadProcess = CreateProcess("ArduinoUploader.exe  "+Chr(34)+UserAppDir+"\SuperEasy-A4S\StandardFirmata\StandardFirmata.ino"+Chr(34)+" "+Board+" "+Port,1)
		ChangeDir("..")
		?MacOS
		If FileType("/Applications/Arduino.app/Contents/MacOS/JavaApplicationStub")=1 Then 
			A4SHelperLog.AddText("Starting: Arduino")_  
			Self.UploadProcess = CreateProcess("/Applications/Arduino.app/Contents/MacOS/JavaApplicationStub "+Chr(34)+UserAppDir+"/SuperEasy-A4S/StandardFirmata/StandardFirmata.ino"+Chr(34),1)
		Else
			MessageBox = New wxMessageDialog.Create(Null , GetLocaleText("ErrorInstallIDE_MAC") , GetLocaleText("StatusError") , wxOK | wxICON_ERROR)
			MessageBox.ShowModal()
			MessageBox.Free()	
		EndIf 
		?Linux
			Self.UploadProcess = CreateProcess("arduino "+Chr(34)+UserAppDir+"/SuperEasy-A4S/StandardFirmata/StandardFirmata.ino"+Chr(34),1)				
			A4SHelperLog.AddText("Starting: Arduino")
		?
		
		
		Local s:String
		
		If UploadProcess = Null Then 
			MessageBox = New wxMessageDialog.Create(Null , GetLocaleText("ErrorArduinoUploader") , GetLocaleText("ErrorTitle") , wxOK | wxICON_ERROR)
			MessageBox.ShowModal()
			MessageBox.Free()	
			?Win
			UploadButton.SetLabel(GetLocaleText("ButtonUpload_WIN"))
			?Mac
			UploadButton.SetLabel(GetLocaleText("ButtonUpload_MAC"))			
			?Linux
			UploadButton.SetLabel(GetLocaleText("ButtonUpload_LIN"))			
			?
			UploadButton.setbackgroundcolour(New wxColour.createcolour(70,255,140))
		
			StatusText.SetLabel(GetLocaleText("StatusError"))
			StatusText.SetForegroundColour(New wxColour.createcolour(255,0,0))
			?Win32
			A4SHelperLog.AddText("ArduinoUploader could not start. This probabily means ArduinoUploader.exe is missing or corrupt. Please reinstall ArduinoUploader.~n")
			?Not Win32
			A4SHelperLog.AddText("Arduino could not start. This could be because the installation is corrupt or missing~n")			
			?
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

		?Win32
		If StatusText.GetLabel()=GetLocaleText("StatusFinished") Or StatusText.GetLabel()=GetLocaleText("StatusStoppedUser") Then
		
		Else
			StatusText.SetLabel(GetLocaleText("StatusError"))
			StatusText.SetForegroundColour(New wxColour.createcolour(255,0,0))
		EndIf 
		?Not Win32
		'Mac and linux version just loads up Arduino Environment, so always show finished correctly status
		StatusText.SetLabel(GetLocaleText("StatusFinished"))
		StatusText.SetForegroundColour(New wxColour.createcolour(0,120,0))		
		?
		
		?Win
		UploadButton.SetLabel(GetLocaleText("ButtonFinished_WIN"))
		?Mac
		UploadButton.SetLabel(GetLocaleText("ButtonFinished_MAC"))		
		?Linux
		UploadButton.SetLabel(GetLocaleText("ButtonFinished_LIN"))		
		?
		UploadButton.setbackgroundcolour(New wxColour.createcolour(70,255,140))
		TerminateProcess(UploadProcess)
		'ChangeDir("..")
		
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
						If Status.GetLabel()=GetLocaleText("StatusError") Then
						
						Else
							Status.SetLabel(GetLocaleText("StatusFinished"))
							Status.SetForegroundColour(New wxColour.createcolour(0,120,0))							
						EndIf 
					ElseIf Instr(Totals,"not in sync") Then
						If Status.GetLabel()=GetLocaleText("StatusStoppedUser") Then 
						
						Else
							Console.AddText("Arduino out of sync!.~n")
							Status.SetLabel(GetLocaleText("StatusError"))
							Status.SetForegroundColour(New wxColour.createcolour(255,0,0))							
						EndIf 
					ElseIf Instr(Totals,"Writing") Then 
						If Status.GetLabel()=GetLocaleText("StatusStoppedUser") Then 
						
						Else
							Status.SetLabel(GetLocaleText("StatusUploading"))
							Status.SetForegroundColour(New wxColour.createcolour(255,140,0))						
						EndIf 
					ElseIf Instr(Totals,"Compiliation") Then
						If Status.GetLabel()=GetLocaleText("StatusStoppedUser") Then 
						
						Else					
							Status.SetLabel(GetLocaleText("StatusCompiling"))
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
						Status.SetLabel(GetLocaleText("StatusStarted"))
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
		
		If A4SHelperFrame.ServerButton.GetLabel() = GetLocaleText("ButtonStartHelper") Then

			Local Port:String = A4SHelperFrame.PortComboBox2.GetValue()
			Local Baud:String = A4SHelperFrame.BaudComboBox2.GetValue()
			Local MessageBox:wxMessageDialog 
			If Port = "" Or Port = " " Then
				MessageBox = New wxMessageDialog.Create(Null , GetLocaleText("ErrorPort") , GetLocaleText("ErrorTitle") , wxOK | wxICON_ERROR)
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
		StatusText2.SetLabel(GetLocaleText("StatusStarting"))
		StatusText2.SetForegroundColour(New wxColour.createcolour(255,140,0))
		
		ServerButton.setbackgroundcolour(New wxColour.createcolour(255,100,100))
		ServerButton.SetLabel(GetLocaleText("ButtonStop"))
		
		Port = Replace(Port,"cu.","tty.")
		A4SHelperLog.AddText("Running Helper App on "+Port+" ~n")
		
		Local extraFlags:String = ""		
	?Linux
		extraFlags = "-Djava.library.path=./"
	?
		
		If Java32Bit = True Then 
			A4SHelperLog.AddText(JavaLocation+" "+extraFlags+" -d32 -jar "+"A4S.jar"+" "+Port+" "+Baud+"~n")
			Self.ServerProcess = CreateProcess(JavaLocation+" "+extraFlags+" -d32 -jar "+"A4S.jar"+" "+Port+" "+Baud)
		Else
			A4SHelperLog.AddText(JavaLocation+" "+extraFlags+" -jar "+"A4S.jar"+" "+Port+" "+Baud+"~n")
			Self.ServerProcess = CreateProcess(JavaLocation+" "+extraFlags+" -jar "+"A4S.jar"+" "+Port+" "+Baud)
		EndIf	
		
		If ServerProcess = Null Then 
			MessageBox = New wxMessageDialog.Create(Null , GetLocaleText("ErrorHelperStart") , GetLocaleText("ErrorTitle") , wxOK | wxICON_ERROR)
			MessageBox.ShowModal()
			MessageBox.Free()	
			ServerButton.SetLabel(GetLocaleText("ButtonStartHelper"))
			ServerButton.setbackgroundcolour(New wxColour.createcolour(70,255,140))			
			StatusText2.SetLabel(GetLocaleText("StatusError"))
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
		
		If StatusText2.GetLabel()=GetLocaleText("StatusStarted") Or StatusText2.GetLabel()=GetLocaleText("StatusStoppedUser") Then
			StatusText2.SetLabel(GetLocaleText("StatusStopped"))
			StatusText2.SetForegroundColour(New wxColour.createcolour(255,0,0))		
		Else
			StatusText2.SetLabel(GetLocaleText("StatusError"))
			StatusText2.SetForegroundColour(New wxColour.createcolour(255,0,0))
		EndIf 


		ServerButton.SetLabel(GetLocaleText("ButtonStartHelper"))
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
		If Mid(Text,a,3)=" - " Then
			Return Left(Text,a-1)
		EndIf 
	Next
End Function

Function GetPorts:TList()
	Local COMPortsList:TList = CreateList()
	
	Local Ports:TList = TSerial.listPorts()

	For Local Port:TSerialPortInfo = EachIn Ports
		?Win32
		If Left(Port.portName,3)="COM" Then
			If Port.productName="" Or Port.productName=" " Then 
				ListAddFirst(COMPortsList,Port.portName+" - "+GetLocaleText("NoProductName") )
			Else
				ListAddFirst(COMPortsList,Port.portName+" - "+Port.productName)
			EndIf 
		EndIf
		?Not Win32
		If Left(Port.portName,5)="/dev/" Then
			If Port.productName="" Or Port.productName=" " Then 
				ListAddFirst(COMPortsList, DereferenceSymbolicLink(Port.portName)+" - "+GetLocaleText("NoProductName") )
			Else		
				ListAddFirst(COMPortsList, DereferenceSymbolicLink(Port.portName)+" - "+Port.productName)
			EndIf 
		EndIf
		?
	Next
	
	If CountList(COMPortsList) = 0 Then 
		ListAddLast(COMPortsList,"")
	EndIf 
	
	Rem
	?MacOS
	ReadDevices = ReadDir("/dev/")
	Repeat
		Device:String = NextFile(ReadDevices)
		If Device = "" Then Exit 
		If Left(Device,Len("tty."))="tty." Then 
			ListAddFirst(COMPortsList,"/dev/"+Device)
		EndIf
	Forever
	CloseDir(ReadDevices)
	?
	EndRem 
	Return COMPortsList
End Function


Function UpdateSettings()
	Local SettingsFile:TStream
	SettingsFile = WriteFile(UserAppDir+Slash+"SuperEasy-A4S"+Slash+"Settings.txt")
	WriteLine(SettingsFile,PortSelection)
	WriteLine(SettingsFile,BoardSelection)
	WriteLine(SettingsFile,BaudSelection)
	WriteLine(SettingsFile,Language)
	CloseFile(SettingsFile)
End Function

Function ModifyFirmataSource(Baud:String)
	If FileType("ArduinoUploader"+Slash+"StandardFirmataTemplate"+Slash+"StandardFirmataTemplate.ino") = 1 Then

	Else
		Return 1
	EndIf 
	If FileType(UserAppDir+Slash+"SuperEasy-A4S"+Slash+"StandardFirmata")=2 Then
	
	Else
		CreateDir(UserAppDir+Slash+"SuperEasy-A4S"+Slash+"StandardFirmata")
		If FileType(UserAppDir+Slash+"SuperEasy-A4S"+Slash+"StandardFirmata")=2 Then
		
		Else
			Return 2
		EndIf 
	EndIf
	
	Local NewFirmata:TStream
	Local OldFirmata:TStream 
	Local Line:String
	NewFirmata = WriteFile(UserAppDir+Slash+"SuperEasy-A4S"+Slash+"StandardFirmata"+Slash+"StandardFirmata.ino")
	OldFirmata = ReadFile("ArduinoUploader"+Slash+"StandardFirmataTemplate"+Slash+"StandardFirmataTemplate.ino")
	If NewFirmata = Null Or OldFirmata = Null Then 
		Return 3
	EndIf 
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

Function CreateSb2Files()
	Notify UserDocumentsDir
	If FileType("examples"+Slash+"ImportBlocks.sb2") = 1 Then
	
	Else
		Return 2
	EndIf 
	If FileType("examples"+Slash+"EsploraBlocks_Example.sb2") = 1 Then
	
	Else
		Return 2
	EndIf 
	If FileType("examples"+Slash+"EsploraBlocks_Empty.sb2") = 1 Then
	
	Else
		Return 2
	EndIf 	
		
	If FileType(UserDocumentsDir+Slash+"SuperEasy-A4S")=2 Then
	
	Else
		CreateDir(UserDocumentsDir+Slash+"SuperEasy-A4S")
	EndIf
	If FileType(UserDocumentsDir+Slash+"SuperEasy-A4S")=2 Then
	
	Else
		Return 1
	EndIf
	
	If FileType(UserDocumentsDir+Slash+"SuperEasy-A4S"+Slash+"ImportBlocks.sb2")=1 Then
	
	Else
		CopyFile("examples"+Slash+"ImportBlocks.sb2",UserDocumentsDir+Slash+"SuperEasy-A4S"+Slash+"ImportBlocks.sb2")
	EndIf
	If FileType(UserDocumentsDir+Slash+"SuperEasy-A4S"+Slash+"ImportBlocks.sb2")=1 Then
	
	Else
		Return 1
	EndIf	
	
	If FileType(UserDocumentsDir+Slash+"SuperEasy-A4S"+Slash+"EsploraBlocks_Example.sb2")=1 Then
	
	Else
		CopyFile("examples"+Slash+"EsploraBlocks_Example.sb2",UserDocumentsDir+Slash+"SuperEasy-A4S"+Slash+"EsploraBlocks_Example.sb2")
	EndIf
	If FileType(UserDocumentsDir+Slash+"SuperEasy-A4S"+Slash+"EsploraBlocks_Example.sb2")=1 Then
	
	Else
		Return 1
	EndIf		

	If FileType(UserDocumentsDir+Slash+"SuperEasy-A4S"+Slash+"EsploraBlocks_Empty.sb2")=1 Then
	
	Else
		CopyFile("examples"+Slash+"EsploraBlocks_Empty.sb2",UserDocumentsDir+Slash+"SuperEasy-A4S"+Slash+"EsploraBlocks_Empty.sb2")
	EndIf
	If FileType(UserDocumentsDir+Slash+"SuperEasy-A4S"+Slash+"EsploraBlocks_Empty.sb2")=1 Then
	
	Else
		Return 1
	EndIf	
	
	
	Return 0
End Function 


?Linux
Function DereferenceSymbolicLink:String(Link:String)
	Local Delinker:TProcess = CreateProcess("readlink -f "+Link)
	Local ReturnedString:String 
	While ProcessStatus(Delinker)=1
		ReturnedString = DeferenceSymbolicLinkProcess(Delinker)
		If ReturnedString = "" Then 
		
		Else
			Return ReturnedString.Replace("~n","")	
		EndIf  
	Wend
	ReturnedString = DeferenceSymbolicLinkProcess(Delinker)
	If ReturnedString = "" Then 
		Return ""
	Else
		Return ReturnedString.Replace("~n","")	 		
	EndIf  	
End Function 

Function DeferenceSymbolicLinkProcess:String(Delinker:TProcess)
	Local s:String
	While Delinker.pipe.readavail() Or Delinker.err.readavail()
		If Delinker.pipe.readavail() Then
			s=Delinker.pipe.ReadString (Delinker.pipe.ReadAvail())
			If s = "" Or s = " "	
			
			Else
				Return s						
			EndIf 	
		EndIf
		
		If Delinker.err.readavail() Then
			s=Delinker.err.ReadString (Delinker.err.ReadAvail())
			If s = "" Or s = " "	
			
			Else
				Return s						
			EndIf 						
		EndIf 
	Wend
	Return ""
End Function 
?