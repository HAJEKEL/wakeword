# This is a copy of the dockerfile that I use for the backend
# Use an official Python 3 runtime as a parent image
FROM python:3.9


# In dockerfiles we use apt-get to install packages instead of 
# apt because apt-get is more low-level and suitable for scripting

# Install ping, iproute2, and vim
# Always run apt-get update because docker will otherwise use a cached version of the package list                                               
RUN apt-get update && apt-get install -y \ 
    # iputils-ping for ping command
    iputils-ping \
    # iproute2 for ip command
    iproute2 \
    # vim for editing files
    vim \
    # curl for downloading files
    curl \
    # portaudio19-dev for pyaudio
    portaudio19-dev \
    # espeak for text-to-speech
    espeak \
    # alsa-utils, ffmpeg and libsound2 for testing audio
    alsa-utils \
    pulseaudio \
    ffmpeg \
    #libasound2-plugins \
    jackd2 \
    libportaudio2 \
    libportaudiocpp0 \
    libsndfile1-dev \
    portaudio19-dev \
    python3 \
    python3-dev \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user to match the host user and group id 
ARG USERNAME=henk
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
  && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
  # Create a home directory and a config directory for the user as some programs expect these to exist
  && mkdir /home/$USERNAME/.config && chown $USER_UID:$USER_GID /home/$USERNAME/.config 

# Add the user to the sudo group and allow it to run sudo commands without a password 
RUN apt-get update \
  && apt-get install -y sudo \
  && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME\
  && chmod 0440 /etc/sudoers.d/$USERNAME \
  && rm -rf /var/lib/apt/lists/*

# Create the PulseAudio configuration directory for the user
RUN mkdir -p /home/$USERNAME/.config/pulse \
    && chown -R $USERNAME:$USERNAME /home/$USERNAME/.config/pulse

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file into the container at /app
COPY requirements.txt /app/

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code into the container
COPY . /app

# Make the container run as the non-root user
USER $USERNAME
