#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_outfile=iXu.exe
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Res_Comment=by Tristano Ajmone — www.zenfactor.org
#AutoIt3Wrapper_Res_Description=Inform 7 Extension Updater
#AutoIt3Wrapper_Res_LegalCopyright=No!Copyright
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.0
 Author:         Tristano Ajmone

 Script Function:
	iXu - Inform 7 Extension Updater.

#ce ----------------------------------------------------------------------------


#include <Array.au3>
#include <ButtonConstants.au3>
#include <Date.au3>
#include <File.au3>
#include <GUIConstantsEx.au3>
#include <IE.au3>
#include <INet.au3>
#include <String.au3>
#include <WindowsConstants.au3>

#cs	######################################################
	############ EXTRA FILES INCLUDED IN EXE #############
	######################################################
#ce

FileInstall(".\INCLUDES\header.html",	@TempDir & "\header.html")
FileInstall(".\INCLUDES\footer.html", 	@TempDir & "\footer.html")
FileInstall(".\INCLUDES\GUI.jpg",		@TempDir & "\GUI.jpg")

#cs	###################################################
	############ DECLARATION OF VARIABLES #############
	###################################################
#ce

$SIMULATION_MODE = False 
;$SIMULATION_MODE = True ; For developer's test purposes only (not available to users)

$iXu_Version = "Beta 2.4"


$TASK_COMPLETED = False ; if update was done is set to True

$I7_RSS = "http://inform7.com/extensions/I7ExtensionsRSS.xml"
$I7_ExtensionsFolder = @MyDocumentsDir & "\Inform\Extensions"
$TEMP_FILE = @ScriptDir & "\temp_file.txt"
$ArchiveFolder = @ScriptDir & "\Extensions Archive"
$DownloadFolder = @ScriptDir & "\Extensions Download"

$TempFolder = @TempDir & "\iXuTemp"

$LogText = ""

$FileToSave = ""

Global $CounterString = "0000"
Global $TotalItems
Global $LOG_FILE

; Colors Variables
;--------------------------------------------------------------------------------
$grey = 0xaaaaaa

;--------------------------------------------------------------------------------

$DownloadedExtensions = 0
$FailedDownloads = 0

#cs	#####################################
	############ INITIALIZE #############
	#####################################
#ce

If Not FileExists($ArchiveFolder) Then ; First time running: Open User Guide...
	DirCreate ($ArchiveFolder)
	MsgBox(0,	"WARNING!", "It seems that you are running iXu for the first time." & @CRLF & @CRLF & _
							"You are strongly adviced to read the User Guide!")
	If FileExists (@ScriptDir & "\iXu User Guide.pdf") Then
		ShellExecute (@ScriptDir & "\iXu User Guide.pdf")
	EndIf
EndIf
If Not FileExists($DownloadFolder) Then DirCreate ($DownloadFolder)
DirRemove ($TempFolder, 1)

; Check if Extensions folder exists

if FileExists($I7_ExtensionsFolder) Then
	$extensions_folder_exists = True
Else
	$extensions_folder_exists = False
	MsgBox(64, "Warning", "iXu could not find Inform 7 Extensions folder!" & @CRLF & @CRLF & _
		"Downloaded extension will be saved only in iXu's folders.")
EndIf

#cs	#####################################
	############ CREATE GUI #############
	#####################################
#ce
	; Window size: 1024x600 (for Asus Eee PC 900 compatibility)	
	
$Desk_Size_X = 800
$Desk_Size_Y = 225
	
	$ParentWin = GUICreate("iXu - Inform 7 Extensions Updater ( v " & $iXu_Version & " )", $Desk_Size_X, $Desk_Size_Y, -1, -1)
	;GUISetBkColor(0x000000)


	; Carica Immagine di Sfondo.
	GUICtrlCreatePic(@TempDir & "\GUI.jpg", 0, 0, 800, 300, -1, $GUI_WS_EX_PARENTDRAG)
	GuiCtrlSetState(-1,$GUI_DISABLE)
	; Se non metto disable: il bottone non è selezionabile
	; Se enable, non posso rendere l'immagine trascinabile!
	
	; BitOR() $GUI_SS_DEFAULT_GUI	$WS_EX_LAYERED	$GUI_WS_EX_PARENTDRAG
	
	;Save the position of the parent window
	;$ParentWin_Pos = WinGetPos($ParentWin, "")

