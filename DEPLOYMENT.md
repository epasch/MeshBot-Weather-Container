# Deployment Guide

This guide explains how to deploy the MeshbotWeatherContainer to Docker Hub and set up automated builds with GitHub Actions.

## Prerequisites

1. **Docker Hub Account**: Create an account at [hub.docker.com](https://hub.docker.com)
2. **GitHub Account**: For repository hosting and GitHub Actions
3. **Docker Hub Access Token**: For automated pushes

## Step 1: Prepare Your Repository

### Fork or Create Repository

1. **Option A: Fork this repository**
   ```bash
   # Fork the repository on GitHub, then clone
   git clone https://github.com/yourusername/MeshbotWeatherContainer.git
   cd MeshbotWeatherContainer
   ```

2. **Option B: Create new repository**
   ```bash
   # Clone this repository and change remote
   git clone https://github.com/original-owner/MeshbotWeatherContainer.git
   cd MeshbotWeatherContainer
   git remote set-url origin https://github.com/yourusername/MeshbotWeatherContainer.git
   ```

### Update Repository Name

Edit the GitHub Actions workflow to use your repository name:

```yaml
# In .github/workflows/docker-build.yml
env:
  REGISTRY: docker.io
  IMAGE_NAME: yourusername/meshbot-weather  # Change this
```

## Step 2: Set Up Docker Hub

### Create Access Token

1. Go to [Docker Hub](https://hub.docker.com)
2. Navigate to Account Settings → Security
3. Click "New Access Token"
4. Give it a name (e.g., "GitHub Actions")
5. Copy the token (you won't see it again)

### Create Repository on Docker Hub

1. Go to [Docker Hub](https://hub.docker.com)
2. Click "Create Repository"
3. Name it `meshbot-weather` (or your preferred name)
4. Set visibility (Public or Private)
5. Click "Create"

## Step 3: Configure GitHub Secrets

1. Go to your GitHub repository
2. Navigate to Settings → Secrets and variables → Actions
3. Click "New repository secret"
4. Add the following secrets:

   **DOCKER_USERNAME**
   - Name: `DOCKER_USERNAME`
   - Value: Your Docker Hub username

   **DOCKER_PASSWORD**
   - Name: `DOCKER_PASSWORD`
   - Value: Your Docker Hub access token (not your password)

## Step 4: Test Local Build

Before pushing to GitHub, test the build locally:

```bash
# Fetch source and build
make setup
make build

# Test the image
docker run --rm -it meshbot-weather python -c "print('Build successful!')"
```

## Step 5: Push to GitHub

```bash
# Add all files
git add .

# Commit changes
git commit -m "Initial Docker container setup"

# Push to GitHub
git push origin main
```

## Step 6: Verify GitHub Actions

1. Go to your GitHub repository
2. Click the "Actions" tab
3. You should see the "Build and Push Docker Image" workflow running
4. Check that it completes successfully

## Step 7: Test Docker Hub Image

Once the workflow completes, test the image from Docker Hub:

```bash
# Pull the image
docker pull yourusername/meshbot-weather:latest

# Test it
docker run --rm -it yourusername/meshbot-weather python -c "print('Docker Hub image works!')"
```

## Automated Updates

### Source Code Updates

The repository includes a workflow that automatically fetches updates from the original Meshbot_weather repository:

- **Schedule**: Runs daily at 2 AM UTC
- **Manual**: Can be triggered manually from the Actions tab
- **Pull Requests**: Creates PRs when updates are detected

### Version Management

To create a new version:

```bash
# Create and push a tag
git tag v1.0.0
git push origin v1.0.0
```

This will trigger a build with the version tag.

## Production Deployment

### Using Docker Compose

```bash
# Create production settings
cp settings.yaml.example settings.yaml
# Edit settings.yaml with your configuration

# Run with docker-compose
docker-compose up -d
```

### Using Docker Directly

```bash
# Pull latest image
docker pull yourusername/meshbot-weather:latest

# Run container
docker run -d \
  --name meshbot-weather \
  --restart unless-stopped \
  -v $(pwd)/settings.yaml:/app/settings.yaml:ro \
  yourusername/meshbot-weather:latest
```

### Using Docker Compose with Custom Image

```yaml
# docker-compose.yml
services:
  meshbot-weather:
    image: yourusername/meshbot-weather:latest
    container_name: meshbot-weather
    restart: unless-stopped
    volumes:
      - ./settings.yaml:/app/settings.yaml:ro
```

## Monitoring and Maintenance

### View Logs

```bash
# Docker Compose
docker-compose logs -f

# Docker directly
docker logs -f meshbot-weather
```

### Update Container

```bash
# Pull latest image
docker pull yourusername/meshbot-weather:latest

# Restart container
docker-compose down
docker-compose up -d
```

### Health Checks

The container includes basic health monitoring. Check container status:

```bash
docker ps
docker stats meshbot-weather
```

## Troubleshooting

### GitHub Actions Failures

1. **Authentication Error**: Check Docker Hub secrets
2. **Build Error**: Check Dockerfile syntax
3. **Push Error**: Verify repository permissions

### Container Issues

1. **Won't Start**: Check logs with `docker logs meshbot-weather`
2. **Configuration Error**: Verify `settings.yaml` syntax
3. **Network Issues**: Check Meshtastic device connectivity

### Common Commands

```bash
# Check workflow status
gh run list

# View workflow logs
gh run view --log

# Manually trigger workflow
gh workflow run docker-build.yml
```

## Security Considerations

1. **Access Tokens**: Use access tokens, not passwords
2. **Repository Visibility**: Consider private repositories for sensitive configurations
3. **Image Scanning**: Enable Docker Hub vulnerability scanning
4. **Regular Updates**: Keep base images updated

## Support

- **GitHub Issues**: Report problems in the repository
- **Docker Hub**: Check image status and logs
- **Original Project**: For Meshbot_weather specific issues 