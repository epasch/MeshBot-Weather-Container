# Setup Guide for MeshbotWeatherContainer

This guide will walk you through setting up the MeshbotWeatherContainer for your Meshtastic weather bot.

## Prerequisites

1. **Docker and Docker Compose** installed on your system
2. **Git** for cloning the repository
3. **A Meshtastic device** (USB or network-connected)
4. **Your location coordinates** for weather data

## Step 1: Clone the Repository

```bash
git clone git@github.com:epasch/MeshBot-Weather-Container.git
cd MeshBot-Weather-Container
```

## Step 2: Initial Setup

Run the setup command to fetch the latest source code and create your configuration:

```bash
make setup
```

This will:
- Fetch the latest source code from the original Meshbot_weather repository
- Create a `settings.yaml` file from the example

## Step 3: Configure Your Settings

Edit the `settings.yaml` file with your specific configuration:

### Required Settings

1. **NWS Coordinates** (National Weather Service):
   - Go to [weather.gov](https://weather.gov)
   - Enter your address
   - Visit `https://api.weather.gov/points/XX.XXXX,YY.YYYY` (replace with your coordinates)
   - Extract `gridId`, `gridX`, and `gridY` values

2. **Alert Location**:
   - Set `ALERT_LAT` and `ALERT_LON` to your latitude and longitude
   - Use no more than 4 decimal places

3. **User Agent Information**:
   - Set `USER_AGENT_APP` to a unique name for your application
   - Set `USER_AGENT_EMAIL` to your email address

### Example Configuration

```yaml
# National Weather Service Settings
NWS_OFFICE: "LOX" 
NWS_GRID_X: "155"
NWS_GRID_Y: "45"

# User Agent for NWS API calls
USER_AGENT_APP: "my-meshbot-weather" 
USER_AGENT_EMAIL: "your-email@example.com" 

# Alert location coordinates
ALERT_LAT: "34.0522" 
ALERT_LON: "-118.2433"
```

## Step 4: Meshtastic Device Connection

### USB Connection

If your Meshtastic device is connected via USB:

1. Uncomment the devices section in `docker-compose.yml`:
   ```yaml
   devices:
     - "/dev/ttyUSB0:/dev/ttyUSB0"
   ```

2. Ensure proper permissions:
   ```bash
   sudo chmod 666 /dev/ttyUSB0
   ```

### Network Connection

If your Meshtastic device is connected via network:

1. Uncomment the ports section in `docker-compose.yml`:
   ```yaml
   ports:
     - "4403:4403"  # Meshtastic default port
   ```

## Step 5: Build and Run

### Option 1: Using Makefile (Recommended)

```bash
# Build and run in one command
make build-run

# Or step by step
make build
make run
```

### Option 2: Using Docker Compose Directly

```bash
# Build the image
docker-compose build

# Run the container
docker-compose up -d
```

### Option 3: Using Docker Directly

```bash
# Build the image
docker build -t meshbot-weather .

# Run the container
docker run -d \
  --name meshbot-weather \
  --restart unless-stopped \
  -v $(pwd)/settings.yaml:/app/settings.yaml:ro \
  meshbot-weather
```

## Step 6: Verify Installation

1. **Check container status**:
   ```bash
   make status
   # or
   docker-compose ps
   ```

2. **View logs**:
   ```bash
   make logs
   # or
   docker-compose logs -f
   ```

3. **Test the bot**:
   - Connect to your Meshtastic mesh network
   - Send `?` to the bot to see available commands
   - Try `test` to verify the alert system

## Common Commands

```bash
# View help
make help

# Stop the container
make stop

# Restart the container
make restart

# Open shell in container
make shell

# Clean up everything
make clean

# Fetch latest source code
make fetch-source
```

## Troubleshooting

### Container Won't Start

1. **Check logs**:
   ```bash
   make logs
   ```

2. **Common issues**:
   - Missing `settings.yaml` file
   - Incorrect NWS coordinates
   - USB device permissions
   - Network connectivity issues

### Permission Denied on USB Device

```bash
sudo chmod 666 /dev/ttyUSB0
```

### Settings File Issues

1. Ensure `settings.yaml` exists in the project directory
2. Check YAML syntax (use a YAML validator)
3. Verify all required fields are set

### Network Connection Issues

1. Check if your Meshtastic device is accessible on the network
2. Verify the port configuration in `docker-compose.yml`
3. Test connectivity: `telnet your-device-ip 4403`

## Updating

To update to the latest version:

```bash
# Fetch latest source and rebuild
make fetch-source
make build-run
```

## GitHub Actions Setup

To enable automatic Docker Hub builds:

1. **Fork this repository** to your GitHub account
2. **Add Docker Hub secrets**:
   - Go to your repository Settings → Secrets and variables → Actions
   - Add `DOCKER_USERNAME` with your Docker Hub username
   - Add `DOCKER_PASSWORD` with your Docker Hub access token

3. **Push to main branch** or create a release tag to trigger builds

## Support

- **Docker issues**: Check the logs with `make logs`
- **Meshbot_weather issues**: See the [original repository](https://github.com/oasis6212/Meshbot_weather)
- **Meshtastic issues**: Visit [meshtastic.org](https://meshtastic.org) 