; Labels
;--------------------------------------------------------------------------------
GUISetFont(16, 400, 0, "Trebuchet MS")

; ### DOWNLOADS ###
$downloads_label = GUICtrlCreateLabel(" Downloads:", 560, 45, 180, 30)
GUICtrlSetBkColor(-1, 0x000000) ; $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetColor (-1, $grey)

; ### ERRORS ###
$errors_label = GUICtrlCreateLabel(" Errors:", 560, 80, 180, 30)
GUICtrlSetBkColor(-1, 0x000000) ; $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetColor (-1, $grey)


; ### COUNTER ###
GUISetFont(60, 400, 0, "Courier New Bold")
$CounterLabel = GUICtrlCreateLabel($CounterString, 312, 36, 180, 73)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetColor (-1, $grey)

; ### PROGRESS BAR ###
$progress_bar = GUICtrlCreateProgress ( 310, 125, 180, 20)

; Menus
;--------------------------------------------------------------------------------
; #### TOOLS ###
$menu_tools = GUICtrlCreateMenu("&Tools")
$menu_tools_help = GUICtrlCreateMenuItem("User Guide", $menu_tools)
$menu_tools_extensions_list = GUICtrlCreateMenuItem("View extensions list", $menu_tools)
$menu_tools_archive_folder = GUICtrlCreateMenuItem("Open Extensions Archive folder", $menu_tools)
$menu_tools_download_folder = GUICtrlCreateMenuItem("Open Extensions Download folder", $menu_tools)
$menu_tools_extension_folder = GUICtrlCreateMenuItem("Open Inform7 Extensions folder", $menu_tools)
$menu_tools_email = GUICtrlCreateMenuItem("eMail author", $menu_tools)
$menu_tools_homepage = GUICtrlCreateMenuItem("iXu Home Page", $menu_tools)
$menu_tools_about = GUICtrlCreateMenuItem("About", $menu_tools)

; #### LINKS ###
$menu_links = GUICtrlCreateMenu("&Links")
$menu_links_ZenFactor = GUICtrlCreateMenuItem("ZenFactor.org", $menu_links)
$menu_links_I7_Extensions = GUICtrlCreateMenuItem("Inform7.com - Extensions Page", $menu_links)
$menu_links_IF_Archive = GUICtrlCreateMenuItem("The Interactive Fiction Archive", $menu_links)
$menu_links_IFDB = GUICtrlCreateMenuItem("IFDB - The Interactive Fiction Database", $menu_links)
$menu_links_SPAG = GUICtrlCreateMenuItem("SPAG - Society for the Promotion of Adventure Games", $menu_links)
$menu_links_RAIF = GUICtrlCreateMenuItem("RAIF - rec.arts.int-fiction", $menu_links)
$menu_links_Emily = GUICtrlCreateMenuItem("Emily Short's Blog", $menu_links)

; Buttons
;--------------------------------------------------------------------------------
	
; ### START BUTTON ###
GUISetFont(16, 400, 0, "Trebuchet MS")
$button_start = GUICtrlCreateButton("START", 325, 155, 150, 40)
	

	;Show the parent window/Make the parent window visible
	GUISetState(@SW_SHOW)
	
#cs	###############################################
	############ WAIT FOR USER ACTION #############
	###############################################
