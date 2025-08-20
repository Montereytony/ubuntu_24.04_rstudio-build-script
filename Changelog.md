# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-08-20

### Added
- Initial release of RStudio compilation script for Ubuntu 24.04
- Automated dependency installation for build tools and libraries
- Safe Node.js handling that preserves critical dependencies (fastx4-server, etc.)
- Boost 1.85.0 compilation from source to meet RStudio requirements
- Multiple download sources with automatic fallback mechanisms
- Multi-core compilation support using all available CPU cores
- System-wide installation with desktop entry creation
- Comprehensive error handling and status reporting
- Option to clean up build files after successful compilation
- Support for RStudio 2024.04.2+764 stable release

### Features
- Detects and preserves bioinformatics tools before Node.js removal
- Downloads from SourceForge, archives.boost.io, and system packages as fallbacks
- Creates `/usr/local/bin/rstudio` executable
- Installs desktop entry in `/usr/share/applications/`
- Colored output for better user experience
- Automatic verification of downloaded files
- CMake configuration optimized for Ubuntu 24.04

### Technical Details
- Targets: Ubuntu 24.04 LTS (may work on other Debian-based systems)
- Dependencies: 40+ packages including build tools, libraries, and runtime requirements
- Build time: 30-60 minutes depending on system specifications
- Disk space: ~8GB required during build process
- Memory: 4GB+ RAM recommended for compilation

### Known Issues
- Requires manual intervention if fastx4-server dependencies conflict
- Boost compilation is time-intensive (15-30 minutes)
- Some dependency packages may need manual installation on non-standard systems

## [Unreleased]

### Planned
- Support for different RStudio versions via command-line arguments
- Docker container option for isolated builds
- ARM64 architecture support
- Automated testing framework
- Integration with GitHub Actions for CI/CD
