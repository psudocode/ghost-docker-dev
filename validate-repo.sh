#!/bin/bash

# Docker Setup Validation Script
# Checks if the Ghost Docker development environment is properly configured

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_check() {
    echo -e "${BLUE}[CHECK]${NC} $1"
}

print_pass() {
    echo -e "${GREEN}[PASS]${NC} $1"
}

print_fail() {
    echo -e "${RED}[FAIL]${NC} $1"
}

print_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

echo "🔍 Validating Ghost Docker development environment..."
echo ""

# Check required files
print_check "Checking required files..."
required_files=(
    "docker-compose.yml"
    ".env.example"
    "ghost-dev.sh"
    "setup.sh"
)

for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        print_pass "$file exists"
    else
        print_fail "$file is missing"
        exit 1
    fi
done

# Check executable permissions
print_check "Checking executable permissions..."
if [ -x "ghost-dev.sh" ]; then
    print_pass "ghost-dev.sh is executable"
else
    print_fail "ghost-dev.sh is not executable"
    chmod +x ghost-dev.sh
    print_pass "Fixed ghost-dev.sh permissions"
fi

if [ -x "setup.sh" ]; then
    print_pass "setup.sh is executable"
else
    print_fail "setup.sh is not executable"
    chmod +x setup.sh
    print_pass "Fixed setup.sh permissions"
fi

# Check Docker prerequisites
print_check "Checking Docker prerequisites..."
if command -v docker >/dev/null 2>&1; then
    print_pass "Docker is installed"
else
    print_fail "Docker is not installed"
    echo "Please install Docker: https://docs.docker.com/get-docker/"
    exit 1
fi

if command -v docker-compose >/dev/null 2>&1; then
    print_pass "Docker Compose is installed"
else
    print_fail "Docker Compose is not installed"
    echo "Please install Docker Compose: https://docs.docker.com/compose/install/"
    exit 1
fi

# Test Docker daemon
if docker info >/dev/null 2>&1; then
    print_pass "Docker daemon is running"
else
    print_warn "Docker daemon is not running"
    echo "Please start Docker to test the full setup"
fi

# Validate Docker Compose configuration
print_check "Validating Docker Compose configuration..."
if docker-compose config >/dev/null 2>&1; then
    print_pass "Docker Compose configuration is valid"
else
    print_fail "Docker Compose configuration is invalid"
    echo "Run 'docker-compose config' to see the errors"
    exit 1
fi

# Check environment file setup
print_check "Checking environment configuration..."
if [ -f ".env" ]; then
    print_pass ".env file exists"
    
    # Check if key variables are set
    if grep -q "GHOST_PORT=" .env && grep -q "GHOST_URL=" .env; then
        print_pass "Basic environment variables are configured"
    else
        print_warn "Environment variables may not be properly configured"
    fi
else
    print_warn ".env file not found"
    echo "Run './setup.sh' or copy '.env.example' to '.env' to configure"
fi

# Summary
echo ""
echo "✅ Docker environment validation completed!"
echo ""

if docker info >/dev/null 2>&1; then
    echo "Your Ghost Docker development environment is ready to use:"
    echo ""
    echo "🚀 Quick start commands:"
    echo "  ./ghost-dev.sh start    # Start Ghost"
    echo "  ./ghost-dev.sh status   # Check status"
    echo "  ./ghost-dev.sh logs     # View logs"
    echo "  ./ghost-dev.sh stop     # Stop Ghost"
else
    echo "Start Docker and run this validation again to test the full setup."
fi

echo ""
echo "Happy Ghost development! �"