#ce
	While 1
		Switch GUIGetMsg()
			; Menu > Tools
			Case $menu_tools_help
				If FileExists (@ScriptDir & "\iXu User Guide.pdf") Then
					ShellExecute (@ScriptDir & "\iXu User Guide.pdf")
				Else
					MsgBox(0, "ERROR!", "Could not find User Guide!")
				EndIf
			Case $menu_tools_extensions_list
				If FileExists (@ScriptDir & "\Extensions List.htm") Then
					_IECreate (@ScriptDir & "\Extensions List.htm", 0, 1, 0)
				Else
					MsgBox(0, "ERROR!", "Extensions List file not present!")
				EndIf
			Case $menu_tools_archive_folder
				Run("Explorer.exe " & @ScriptDir & "\Extensions Archive")
			Case $menu_tools_download_folder
				Run("Explorer.exe " & @ScriptDir & "\Extensions Download")
			Case $menu_tools_extension_folder
				Run("Explorer.exe " & $I7_ExtensionsFolder)
			Case $menu_tools_email
				if Run(@ProgramFilesDir & "\Outlook Express\msimn.exe /mailurl:mailto:tajmone@gmail.com") = 0 Then
					; If for any reason don't work, use quick and dirty way ...
					_IECreate ("mailto:tajmone@gmail.com", 0, 0, 0)
				EndIf
			Case $menu_tools_homepage
				_IECreate ("http://ixu.zenfactor.org", 0, 1, 0)
			Case $menu_tools_about
				MsgBox(0, "About iXu", "iXu v. " & $iXu_Version & " (Freeware)" & @CRLF & @CRLF & _
					"created with AutoIt Script" & @CRLF & @CRLF & _
					"by Tristano Ajmone - Sept. 2010" & @CRLF & @CRLF & _
					"www.ZenFactor.org")
			; Menu > Links
			Case $menu_links_ZenFactor
				_IECreate ("http://www.zenfactor.org", 0, 1, 0)
			Case $menu_links_I7_Extensions
				_IECreate ("http://inform7.com/write/extensions/Extensions List.htm", 0, 1, 0)
			Case $menu_links_IF_Archive
				_IECreate ("http://www.ifarchive.org/", 0, 1, 0)
			Case $menu_links_IFDB
				_IECreate ("http://ifdb.tads.org/", 0, 1, 0)
			Case $menu_links_SPAG
				_IECreate ("http://www.sparkynet.com/spag/", 0, 1, 0)
			Case $menu_links_RAIF
				_IECreate ("http://groups.google.com/group/rec.arts.int-fiction/topics", 0, 1, 0)
			Case $menu_links_Emily
				_IECreate ("http://emshort.wordpress.com/", 0, 1, 0)

			; Buttons
			Case $button_start
				If $TASK_COMPLETED Then
					Run("notepad.exe " & $LOG_FILE)
				Else
					UpdateExtensions ()
				EndIf
				
			Case $GUI_EVENT_CLOSE
				; Delete installed files
				;--------------------------------------------------------------------------------
				FileDelete (@TempDir & "\header.html")
				FileDelete (@TempDir & "\footer.html")
				FileDelete (@TempDir & "\GUI.jpg")
				Exit
			Case Else
		EndSwitch
	WEnd

;	GUIDelete()

; --------------------

#cs	#####################################################
	############ UPDATE EXTENSIONS FUNCTION #############
	#####################################################
#ce

