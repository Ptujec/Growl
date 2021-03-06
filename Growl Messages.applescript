-- »Growl Messages« 
-- by @Ptujec  
-- 2012-06-09
--
-- Use: 
-- Display a Growl notification for when a Buddy is available/online or when someone is sending you a message with Messages (iChat). 
-- Klick on the notification to start or continue a conversation. 
--
-- Installation:
-- In Messages.app go to Preferences/Alerts and select the script for both "Buddy becomes Available" and "Message Received"
--
-- Sources:
-- http://forums.macrumors.com/showthread.php?t=532910
-- http://scriptingosx.com/2010/11/ichat-notification-with-growl/
--
-- Known Issues:
-- → something doesn't work with getting the service type (Jabber, AIM, etc.) therefore I had to set it manually to "Jabber" since that is what I mostly use

using terms from application "iChat"
	
	on buddy became available theBuddy
		my growlRegister()
		
		tell application "iChat"
			tell theBuddy
				-- set _service to service type of service of theBuddy
				set _service to "Jabber"
				set _handle to handle of theBuddy
				set grrCURL to "iChat:compose?service=" & _service & "&id=" & _handle & "&style=textchat"
				
				if _handle contains "facebook" then
					set _platform to "Facebook"
				else if _handle contains "google" then
					set _platform to "GTalk"
				else if _handle contains "gmail" then
					set _platform to "GTalk"
				else
					set _platform to "Messages"
				end if
				
				set grrTitle to full name
				set grrDescription to _platform & "\n" & status message
				set grrPriority to 0
				set grrIcon to image
			end tell
		end tell
		growlNotify(grrTitle, grrDescription, grrPriority, grrIcon, grrCURL)
	end buddy became available
	
	on message received theText from theBuddy
		my growlRegister()
		
		tell application "iChat"
			-- set _service to service type of service of theBuddy
			set _service to "Jabber"
			set _handle to handle of theBuddy
			set grrCURL to "iChat:compose?service=" & _service & "&id=" & _handle & "&style=textchat"
			set grrIcon to image of theBuddy
			set grrTitle to full name of theBuddy & ":"
			set grrDescription to theText
			set grrPriority to 0
		end tell
		my growlNotify(grrTitle, grrDescription, grrPriority, grrIcon, grrCURL)
	end message received
	
end using terms from

on growlRegister()
	tell application "Growl"
		register as application "Growl Messages" all notifications {"Alert"} default notifications {"Alert"} icon of application "iChat"
	end tell
end growlRegister

on growlNotify(grrTitle, grrDescription, grrPriority, grrIcon, grrCURL)
	tell application "Growl"
		if grrIcon is "" or grrIcon is missing value then
			notify with name "Alert" title grrTitle description grrDescription priority grrPriority application name "iChat - Kontakt online" icon of application "iChat" callback URL grrCURL
		else
			notify with name "Alert" title grrTitle description grrDescription priority grrPriority application name "iChat - Kontakt online" image grrIcon callback URL grrCURL
		end if
	end tell
end growlNotify