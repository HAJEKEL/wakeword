import pyaudio
import pyttsx3

def speak(text):
    engine = pyttsx3.init('') 
    voices = engine.getProperty('voices')
    engine.setProperty('voice', voices[0].id)
    print("Jarvis: " + text + "\n")
    engine.say(text)
    engine.runAndWait()

speak("Hello, I am Jarvis. How can I help you?")