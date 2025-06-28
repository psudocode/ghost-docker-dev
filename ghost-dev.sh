#!/bin/bash

# Ghost Theme Development Helper Script
# This script provides shortcuts for common development tasks

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
# Load environment variables from .env file
if [ -f .env ]; then
    source .env
fi

GHOST_URL="${GHOST_URL:-http://localhost:3001}"
ADMIN_URL="$GHOST_URL/ghost"
THEME_NAME="${THEME_NAME:-boojoog-ghost-theme}"

# Functions
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
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

# Check environment variables
check_env() {
    print_status "Checking environment configuration..."
    
    if [ ! -f .env ]; then
        print_warning ".env file not found. Using default values."
        print_status "You can copy .env.example to .env and customize it."
    else
        print_success ".env file found"
    fi
    
    print_status "Current configuration:"
    echo "  Ghost URL: $GHOST_URL"
    echo "  Ghost Port: ${GHOST_PORT:-3001}"
    echo "  Theme Name: $THEME_NAME"
    echo "  Node Environment: ${NODE_ENV:-development}"
    
    if [ ! -z "$THEME_PATH" ] && [ ! -d "$THEME_PATH" ]; then
        print_warning "Theme path does not exist: $THEME_PATH"
        print_status "Please check your THEME_PATH in .env file"
    elif [ ! -z "$THEME_PATH" ]; then
        print_success "Theme path exists: $THEME_PATH"
    fi
}
# Check if Docker and Docker Compose are available
check_docker() {
    if ! command -v docker &> /dev/null; then
        print_error "Docker is not installed or not in PATH"
        exit 1
    fi
    
    if ! command -v docker-compose &> /dev/null; then
        print_error "Docker Compose is not installed or not in PATH"
        exit 1
    fi
}

# Start Ghost
start_ghost() {
    print_status "Starting Ghost development environment..."
    docker-compose up -d
    
    print_status "Waiting for Ghost to be ready..."
    sleep 10
    
    # Check if Ghost is responding
    for i in {1..30}; do
        if curl -s "$GHOST_URL" > /dev/null; then
            print_success "Ghost is running at $GHOST_URL"
            print_status "Admin panel: $ADMIN_URL"
            return 0
        fi
        print_status "Waiting for Ghost... ($i/30)"
        sleep 2
    done
    
    print_warning "Ghost may still be starting up. Check logs with: $0 logs"
}

# Stop Ghost
stop_ghost() {
    print_status "Stopping Ghost..."
    docker-compose down
    print_success "Ghost stopped"
}

# Restart Ghost (useful after theme changes)
restart_ghost() {
    print_status "Restarting Ghost..."
    docker-compose restart ghost
    sleep 5
    print_success "Ghost restarted"
}

# Show logs
show_logs() {
    print_status "Showing Ghost logs (Ctrl+C to exit)..."
    docker-compose logs -f ghost
}

# Check Ghost status
status() {
    print_status "Checking Ghost status..."
    
    if docker-compose ps ghost | grep -q "Up"; then
        print_success "Ghost container is running"
        
        if curl -s "$GHOST_URL" > /dev/null; then
            print_success "Ghost is responding at $GHOST_URL"
        else
            print_warning "Ghost container is up but not responding"
        fi
    else
        print_error "Ghost container is not running"
    fi
}

# Open Ghost in browser
open_ghost() {
    if command -v open &> /dev/null; then
        open "$GHOST_URL"
    elif command -v xdg-open &> /dev/null; then
        xdg-open "$GHOST_URL"
    else
        print_status "Open $GHOST_URL in your browser"
    fi
}

# Open Ghost admin in browser
open_admin() {
    if command -v open &> /dev/null; then
        open "$ADMIN_URL"
    elif command -v xdg-open &> /dev/null; then
        xdg-open "$ADMIN_URL"
    else
        print_status "Open $ADMIN_URL in your browser"
    fi
}

# Clean restart (removes containers but keeps data)
clean_restart() {
    print_status "Performing clean restart..."
    docker-compose down
    docker-compose up -d
    print_success "Clean restart completed"
}

# Reset everything (WARNING: destroys all data)
reset() {
    print_warning "This will destroy ALL Ghost data including posts, settings, and users!"
    read -p "Are you sure? Type 'yes' to continue: " -r
    if [[ $REPLY == "yes" ]]; then
        print_status "Resetting Ghost environment..."
        docker-compose down -v
        docker-compose up -d
        print_success "Ghost environment reset"
    else
        print_status "Reset cancelled"
    fi
}

# Show help
show_help() {
    echo "Ghost Theme Development Helper"
    echo ""
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  start       Start Ghost development environment"
    echo "  stop        Stop Ghost"
    echo "  restart     Restart Ghost (useful after theme changes)"
    echo "  logs        Show Ghost logs"
    echo "  status      Check Ghost status"
    echo "  env         Check environment configuration"
    echo "  open        Open Ghost frontend in browser"
    echo "  admin       Open Ghost admin panel in browser"
    echo "  clean       Clean restart (removes containers, keeps data)"
    echo "  reset       Reset everything (WARNING: destroys all data)"
    echo "  help        Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 start    # Start Ghost"
    echo "  $0 restart  # Restart after making theme changes"
    echo "  $0 logs     # Watch logs for debugging"
}

# Main script logic
main() {
    check_docker
    
    case "${1:-help}" in
        start)
            start_ghost
            ;;
        stop)
            stop_ghost
            ;;
        restart)
            restart_ghost
            ;;
        logs)
            show_logs
            ;;
        status)
            status
            ;;
        env)
            check_env
            ;;
        open)
            open_ghost
            ;;
        admin)
            open_admin
            ;;
        clean)
            clean_restart
            ;;
        reset)
            reset
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            print_error "Unknown command: $1"
            show_help
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"
