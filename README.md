# webfishing-midi-input

Using the great [Midi to Macro](https://github.com/laurence-myers/midi-to-macro) repo. And [AHI](https://github.com/evilC/AutoHotInterception). You can now map your midi keyboard, or any midi device to work with WEBFISHING. <br> (Technically any game tbh, but the defaults (`In MidiRules.ahk`) are mapped for WEBFISHING).

## Setup

1. You need to acquire your keyboard ID, via the AHI Monitor script located under `lib/AutoHotInterception/Monitor.ahk`, tick any of the listed keyboards until you see inputs being shown in the white tabs. Thats your keyboard, copy its VID & PID and paste it in line 8 of `MidiRules.ahk`.
2. Once you have your keyboard setup, its time to launch `MidiToMacro.ahk`, where you can then select your midi device. And see it already works with the default rules. If not, pay attention to the Byte1 Number whenever you press a note. You want to use that to change the default values like so:

```
if (note == your note number here AND velocity > 0) {
    ; Any key here from the ones webfishing uses, or any other game.
    ; For webfishing these are: Q, W, E, R, T, Y
    SendKeyDown("")
    Sleep(50)
    SendKeyUp("")
}
```

3. Try it out! If setup correctly, you should now be able to play the guitar with your midi device.

## Limitations

Technically this is still limited by how windows and AHK handle key inputs, as you need some delay for key presses.. Which may result in some borked things happening like not registering your inputs etc., you can try lowering the `Sleep()` time down to maybe 25 or lower, but I am unsure if it would work better.

## Adding rules, AKA mapping midi input to keys.

### These instructions are from the forked repo, but can help whenever mapping these into other games.

You can add rules to the file `MidiRules.ahk`.

There are four handler functions you can modify:

- `ProcessNote`: handles note on/off events
- `ProcessCC`: handles CC (Control Change, or Continuous Control) events
- `ProcessPC`: handles patch change events
- `ProcessPitchBend`: handle pitch bend events

Within each function, you can have a series of `if/else` blocks.

```
if (cc = 21) {
    ; ...
} else if (cc = 51) {
    ; ...
} else if (cc = 52 and value != 0) {
    ; ...
}
```

A rule to toggle the mute button when receiving CC 51 might look like this:

```
if (cc = 51) {
    Send("{Volume_Mute}")
    DisplayOutput("Volume", "Mute")
}
```

`Send("{Volume_Mute}")` simulates pressing the "mute" button on your keyboard. `DisplayOutput("Volume", "Mute")` logs a message to the MidiMon GUI.

A rule to press the play/pause button might look like this:

```
if (cc = 54 and value != 0) {
    Send("{Media_Play_Pause}")
    DisplayOutput("Media", "Play/Pause")
}
```

`value != 0` lets us detect button presses, and ignores button releases, on our MIDI controller. (Without this clause, we'd send the keyboard macro twice; once for the button press, and agin for the button release.)

Here's a rule to map a continuous control from a slider to the main Windows mixer volume:

```
if (cc = 21 or cc = 29) {
    scaledValue := ConvertCCValueToScale(value, 0, 127)
    volume := scaledValue * 100
    SoundSetVolume(volume)
    DisplayOutput("Volume", Format('{1:.2f}', volume))
}
```

`ConvertCCValueToScale` is a utility function from `lib\CommonFunctions.ahk`. It converts a value in a given range, into a floating point number between 0 and 1.

Here's a rule to trigger a keyboard shortcut in a specific application; in this example, Sound Forge 9:

```
if (cc = 58 and value != 0) {
    ; Place a cue marker in Sound Forge 9
    try {
        ControlSend("{Alt down}m{Alt up}", , "ahk_class #32770")
        DisplayOutput("Sound Forge", "Place Cue Marker")
    } catch TargetError {
        ; Window doesn't exist, oh well
    }
}
```

You can use AutoHotKey's "WindowSpy" script to identify windows, or controls within an application, for use with `ahk_class`.

You can find [a list of standard CC messages online](https://web.archive.org/web/20231215150816/https://www.midi.org/specifications-old/item/table-3-control-change-messages-data-bytes-2). You could use any control number without a specified control function, including numbers between 20-31, 52-63, and 102-119. But, any control number should work fine.

## Credits for the forked repo:

Originally made by [laurence-myers](https://github.com/laurence-myers), modified to work in any game with the use of [AHI](https://github.com/evilC/AutoHotInterception).

This script was, in various forms and evolutions, originally based on work by AHK forum members, including (in no particular order):

- genmce
- Orbik
- TomB
- Lazslo

Thanks to [William Wong](https://github.com/compulim), for his implementation of `OpenMidiInput`. (See [autohotkey-boss-fs-1-wl](https://github.com/compulim/autohotkey-boss-fs-1-wl)).
