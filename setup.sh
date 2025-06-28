#!/bin/bash

# Ghost Docker Development Environment Setup Script
# This script helps new users get started quickly

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# ASCII Art Banner
print_banner() {
    echo -e "${PURPLE}"
    echo "  ╔═══════════════════════════════════════════════════════════╗"
    echo "  ║                                                           ║"
    echo "  ║    👻 Ghost Docker Development Environment Setup          ║"
    echo "  ║                                                           ║"
    echo "  ╚═══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check prerequisites
check_prerequisites() {
    print_step "Checking prerequisites..."
    
    local missing_deps=()
    
    if ! command_exists docker; then
        missing_deps+=("docker")
    fi
    
    if ! command_exists docker-compose; then
        missing_deps+=("docker-compose")
    fi
    
    if [ ${#missing_deps[@]} -gt 0 ]; then
        print_error "Missing required dependencies: ${missing_deps[*]}"
        echo ""
        echo "Please install the missing dependencies:"
        echo "  Docker: https://docs.docker.com/get-docker/"
        echo "  Docker Compose: https://docs.docker.com/compose/install/"
        exit 1
    fi
    
    print_success "All prerequisites are installed"
}

# Setup environment file
setup_environment() {
    print_step "Setting up environment configuration..."
    
    if [ -f .env ]; then
        print_warning ".env file already exists"
        read -p "Do you want to overwrite it? (y/N): " -r
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_info "Keeping existing .env file"
            return
        fi
    fi
    
    cp .env.example .env
    print_success "Created .env file from template"
    
    # Interactive configuration
    echo ""
    print_info "Let's configure your environment:"
    
    read -p "Ghost port (default: 3001): " ghost_port
    ghost_port=${ghost_port:-3001}
    
    read -p "Theme name (default: my-ghost-theme): " theme_name
    theme_name=${theme_name:-my-ghost-theme}
    
    read -p "Theme path (optional, leave empty if no theme): " theme_path
    
    # Update .env file
    sed -i.bak "s/GHOST_PORT=3001/GHOST_PORT=$ghost_port/" .env
    sed -i.bak "s|GHOST_URL=http://localhost:3001|GHOST_URL=http://localhost:$ghost_port|" .env
    sed -i.bak "s/THEME_NAME=your-theme-name/THEME_NAME=$theme_name/" .env
    
    if [ -n "$theme_path" ]; then
        sed -i.bak "s|THEME_PATH=/path/to/your/theme/directory|THEME_PATH=$theme_path|" .env
        print_info "Theme path configured: $theme_path"
        print_warning "Don't forget to uncomment the theme volume mount in docker-compose.yml"
    fi
    
    rm .env.bak 2>/dev/null || true
    
    print_success "Environment configured successfully"
}

# Setup theme mounting
setup_theme_mounting() {
    if [ -z "$theme_path" ]; then
        return
    fi
    
    print_step "Setting up theme mounting..."
    
    # Check if theme path exists
    if [ ! -d "$theme_path" ]; then
        print_warning "Theme path does not exist: $theme_path"
        read -p "Do you want to create it? (y/N): " -r
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            mkdir -p "$theme_path"
            print_success "Created theme directory: $theme_path"
        else
            print_info "Skipping theme mounting"
            return
        fi
    fi
    
    # Uncomment theme volume mount in docker-compose.yml
    if grep -q "# - \${THEME_PATH}" docker-compose.yml; then
        sed -i.bak 's/# - ${THEME_PATH}/- ${THEME_PATH}/' docker-compose.yml
        rm docker-compose.yml.bak 2>/dev/null || true
        print_success "Theme mounting enabled in docker-compose.yml"
    fi
}

# Make helper script executable
setup_helper_script() {
    print_step "Setting up helper script..."
    
    if [ -f ghost-dev.sh ]; then
        chmod +x ghost-dev.sh
        print_success "Made ghost-dev.sh executable"
    else
        print_warning "ghost-dev.sh not found"
    fi
}

# Test Docker setup
test_docker_setup() {
    print_step "Testing Docker setup..."
    
    # Test Docker Compose configuration
    if docker-compose config >/dev/null 2>&1; then
        print_success "Docker Compose configuration is valid"
    else
        print_error "Docker Compose configuration is invalid"
        exit 1
    fi
    
    # Test Docker daemon
    if docker info >/dev/null 2>&1; then
        print_success "Docker daemon is running"
    else
        print_error "Docker daemon is not running"
        print_info "Please start Docker and try again"
        exit 1
    fi
}

# Start Ghost
start_ghost() {
    print_step "Starting Ghost..."
    
    if [ -f ghost-dev.sh ]; then
        ./ghost-dev.sh start
    else
        docker-compose up -d
        sleep 10
        
        if docker-compose ps | grep -q "Up"; then
            print_success "Ghost is running!"
        else
            print_error "Failed to start Ghost"
            exit 1
        fi
    fi
}

# Print final instructions
print_final_instructions() {
    echo ""
    echo -e "${GREEN}🎉 Setup completed successfully!${NC}"
    echo ""
    echo "Your Ghost development environment is ready:"
    echo ""
    echo -e "  🌐 Frontend: ${BLUE}http://localhost:${ghost_port}${NC}"
    echo -e "  ⚙️  Admin:    ${BLUE}http://localhost:${ghost_port}/ghost${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. Go to the admin panel to complete Ghost setup"
    echo "  2. Create your admin account"
    echo "  3. Start developing your theme!"
    echo ""
    echo "Useful commands:"
    echo "  ./ghost-dev.sh help     # Show all available commands"
    echo "  ./ghost-dev.sh logs     # View Ghost logs"
    echo "  ./ghost-dev.sh restart  # Restart Ghost"
    echo "  ./ghost-dev.sh stop     # Stop Ghost"
    echo ""
    echo -e "${YELLOW}Happy Ghost development! 👻${NC}"
}

# Main setup flow
main() {
    print_banner
    
    check_prerequisites
    setup_environment
    setup_theme_mounting
    setup_helper_script
    test_docker_setup
    start_ghost
    print_final_instructions
}

# Run setup if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
