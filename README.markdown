This app shapes white noise (triggered via button) with an ADSR envelope.
It builds upon http://github.com/dreamwieber/noise-trigger

Demonstrates a basic strategy for modeling components of an instrument, allowing the UI layer to deal with objects and messages, while encapsulating all of the internals in a process block so the Core Audio thread doesn't need to interact with the Objective-C runtime. 

Run:

	git submodule init
	
	git submodule update
	

Add TheAmazingAudioEngine/TheAmazingAudioEngine.xcproject to your project at the top-level. Xcode will ask you to create a workspace from your project. Build and run from the workspace.
