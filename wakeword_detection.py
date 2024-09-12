import pvporcupine
import sounddevice as sd
import numpy as np
import os
from decouple import config

# Path to your downloaded Porcupine wake word model and license
access_key = config("ACCESS_KEY")
keyword_paths = ['/workspaces/wakeword/Focus-Point_en_linux_v3_0_0.ppn']
print(access_key)
print(keyword_paths)
# Initialize the wake word engine
porcupine = pvporcupine.create(
    access_key=access_key,  # Replace with your Picovoice access key
    keyword_paths=keyword_paths  # Custom wake word model
)

# Callback function for audio processing
def audio_callback(indata, frames, time, status):
    pcm = np.int16(indata[:, 0] * 32767)  # Convert audio to PCM format
    result = porcupine.process(pcm)
    
    if result >= 0:
        print("Wake word 'Focus Point' detected!")
        # Trigger action (e.g., capture camera feed)
        capture_camera_feed()

# Function to capture camera feed (replace this with your actual camera capture logic)
def capture_camera_feed():
    print("Capturing camera feed...")

# Start recording audio
with sd.InputStream(channels=1, samplerate=porcupine.sample_rate, callback=audio_callback, blocksize=porcupine.frame_length):
    print("Listening for wake word...")
    while True:
        sd.sleep(1000)
