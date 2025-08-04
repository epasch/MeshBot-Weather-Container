# Serial Port Access Guide for Docker on macOS

This guide explains how to connect your Meshtastic device to the Docker container on macOS.

## 🚨 **macOS Docker Desktop Limitation**

Docker Desktop on macOS has limited access to USB/serial devices due to the virtualization layer. This is a known limitation.

## 🔧 **Solution Options**

### **Option 1: Network Mode (Recommended)**

If your Meshtastic device supports network connectivity:

1. **Configure your Meshtastic device** to enable the API server
2. **Use the current docker-compose.yml** which is already configured for network mode
3. **Connect to your device** via IP address or hostname

```bash
# Start the container
docker-compose up -d

# The container will automatically try network mode if no USB device is found
```

### **Option 2: Manual Device Specification**

If you need USB access, you can specify the device manually:

```bash
# Stop the container
docker-compose down

# Start with a specific device
docker run -d \
  --name meshbot-weather \
  --privileged \
  --device=/dev/tty.usbmodem1101:/dev/ttyUSB0 \
  -v $(pwd)/settings.yaml:/app/settings.yaml:ro \
  meshbotweathercontainer-meshbot-weather
```

### **Option 3: Use Docker Machine (Advanced)**

For better USB support, you can use Docker Machine with VirtualBox:

```bash
# Install Docker Machine
brew install docker-machine

# Create a Docker Machine with USB support
docker-machine create --driver virtualbox --virtualbox-usb meshbot

# Use the machine
eval $(docker-machine env meshbot)

# Run your container
docker-compose up -d
```

### **Option 4: Run Outside Docker**

If USB access is critical, run the application directly:

```bash
# Clone the original repository
git clone https://github.com/oasis6212/Meshbot_weather.git
cd Meshbot_weather

# Install dependencies
pip install -r requirements.txt

# Run with your device
python meshbot.py --port /dev/tty.usbmodem1101
```

## 🔍 **Troubleshooting**

### **Check Available Devices**

```bash
# On macOS
ls -la /dev/tty.usb*

# Inside container
docker-compose exec meshbot-weather ls -la /dev/tty*
```

### **Check Device Permissions**

```bash
# Make sure device is accessible
sudo chmod 666 /dev/tty.usbmodem1101
```

### **Test Device Connection**

```bash
# Test if device is accessible
screen /dev/tty.usbmodem1101 115200
# Press Ctrl+A, then K to exit
```

## 📋 **Current Configuration**

Your current `docker-compose.yml` is configured to:

1. **Try USB device first** (if specified in `MESHTASTIC_DEVICE` environment variable)
2. **Fall back to network mode** automatically
3. **Use host networking** for better device access
4. **Mount device directory** for USB access

## 🎯 **Recommended Approach**

1. **For development/testing**: Use network mode
2. **For production**: Consider running outside Docker if USB access is critical
3. **For deployment**: Use Docker Machine with VirtualBox for better USB support

## 📝 **Environment Variables**

You can customize the behavior with these environment variables:

```yaml
environment:
  - MESHTASTIC_DEVICE=/dev/tty.usbmodem1101  # USB device path
  - MESHTASTIC_HOST=192.168.1.100            # Network device IP
  - PYTHONUNBUFFERED=1                       # Python output
```

## 🔄 **Quick Commands**

```bash
# Start with current config
make run

# View logs
make logs

# Stop container
make stop

# Rebuild and restart
make build-run
``` 