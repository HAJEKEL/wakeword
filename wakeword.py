# Import required libraries
import pyaudio
import pyttsx3
import speech_recognition as sr

# Text-to-Speech function
def TTS(text):
    engine = pyttsx3.init('espeak') 
    voices = engine.getProperty('voices')
    engine.setProperty('voice', voices[12].id)  # You can dynamically choose the voice if needed
    print("Jarvis: " + text + "\n")
    engine.say(text)
    engine.runAndWait()

def STT():
    r = sr.Recognizer()
    with sr.Microphone() as source:
        print("Listening...")
        r.adjust_for_ambient_noise(source)
        audio = r.listen(source)
    try:
        print("Recognizing...")
        said = r.recognize_google(audio)
        print("You said: " + said + "\n")
    except Exception as e:
        print("Exception: " + str(e))
        return None
    return said

# Main function
if __name__ == "__main__":
    said = STT()
    if said:
        TTS("I heard you say " + said)
    else:
        TTS("I didn't hear anything, please try again.")
