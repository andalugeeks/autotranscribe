# AutoTranscribe

![andalûh2](https://user-images.githubusercontent.com/34275535/231167984-65f9cf1d-6532-4079-aadd-563e2d1f3fe0.png)

AutoTranscribe is an AutoHotkey script that transcribes Spanish spelling into the proposed Andalusian E.P.A. in real time. The script is designed to automate the transcription process and improve the efficiency of the proposed E.P.A. Andalusian text transcription.

![demo](https://user-images.githubusercontent.com/34275535/231208922-76c18dce-8f64-405c-b2a8-a715ed683dfa.gif)


## Usage
To use AutoTranscribe, simply run the script in AutoHotkey. Once the script is run, it will automatically transliterate any Spanish text you type into the proposed Andalusian E.P.A. in real time.

### Pause / Resume:
- `ctrl`+`alt`+`p` will pause / resume the program.
### Transliterate selected text: 
- `ctrl`+`alt`+`m` will transliterate the selected text.

You can pause or resume the script at any time by pressing Ctrl+Alt+P.

## Features
AutoTranscribe currently supports the following functions:

Real-time transcription from Spanish text to the proposed E.P.A. in Andalusian.
Pause and resume functionality with Ctrl+Alt+P.
Selected text transcription functionality with Ctrl+Alt+P.
We plan to add more features in the future to further improve the functionality of the script.

## How it works
**Andaluh.ahk / Andaluh.exe :** substitutes the written words by their spelling equivalent E.P.A.
This file takes care of the substitution logic and the handling and generation of the used lemmary.

**keyboardhook.ahk / keyboardhook.exe :** Handles the logic for the character keys and end-of-word keys, as well as the pause/resume and transcription commands for the selected text.

**filehandler.ahk / filehandler.exe :** This is responsible for adding content to the lemmary to increase speed and reduce computational cost.

**Andaluh-cli.exe :** Command line application. It is in charge of transcribing words or text.

**subs.txt :** Substitution lemmarian.


## Requirements
AutoTranscribe requires AutoHotkey to be installed on your system to work. AutoHotkey can be downloaded from the official website: https://www.autohotkey.com

But you can also run it as a standalone executable:
Download the installation file of the latest release. https://github.com/andalugeeks/autotranscribe/releases/tag/v0.0.5.0
You can also run the standalone executables without installation:
https://github.com/andalugeeks/autotranscribe/tree/main/Compiled and run Andaluh.exe
The executables have to be placed in a folder without spaces in the name. such as C:\Andaluh or C:\Autotranscribe\andaluh.


## Installation
To install AutoTranscribe, simply download the scripts from the GitHub repository and run Andaluh.ahk with AutoHotkey. or download the [Installer](https://github.com/andalugeeks/autotranscribe/releases/tag/v0.0.5.0)

## Contribute
We welcome any contributions to AutoTranscribe. If you have any suggestions for new features or improvements, feel free to open an issue or submit a pull request to the GitHub repository.## AutoTranscribe


