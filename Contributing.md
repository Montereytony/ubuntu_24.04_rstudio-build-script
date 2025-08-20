# Contributing to RStudio Build Script

Thank you for your interest in contributing! This guide will help you get started.

## 🚀 Quick Start

1. Fork the repository
2. Clone your fork: `git clone https://github.com/yourusername/rstudio-build-script.git`
3. Create a branch: `git checkout -b feature/your-feature-name`
4. Make your changes
5. Test thoroughly
6. Submit a pull request

## 🐛 Reporting Issues

When reporting issues, please include:

- **Ubuntu version**: `lsb_release -a`
- **System specs**: CPU, RAM, disk space
- **Error logs**: Full error output from the script
- **Steps to reproduce**: What you were doing when the error occurred

### Issue Template

```markdown
**Environment:**
- Ubuntu Version: 
- Architecture: 
- RAM: 
- Free Disk Space: 

**Error Description:**
Brief description of the issue

**Steps to Reproduce:**
1. 
2. 
3. 

**Expected Behavior:**
What you expected to happen

**Actual Behavior:**
What actually happened

**Error Log:**
```
Paste error output here
```

**Additional Context:**
Any other relevant information
```

## 💡 Suggesting Enhancements

We welcome suggestions for improvements! Please:

1. Check if the enhancement has already been suggested
2. Create a detailed issue explaining:
   - What problem does it solve?
   - How would it work?
   - Any implementation ideas

## 🔧 Development Guidelines

### Code Style

- **Shell scripting**: Follow [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
- **Comments**: Explain complex logic and external dependencies
- **Functions**: Use descriptive function names with `print_status`, `print_error`, `print_success`
- **Variables**: Use UPPERCASE for constants, lowercase for local variables

### Script Structure

```bash
#!/bin/bash
set -e  # Exit on error

# Configuration section
VARIABLE_NAME="value"

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
# ...

# Helper functions
print_status() { ... }
print_error() { ... }

# Main logic sections
# 1. System updates
# 2. Dependency installation
# 3. Source download
# 4. Compilation
# 5. Installation
```

### Testing

Before submitting changes:

1. **Test on clean Ubuntu 24.04 system** (VM recommended)
2. **Test with existing Node.js installations**
3. **Test with existing R installations**
4. **Verify final RStudio installation works**
5. **Check desktop entry creation**

### Commit Guidelines

Use conventional commits:

- `feat: add support for ARM64 architecture`
- `fix: resolve Node.js dependency conflicts`
- `docs: update installation instructions`
- `refactor: improve error handling`
- `test: add validation for Boost installation`

## 📋 Pull Request Process

1. **Update documentation** if needed
2. **Add your changes to CHANGELOG.md**
3. **Test thoroughly** on clean system
4. **Create descriptive PR title and description**
5. **Link relevant issues**

### PR Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Tested on clean Ubuntu 24.04
- [ ] Tested with existing Node.js
- [ ] Verified RStudio launches correctly
- [ ] Updated documentation

## Related Issues
Fixes #(issue number)

## Additional Notes
Any additional information
```

## 🎯 Areas for Contribution

### High Priority
- **ARM64 support**: Adapt script for ARM-based systems
- **Error handling**: Improve recovery from build failures
- **Testing**: Automated testing framework
- **Documentation**: More detailed troubleshooting guides

### Medium Priority
- **Performance**: Optimize compilation times
- **Flexibility**: Support for different RStudio versions
- **Dependencies**: Reduce dependency requirements
- **Logging**: Better log file management

### Low Priority
- **UI improvements**: Better progress indicators
- **Configuration**: Config file support
- **Cleanup**: Better temporary file management

## 🔍 Code Review Process

All contributions go through code review:

1. **Automated checks**: Script syntax and basic validation
2. **Manual review**: Logic, style, and testing verification
3. **Testing**: Maintainers test on clean systems
4. **Feedback**: Constructive feedback for improvements
5. **Approval**: Merge after all requirements met

## 📚 Resources

### Useful Links
- [RStudio Build Instructions](https://github.com/rstudio/rstudio/blob/main/INSTALL)
- [Ubuntu Packaging Guide](https://packaging.ubuntu.com/)
- [Boost Building Guide](https://www.boost.org/doc/libs/1_85_0/more/getting_started/unix-variants.html)
- [CMake Documentation](https://cmake.org/documentation/)

### Development Setup

```bash
# Install development tools
sudo apt install shellcheck

# Lint the script
shellcheck compile_rstudio.sh

# Test in Docker (optional)
docker run -it ubuntu:24.04 bash
```

## 🤝 Community

- Be respectful and constructive
- Help others learn and improve
- Share knowledge and best practices
- Follow the [Code of Conduct](CODE_OF_CONDUCT.md)

## 📞 Getting Help

- Create an issue for bugs or questions
- Check existing issues first
- Provide detailed information
- Be patient and respectful

Thank you for contributing to make RStudio more accessible on Ubuntu! 🙏
