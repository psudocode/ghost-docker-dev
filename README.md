# Ghost Development Environment with Docker

A complete Docker-based development environment for Ghost theme development. This setup provides a containerized Ghost instance with easy theme mounting, database management, and development tools.

## 🚀 Features

- **Docker Compose Setup**: Easy one-command Ghost deployment
- **Theme Development**: Hot-reload theme mounting for development
- **SQLite Database**: Lightweight database perfect for development
- **Environment Variables**: Flexible configuration via `.env` file
- **Development Tools**: Optional SQLite browser for database inspection
- **Helper Scripts**: Convenient bash script for common operations
- **Health Checks**: Built-in container health monitoring

## 📋 Prerequisites

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- Git

## 🏗️ Quick Start

### 1. Download or Clone

Download this repository or clone it to your local machine:

```bash
# If using git
git clone <repository-url>
cd ghost-docker-dev

# Or download and extract the ZIP file
# Then navigate to the extracted directory
cd ghost-docker-dev
```

### 2. Quick Setup (Recommended)

```bash
# Interactive setup - configures everything for you
./setup.sh
```

### 3. Manual Setup (Alternative)

```bash
# Copy the example environment file
cp .env.example .env

# Edit the configuration (optional)
nano .env

# Start Ghost
./ghost-dev.sh start
```

### 4. Access Ghost

- **Frontend**: http://localhost:3001
- **Admin Panel**: http://localhost:3001/ghost
- **SQLite Browser** (optional): http://localhost:8080

### 5. Initial Setup

1. Go to http://localhost:3001/ghost
2. Create your admin account
3. Complete the Ghost setup wizard

## 🎨 Theme Development

### Method 1: Mount Existing Theme

1. **Edit `.env` file**:

   ```env
   THEME_NAME=my-awesome-theme
   THEME_PATH=/path/to/your/theme/directory
   ```

2. **Uncomment the volume mount** in `docker-compose.yml`:

   ```yaml
   volumes:
     - ghost_content:/var/lib/ghost/content
     - ${THEME_PATH}:/var/lib/ghost/content/themes/${THEME_NAME} # Uncomment this line
     - ./logs:/var/lib/ghost/logs
   ```

3. **Restart Ghost**:
   ```bash
   ./ghost-dev.sh restart
   ```

### Method 2: Upload Theme via Admin

1. Create a ZIP file of your theme
2. Go to Admin → Design → Change Theme
3. Upload your theme ZIP file
4. Activate the theme

### Development Workflow

```bash
# Make changes to your theme files
# Then restart Ghost to see changes
./ghost-dev.sh restart

# Watch logs for debugging
./ghost-dev.sh logs

# Check status
./ghost-dev.sh status
```

## 🛠️ Helper Script Commands

The `ghost-dev.sh` script provides convenient shortcuts:

```bash
./ghost-dev.sh start       # Start Ghost development environment
./ghost-dev.sh stop        # Stop Ghost
./ghost-dev.sh restart     # Restart Ghost (after theme changes)
./ghost-dev.sh logs        # Show Ghost logs
./ghost-dev.sh status      # Check Ghost status
./ghost-dev.sh env         # Check environment configuration
./ghost-dev.sh open        # Open Ghost frontend in browser
./ghost-dev.sh admin       # Open Ghost admin panel in browser
./ghost-dev.sh clean       # Clean restart (removes containers, keeps data)
./ghost-dev.sh reset       # Reset everything (WARNING: destroys all data)
./ghost-dev.sh help        # Show help message
```

## ⚙️ Configuration

### Environment Variables

| Variable              | Default                 | Description             |
| --------------------- | ----------------------- | ----------------------- |
| `GHOST_PORT`          | `3001`                  | Port for Ghost frontend |
| `GHOST_URL`           | `http://localhost:3001` | Ghost URL               |
| `NODE_ENV`            | `development`           | Node environment        |
| `THEME_NAME`          | `your-theme-name`       | Theme directory name    |
| `THEME_PATH`          | `/path/to/your/theme`   | Path to theme directory |
| `DATABASE_CLIENT`     | `sqlite3`               | Database client         |
| `LOG_LEVEL`           | `info`                  | Logging level           |
| `SQLITE_BROWSER_PORT` | `8080`                  | SQLite browser port     |

### Advanced Configuration

For production use or advanced features, you can uncomment and configure additional variables in `.env`:

```env
# Email Configuration
GHOST_MAIL_TRANSPORT=SMTP
GHOST_MAIL_FROM=noreply@yourdomain.com
GHOST_MAIL_HOST=smtp.gmail.com
GHOST_MAIL_PORT=587
GHOST_MAIL_USERNAME=your-email@gmail.com
GHOST_MAIL_PASSWORD=your-app-password

# Social Media
GHOST_TWITTER=@yourusername
GHOST_FACEBOOK=your-facebook-page
```

## 🗄️ Database Management

### SQLite Browser (Development Tool)

Start with the SQLite browser for database inspection:

```bash
# Start all services including SQLite browser
docker-compose --profile tools up -d

# Access at http://localhost:8080
```

### Backup and Restore

```bash
# Backup Ghost data
docker-compose exec ghost tar -czf /tmp/ghost-backup.tar.gz -C /var/lib/ghost/content .
docker cp ghost-dev:/tmp/ghost-backup.tar.gz ./backup-$(date +%Y%m%d).tar.gz

# Restore Ghost data (be careful!)
docker cp ./backup-20231215.tar.gz ghost-dev:/tmp/
docker-compose exec ghost tar -xzf /tmp/backup-20231215.tar.gz -C /var/lib/ghost/content
```

## 📁 Project Structure

```
ghost-docker-dev/
├── docker-compose.yml      # Docker Compose configuration
├── .env.example           # Environment variables template
├── .env                   # Your environment variables (create from .env.example)
├── .gitignore            # Git ignore file
├── ghost-dev.sh          # Helper script for development
├── setup.sh              # Interactive setup script
├── validate-setup.sh     # Docker setup validation script
├── README.md             # This file
├── LICENSE               # MIT License
├── CONTRIBUTING.md       # Contribution guidelines
└── logs/                 # Ghost logs (auto-created)
```

## 🐛 Troubleshooting

### Common Issues

**Theme not appearing:**

- Check that your theme path is correct in `.env`
- Ensure `package.json` exists in your theme directory
- Restart Ghost: `./ghost-dev.sh restart`

**Permission issues:**

```bash
# Fix file permissions
sudo chown -R $USER:$USER /path/to/your/theme
```

**Port conflicts:**

```bash
# Change port in .env file
GHOST_PORT=3002
```

**Database issues:**

```bash
# Reset everything (WARNING: destroys all data)
./ghost-dev.sh reset
```

### Logs and Debugging

```bash
# View Ghost logs
./ghost-dev.sh logs

# Check container status
docker-compose ps

# Inspect container
docker-compose exec ghost sh
```

## 📚 Useful Links

- [Ghost Documentation](https://ghost.org/docs/)
- [Ghost Theme Development](https://ghost.org/docs/themes/)
- [Ghost Handlebars Helpers](https://ghost.org/docs/themes/helpers/)
- [Ghost Admin API](https://ghost.org/docs/admin-api/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)

## 🤝 Contributing

Contributions are welcome! Please feel free to submit issues and pull requests to improve this Docker Ghost development environment.

1. Fork or download the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ⭐ Acknowledgments

- Ghost team for the amazing blogging platform
- Docker community for containerization tools
- Contributors and theme developers

---

**Happy Ghost Theme Development!** 🎉

If you find this setup useful, please consider sharing it with others!
