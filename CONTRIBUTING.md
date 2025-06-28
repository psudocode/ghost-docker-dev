# Contributing to Ghost Docker Development Environment

First off, thank you for considering contributing to this project! 🎉

## How to Contribute

### Reporting Bugs

If you find a bug, please create an issue with:

- A clear and descriptive title
- Steps to reproduce the issue
- Expected behavior vs actual behavior
- Your environment details (OS, Docker version, etc.)
- Any relevant logs or screenshots

### Suggesting Enhancements

Enhancement suggestions are welcome! Please create an issue with:

- A clear and descriptive title
- Detailed explanation of the suggested enhancement
- Why this enhancement would be useful
- Any potential implementation details

### Code Contributions

1. **Fork the Repository**

   ```bash
   git clone https://github.com/your-username/ghost-docker-dev.git
   cd ghost-docker-dev
   ```

2. **Create a Feature Branch**

   ```bash
   git checkout -b feature/amazing-feature
   ```

3. **Make Your Changes**

   - Follow existing code style and conventions
   - Test your changes thoroughly
   - Update documentation if needed

4. **Test Your Changes**

   ```bash
   # Test the basic functionality
   ./ghost-dev.sh start
   ./ghost-dev.sh status
   ./ghost-dev.sh stop

   # Validate Docker Compose
   docker-compose config
   ```

5. **Commit Your Changes**

   ```bash
   git add .
   git commit -m "Add some amazing feature"
   ```

   Please use clear, descriptive commit messages.

6. **Push to Your Fork**

   ```bash
   git push origin feature/amazing-feature
   ```

7. **Create a Pull Request**
   - Provide a clear description of what your PR does
   - Reference any related issues
   - Include screenshots if relevant

## Development Guidelines

### Code Style

- Use 2 spaces for indentation in YAML files
- Use 4 spaces for indentation in shell scripts
- Keep lines under 80 characters when possible
- Use descriptive variable names
- Add comments for complex logic

### Docker Compose Guidelines

- Use environment variables for configurable values
- Provide sensible defaults
- Document all services and volumes
- Use health checks where appropriate

### Shell Script Guidelines

- Use `set -e` for error handling
- Provide helpful error messages
- Use colors for different message types
- Test scripts on multiple platforms when possible

### Documentation

- Update README.md for any user-facing changes
- Add inline comments for complex configurations
- Keep examples up to date
- Use clear, concise language

## Testing

Before submitting a PR, please test:

1. **Basic functionality**:

   ```bash
   ./ghost-dev.sh start
   ./ghost-dev.sh restart
   ./ghost-dev.sh logs
   ./ghost-dev.sh stop
   ```

2. **Environment variable handling**:

   ```bash
   ./ghost-dev.sh env
   ```

3. **Docker Compose validation**:

   ```bash
   docker-compose config
   ```

4. **Different configurations** (different ports, theme paths, etc.)

## Questions?

If you have questions about contributing, feel free to:

- Create an issue with the "question" label
- Start a discussion in the repository
- Reach out to the maintainers

## Code of Conduct

This project follows a simple code of conduct:

- Be respectful and inclusive
- Focus on constructive feedback
- Help others learn and grow
- Keep discussions on-topic

Thank you for contributing! 🚀
