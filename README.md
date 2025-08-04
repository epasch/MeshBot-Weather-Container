# MeshbotWeatherContainer

A Docker container for the [Meshbot_weather](https://github.com/oasis6212/Meshbot_weather) project - a full-featured Meshtastic weather bot with alerts and forecast capabilities.

## 🚀 Quick Start

```bash
# Clone the repository
git clone https://github.com/yourusername/MeshbotWeatherContainer.git
cd MeshbotWeatherContainer

# Initial setup (fetches source and creates config)
make setup

# Build and run
make build-run
```

## 📋 Features

- **🌤️ Weather Forecasts**: Multi-day and hourly forecasts
- **⚠️ Weather Alerts**: Automatic severe weather alerts from NWS
- **📡 Mesh Integration**: Works with Meshtastic mesh networks
- **🐳 Docker Ready**: Containerized for easy deployment
- **🤖 Automated Builds**: GitHub Actions for Docker Hub releases
- **📝 Easy Configuration**: Simple YAML-based setup

## 📖 Documentation

- **[Setup Guide](SETUP.md)** - Complete setup instructions
- **[Deployment Guide](DEPLOYMENT.md)** - Docker Hub and GitHub Actions setup
- **[Original Project](https://github.com/oasis6212/Meshbot_weather)** - Source repository

## 🛠️ Usage

### Using Makefile (Recommended)

```bash
# View all available commands
make help

# Initial setup
make setup

# Build and run
make build-run

# View logs
make logs

# Stop container
make stop
```

### Using Docker Compose

```bash
# Build and run
docker-compose up -d

# View logs
docker-compose logs -f

# Stop
docker-compose down
```

### Using Docker Directly

```bash
# Build image
docker build -t meshbot-weather .

# Run container
docker run -d \
  --name meshbot-weather \
  --restart unless-stopped \
  -v $(pwd)/settings.yaml:/app/settings.yaml:ro \
  meshbot-weather
```

## ⚙️ Configuration

1. **Copy the example settings**:
   ```bash
   cp settings.yaml.example settings.yaml
   ```

2. **Edit `settings.yaml`** with your configuration:
   - NWS coordinates (get from [weather.gov](https://weather.gov))
   - Alert location (latitude/longitude)
   - User agent information
   - Access control settings

3. **Configure Meshtastic device**:
   - USB: Uncomment devices section in `docker-compose.yml`
   - Network: Uncomment ports section in `docker-compose.yml`

## 🔧 Bot Commands

Once running, interact with the bot through your Meshtastic mesh network:

- `?` or `menu` - Show available commands
- `hourly` - 24-hour hourly forecast
- `5day` - 5-day detailed forecast
- `7day` - 7-day forecast
- `alert` - Current weather alerts
- `test` - Test alert system

## 🐳 Docker Hub

This container is automatically built and pushed to Docker Hub via GitHub Actions.

### Pull from Docker Hub

```bash
docker pull yourusername/meshbot-weather:latest
```

## 🔄 Automated Updates

- **Source Updates**: Daily automatic fetch from original repository
- **Docker Builds**: Automatic builds on pushes and releases
- **Version Tags**: Semantic versioning support

## 📁 Project Structure

```
MeshbotWeatherContainer/
├── Dockerfile              # Container definition
├── docker-compose.yml      # Docker Compose configuration
├── Makefile               # Build and management commands
├── scripts/               # Utility scripts
├── .github/               # GitHub Actions workflows
├── settings.yaml.example  # Example configuration
├── SETUP.md              # Detailed setup guide
├── DEPLOYMENT.md         # Deployment instructions
└── README.md             # This file
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Original Meshbot_weather project by [oasis6212](https://github.com/oasis6212/Meshbot_weather)
- Meshtastic community for the underlying mesh networking technology

## 🆘 Support

- **Docker issues**: Check logs with `make logs`
- **Meshbot_weather issues**: See the [original repository](https://github.com/oasis6212/Meshbot_weather)
- **Meshtastic issues**: Visit [meshtastic.org](https://meshtastic.org)
- **GitHub Issues**: Report problems in this repository

---

**Note**: This project is neither endorsed by nor supported by Meshtastic. Meshtastic® is a registered trademark of Meshtastic LLC.