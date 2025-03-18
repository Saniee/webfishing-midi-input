#Requires AutoHotkey v2
#Include lib/AutoHotInterception/Lib/AutoHotInterception.ahk

AHI := AutoHotInterception()
/*
	You are required to find these yourself via the AHK monitor script located under lib/AutoHotInterception/Monitor.ahk. Paste the copied codes inbetween the brackets.
*/
keyboardId := AHI.GetKeyboardId(0x0, 0x0)

;*************************************************
;*          RULES - MIDI FILTERS
;*************************************************

/*
	The MidiRules section is for mapping MIDI input to actions.
	Alter these functions as required.
*/

ProcessNote(device, channel, note, velocity, isNoteOn) {
    if (note == 48 AND velocity > 0) {
        SendKeyDown("q")
        Sleep(50)
        SendKeyUp("q")
    }
    if (note == 50 AND velocity > 0) {
        SendKeyDown("w")
        Sleep(50)
        SendKeyUp("w")
    }
    if (note == 52 AND velocity > 0) {
        SendKeyDown("e")
        Sleep(50)
        SendKeyUp("e")
    }
    if (note == 53 AND velocity > 0) {
        SendKeyDown("r")
        Sleep(50)
        SendKeyUp("r")
    }
    if (note == 55 AND velocity > 0) {
        SendKeyDown("t")
        Sleep(50)
        SendKeyUp("t")
    }
    if (note == 57 AND velocity > 0) {
        SendKeyDown("y")
        Sleep(50)
        SendKeyUp("y")
    }
}

ProcessCC(device, channel, cc, value) {

}

ProcessPC(device, channel, note, velocity) {

}

ProcessPitchBend(device, channel, value) {

}

SendKeyUp(key) {
    AHI.SendKeyEvent(keyboardId, GetKeySC(key), 0)
}

SendKeyDown(key) {
    AHI.SendKeyEvent(keyboardId, GetKeySC(key), 1)
}
