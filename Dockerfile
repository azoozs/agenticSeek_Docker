FROM python:3.10-slim

# Install Chrome and other dependencies
RUN apt-get update && apt-get install -y git build-essential portaudio19-dev libasound2-dev libjack-dev ffmpeg wget gnupg2 unzip fonts-liberation libasound2 libatk-bridge2.0-0 libatk1.0-0 libatspi2.0-0 libcups2 libdbus-1-3 libdrm2 libgbm1 libgtk-3-0 libnspr4 libnss3 libxcomposite1 libxdamage1 libxfixes3 libxkbcommon0 libxrandr2 xdg-utils && rm -rf /var/lib/apt/lists/*

# Install Chrome
RUN wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && apt-get update && apt-get install -y ./google-chrome-stable_current_amd64.deb && rm ./google-chrome-stable_current_amd64.deb && rm -rf /var/lib/apt/lists/*

# Clone the repository
RUN git clone https://github.com/Fosowl/agenticSeek.git /app
WORKDIR /app

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt && pip install --no-cache-dir pyaudio

# Create a modified start_services script that doesn't require Docker
RUN echo '#!/bin/bash\necho "Starting AgenticSeek with minimal services..."\n# We are skipping Docker-based services since we are already in Docker\n# This is a simplified version just to get the API running' > /app/start_minimal.sh && chmod +x /app/start_minimal.sh

# Modify the code to bypass SearxNG dependency
RUN sed -i 's/searxSearch( )/None/g' /app/sources/agents/browser_agent.py && sed -i 's/if "web_search" in self.tools and self.tools\["web_search"\] is not None:/if False:/g' /app/sources/agents/browser_agent.py

# Create work directory and update config
RUN mkdir -p /app/workspace && sed -i 's|work_dir =.*|work_dir = /app/workspace|g' config.ini

# Modify config.ini to ensure headless browser is enabled
RUN if [ -f config.ini ]; then sed -i 's/headless_browser = False/headless_browser = True/g' config.ini; fi

# Expose port for web interface
EXPOSE 5000

# Set Chrome path in environment
ENV CHROME_PATH=/usr/bin/google-chrome

# Run the application
CMD ["python", "api.py"]













# this Build Success
# FROM python:3.10-slim

# # Install Chrome and other dependencies
# RUN apt-get update && apt-get install -y git build-essential portaudio19-dev libasound2-dev libjack-dev ffmpeg wget gnupg2 unzip # Chrome dependencies fonts-liberation libasound2 libatk-bridge2.0-0 libatk1.0-0 libatspi2.0-0 libcups2 libdbus-1-3 libdrm2 libgbm1 libgtk-3-0 libnspr4 libnss3 libxcomposite1 libxdamage1 libxfixes3 libxkbcommon0 libxrandr2 xdg-utils && rm -rf /var/lib/apt/lists/*

# # Install Chrome
# RUN wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && apt-get update && apt-get install -y ./google-chrome-stable_current_amd64.deb && rm ./google-chrome-stable_current_amd64.deb && rm -rf /var/lib/apt/lists/*

# # Clone the repository
# RUN git clone https://github.com/Fosowl/agenticSeek.git /app
# WORKDIR /app

# # Install Python dependencies
# RUN pip install --no-cache-dir -r requirements.txt && pip install --no-cache-dir pyaudio

# # Create a modified start_services script that doesn't require Docker
# RUN echo '#!/bin/bash\n\
# echo "Starting AgenticSeek with minimal services..."\n\
# # We are skipping Docker-based services since we are already in Docker\n\
# # This is a simplified version just to get the API running\n\
# ' > /app/start_minimal.sh && chmod +x /app/start_minimal.sh

# # Expose port for web interface
# EXPOSE 5000

# # Set Chrome path in environment
# ENV CHROME_PATH=/usr/bin/google-chrome

# # Run the application
# CMD ["python", "api.py"]









# FROM python:3.10-slim
# RUN apt-get update && apt-get install -y git build-essential portaudio19-dev libasound2-dev libjack-dev ffmpeg && rm -rf /var/lib/apt/lists/*
# RUN git clone https://github.com/Fosowl/agenticSeek.git /app && cd /app && pip install --no-cache-dir -r requirements.txt && pip install --no-cache-dir pyaudio
# WORKDIR /app
# CMD ["python", "src/main.py"]  # Adjusted to match agenticSeek's actual entrypointl










# FROM python:3.10-slim

# # Install system deps in one line
# RUN apt-get update && apt-get install -y git build-essential && rm -rf /var/lib/apt/lists/*

# # Clone repo and install
# RUN git clone https://github.com/Fosowl/agenticSeek.git /app && cd /app && pip install -r requirements.txt

# WORKDIR /app

# # Set up communication port (adjust if needed)
# EXPOSE 5000

# # Start command (verify with project docs)
# CMD ["python", "main.py"] 




# # Use Python with full system dependencies (required for GUI)
# FROM python:3.9

# # Install PyQt6 and Windows-compatible X11 dependencies
# RUN apt-get update && apt-get install -y python3-pyqt6 xauth xvfb && rm -rf /var/lib/apt/lists/*

# WORKDIR /app
# COPY . .

# # Install PyQt6 via pip (more reliable than apt)
# RUN pip install PyQt6

# # Set display to Windows host (using VcXsrv)
# ENV DISPLAY=host.docker.internal:0

# CMD ["python", "main.py"]