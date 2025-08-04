# Use Python 3.11 slim image as base
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    && rm -rf /var/lib/apt/lists/*

# Fetch source code from original repository
RUN git clone https://github.com/oasis6212/Meshbot_weather.git /tmp/meshbot_weather && \
    cp -r /tmp/meshbot_weather/* . && \
    cp /tmp/meshbot_weather/.* . 2>/dev/null || true && \
    rm -rf /tmp/meshbot_weather

# Copy our custom scripts
COPY scripts/ ./scripts/

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Create a non-root user for security
RUN useradd -m -u 1000 meshbot && \
    chown -R meshbot:meshbot /app && \
    usermod -a -G dialout meshbot

# Switch to non-root user
USER meshbot

# Expose any necessary ports (if needed)
# EXPOSE 8080

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV PYTHONPATH=/app

# Default command to run the bot
CMD ["./scripts/start-meshbot.sh"] 