func UpdateExtensions ()
	; Update GUI
	;--------------------------------------------------------------------------------
	GUICtrlSetData ($button_start, "WORKING")
	GUICtrlSetState($button_start, $GUI_DISABLE)
	
	; Create TEMP folder
	
	DirCreate ($TempFolder)

	
	; Retrive Extensions list
	;--------------------------------------------------------------------------------
	if ($SIMULATION_MODE) Then 
			; Simulation mode will read from file instead of server (for test purposes)
			;--------------------------------------------------------------------------------
			MsgBox(48, "ALERT!", "SIMULATION MODE!")
			$file = FileOpen( @ScriptDir & "\Simulation Page.htm", 0)
			; Check if file opened for reading OK
			If $file = -1 Then
				MsgBox(0, "Error", "Unable to open file.")
				Exit
			EndIf
			$RSSFile = FileRead($file)
			FileClose($file)
		Else
			$RSSFile = _INetGetSource($I7_RSS)
	EndIf

	; Log File Initialization
	;--------------------------------------------------------------------------------

	; Set Date of Log File
	$JobTime = _Date_Time_GetSystemTime()
	$JobTime = _Date_Time_SystemTimeToDateTimeStr($JobTime, 1)
	$TimeStamp = StringReplace ( $JobTime, "/", "-")
	$TimeStamp = StringReplace ( $TimeStamp, ":", "-")
	;$LOG_FILE = @ScriptDir & "\log_file " & $TimeStamp & ".txt"
	$LOG_FILE = @ScriptDir & "\log_file.txt"

	FileDelete ($LOG_FILE) ; Has to delete, else it will append to existing file!!!!
	$file = FileOpen($LOG_FILE, 1)
	; Check if file opened for writing OK
	If $file = -1 Then
		MsgBox(0, "Error", "Unable to access Log file!")
		Exit
	EndIf


	; Extract RSS Last Build Date
	;--------------------------------------------------------------------------------
	$LastBuild_DateExtended = ExtractTag ($RSSFile, "<lastBuildDate>")
	$LastBuild_DateString = ConvertDate(ExtractTag ($RSSFile, "<lastBuildDate>"))

	; Strip spurious tags from beginning of RSS file
	;--------------------------------------------------------------------------------
	$Items_StartPos = StringInStr ( $RSSFile, "<item>", 0, 1, 1 )
	$RSSFile = StringTrimLeft ($RSSFile, $Items_StartPos - 1)

	; Strip spurious tags from end of RSS file
	;--------------------------------------------------------------------------------
	$RSSFile = StringReplace( $RSSFile, "</channel></rss>", "", 0, 0)

	; Calculate total elements
	;--------------------------------------------------------------------------------
	$TempSplit = StringSplit($RSSFile, "<item>", 1)
	$TotalItems = $TempSplit[0]  - 1

	; Update Counter
	GUICtrlSetColor ($CounterLabel, 0xffffff)
	UpdateCounter ($TotalItems)

	; Write to disk Temp File ( simulation mode only! )
	;--------------------------------------------------------------------------------
	if ($SIMULATION_MODE) Then 
		FileDelete ($TEMP_FILE) ; Has to delete, else it will append to existing file!!!!
		$TemporaryFile = FileOpen($TEMP_FILE, 1)
		; Check if file opened for writing OK
		If $TemporaryFile = -1 Then
			MsgBox(0, "Error", "Unable to open file.")
			Exit
		EndIf
		FileWrite($TemporaryFile, $RSSFile)
		FileClose($TemporaryFile)
	EndIf
	
	; Write Beginning of Log File
	$LogText =	"iXu - Inform 7 Extensions Updater - Log File" & @CRLF &  @CRLF & _
				"Task Date: " & $JobTime & @CRLF & _
				"Last Extensions Updates on inform7.com : " & $LastBuild_DateExtended & @CRLF & _
				"Total Extensions Files Available: " & $TotalItems & @CRLF & @CRLF
	FileWrite($file, $LogText)
	;--------------------------------------------------------------------------------
	; Cicle
	;--------------------------------------------------------------------------------

	For $counter = 1 to $TotalItems

	; Update Progress Bar
	$progress = (100/$TotalItems) * $counter
	GUICtrlSetData($progress_bar, $progress)
	
	; Extract Item Values
	;--------------------------------------------------------------------------------
		$ItemTitle = ExtractTag ($RSSFile, "<title>")
		$ItemLink = ExtractTag ($RSSFile, "<link>")
		$ItemDescription = ExtractTag ($RSSFile, "<description>")
		$ItemPubDate = ExtractTag ($RSSFile, "<pubDate>")
		$ItemDate = ConvertDate ($ItemPubDate)
		$ExplodedLink = _StringExplode($ItemLink, "/")
		;_ArrayDisplay($ExplodedLink, "StringExplode 4")
		$ItemAuthor = $ExplodedLink[4]
		$ItemFileName = $ExplodedLink[5]
		$ItemAuthorCleaned = ConvertURLChars ($ItemAuthor)
		$ItemFileNameCleaned = ConvertURLChars ($ItemFileName)
		
		$ItemDownloadLink = "http://inform7.com/extensions/" & $ItemAuthor & "/" & $ItemFileName & "/" & $ItemFileName & ".i7x"
		$ItemDownloadLink = ConvertURLChars ($ItemDownloadLink)
		$ItemArchiveFile = $ArchiveFolder & "\" & $ItemAuthorCleaned & " = " & $ItemFileNameCleaned & " = " & $ItemDate & ".i7x"

	; Create HTML Card for Extension
	;--------------------------------------------------------------------------------
	$temp_html_file_name = $TempFolder & "\" & $ItemFileNameCleaned & " - by " & $ItemAuthorCleaned & ".html"
	$temp_html_file = FileOpen($temp_html_file_name, 1)
	; Check if file opened for writing OK
	If $temp_html_file = -1 Then
		MsgBox(0, "Error", "Unable to access temporary files!")
		Exit
	EndIf
	$ExtensionCard_HTML = "<h2><a href=" & Chr (34) & $ItemLink & Chr (34) & ">" & $ItemTitle & "</h2>"
	$ExtensionCard_HTML = StringReplace ($ExtensionCard_HTML, "by", "</a> &#8212; by")
	$ExtensionCard_HTML = $ExtensionCard_HTML & "<p>" & $ItemPubDate & "</p><p>" & $ItemDescription & "</p>"
	FileWrite($temp_html_file, $ExtensionCard_HTML)

	FileClose($temp_html_file)


	; Check if Already Exists
	;--------------------------------------------------------------------------------
		If Not FileExists($ItemArchiveFile) Then
			; Download Extension
			DirCreate ($DownloadFolder & "\" & $ItemAuthorCleaned)
			$FileToSave = $DownloadFolder & "\" & $ItemAuthorCleaned  & "\" & $ItemFileNameCleaned & ".i7x"
			InetGet ($ItemDownloadLink, $FileToSave, 1)
			If @error = 0 Then
				$DownloadResult = "Succeded"
				$DownloadedExtensions += 1 
				; Update Downloads Label
				if $DownloadedExtensions = 1 Then
					GUICtrlSetColor ($downloads_label, 0x49FF0D)
				EndIf
				GUICtrlSetData ($downloads_label, " Downloads: " & $DownloadedExtensions)

				; Change Downloaded Extension Creation Date
				$CreationDate= StringReplace ($ItemDate, "-", "") & "120000"
				FileSetTime($FileToSave, $CreationDate, 0)
				FileSetTime($FileToSave, $CreationDate, 1)
				
				; Copy to Inform 7 Extensions Folder
				if $extensions_folder_exists Then
					DirCreate ($I7_ExtensionsFolder & "\" & $ItemAuthorCleaned)
					FileCopy ($FileToSave, $I7_ExtensionsFolder & "\" & $ItemAuthorCleaned  & "\" & $ItemFileNameCleaned & ".i7x",1)
				EndIf
				
				; Create Archive copy for "Extensions Archive" folder
				FileCopy ($FileToSave, $ItemArchiveFile, 1)
			Else
				$DownloadResult = "Failed"
				$FailedDownloads += 1  
				; Update Errors Label
				if $FailedDownloads = 1 Then
					GUICtrlSetColor ($errors_label, 0xFF2200)
				EndIf
				GUICtrlSetData ($errors_label, " Errors: " & $FailedDownloads)
				; Delete HMTL Card!!!
				FileDelete ($temp_html_file_name)
			EndIf
			
			; Write to disk Log File
			;--------------------------------------------------------------------------------
			$LogText =	"_________________________________________"  & @CRLF & _
						"Extension # " & $counter & "/" & $TotalItems & " Download = " & $DownloadResult & @CRLF & _
						"_________________________________________"  & @CRLF & @CRLF &  _
						$ItemTitle & @CRLF & @CRLF & $ItemLink & @CRLF & _
						"Publication Date: " & $ItemPubDate & @CRLF & @CRLF & _
						$ItemDescription & @CRLF & @CRLF
			FileWrite($file, $LogText)
		EndIf
		
	;	MsgBox(0, "Counter = " & $counter, $ItemTitle & @CR & $ItemLink & @CR & $ItemPubDate & @CR & _
	;		$ItemAuthor  & @CR & $ItemFileName _
	;		& @CR & @CR & $ItemDescription )


	; Remove Item
	;--------------------------------------------------------------------------------
		$EndOfCurrItemPos = StringInStr ( $RSSFile, "</item>", 0, 1, 1 ) + StringLen ("</item>")
		$RSSFile = StringTrimLeft ($RSSFile, $EndOfCurrItemPos)

	;Sleep(500) ; FOR TEST ONLY!!!

	Next


	; Complete and Close Log File
	;--------------------------------------------------------------------------------
	$LogText =	"* * * * * *"  & @CRLF & @CRLF & "Job Completed." & @CRLF & @CRLF & _
				"Total Extensions Downloaded: " & $DownloadedExtensions & @CRLF & _
				"Failed Downloads: " & $FailedDownloads & @CRLF
	FileWrite($file, $LogText)

	FileClose($file)


	; Create HTML Extensions List
	;--------------------------------------------------------------------------------

	; Copy Header from AutoIT Install Dir to Script Dir
	$ExtListFile = @ScriptDir & "\Extensions List.htm"
	FileCopy  (@TempDir & "\header.html", $ExtListFile, 1)
	_ReplaceStringInFile($ExtListFile, "XXX", $JobTime)

	; Append HTML Extension cards
	$work_file = FileOpen($ExtListFile, 1)
	If $work_file = -1 Then
		MsgBox(0, "Error", "Unable to open file.")
		Exit
	EndIf

	FileChangeDir ($TempFolder)
	$search = FileFindFirstFile("*.*")  

	; Check if the search was successful
	If $search = -1 Then
		MsgBox(0, "Error", "No files/directories matched the search pattern")
		Exit
	EndIf

	While 1
		$file = FileFindNextFile($search) 
		If @error Then ExitLoop
		; MsgBox(4096, "File:", $file)
		$extension_html_text = FileRead ($file)
		FileWrite($work_file, $extension_html_text)
	WEnd

	; Close the search handle
	FileClose($search)

	$extension_html_text = FileRead (@TempDir & "\footer.html")
	FileWrite($work_file, $extension_html_text)

	; Close the temp extensions list file
	FileClose($work_file)
	
	; Delete TEMP folder
	DirRemove ($TempFolder, 1)

	$TASK_COMPLETED = True
	
	; Update GUI
	GUICtrlSetData ($button_start, "VIEW LOG")
	GUICtrlSetState ($button_start, $GUI_ENABLE )
	
EndFunc ; --- UpdateExtensions() Ends Here ! ---



;--------------------------------------------------------------------------------
; FUNCTION >>> UPDATE COUNTER
;--------------------------------------------------------------------------------
Func UpdateCounter ($counter_value)
	$TempTotal = _StringRepeat("0", 4-StringLen($counter_value)) & $counter_value
	$CounterString = $TempTotal
	GUICtrlSetData ($CounterLabel, $CounterString)
EndFunc


;--------------------------------------------------------------------------------
; FUNCTION >>> EXTRACT TAG
;--------------------------------------------------------------------------------
Func ExtractTag ($WorkText, $OpenTag)
	$CloseTag = StringReplace($OpenTag, "<", "</", 1, 0)
	$Tag_StartPos = StringInStr ( $WorkText, $OpenTag, 0, 1, 1 ) + StringLen ($OpenTag)
	$Tag_EndPos = StringInStr ( $WorkText, $CloseTag, 0, 1, 1 ) - $Tag_StartPos
	$TagContent =  StringMid($WorkText, $Tag_StartPos , $Tag_EndPos)
	Return $TagContent
EndFunc

;--------------------------------------------------------------------------------
; FUNCTION >>> CONVERT URL SPECIAL CHARACTERS
;--------------------------------------------------------------------------------
Func ConvertURLChars ($WorkString)
	$WorkString = StringReplace($WorkString, "%20", " ")
	$WorkString = StringReplace($WorkString, "&amp;", "&")
	Return $WorkString
EndFunc

;--------------------------------------------------------------------------------
; FUNCTION >>> CONVERT DATE
;--------------------------------------------------------------------------------
Func ConvertDate($Date_String)
	$ExplodedDate = _StringExplode($Date_String, " ")
	$Year = $ExplodedDate[3]
	$Day = $ExplodedDate[1]
	if StringLen ($Day) == 1 Then $Day = "0" & $Day
	$Month = $ExplodedDate[2]
	Switch $Month
		Case "Jan"
			$Month = "01"
		Case "Feb"
			$Month = "02"
		Case "Mar"
			$Month = "03"
		Case "Apr"
			$Month = "04"
		Case "May"
			$Month = "05"
		Case "Jun"
			$Month = "06"
		Case "Jul"
			$Month = "07"
		Case "Aug"
			$Month = "08"
		Case "Sep"
			$Month = "09"
		Case "Oct"
			$Month = "10"
		Case "Nov"
			$Month = "11"
		Case "Dec"
			$Month = "12"
		Case Else
			$Month = "xx"
	EndSwitch
	Return $Year & "-" & $Month & "-" & $Day
EndFunc

