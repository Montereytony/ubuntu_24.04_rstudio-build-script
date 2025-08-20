# RStudio Compilation Script for Ubuntu 24.04

This script automates the process of downloading and compiling RStudio from source on Ubuntu 24.04 LTS.

## 🚀 Features

- **Automated dependency installation** - Installs all required build tools and libraries
- **Safe Node.js handling** - Preserves critical dependencies like bioinformatics tools
- **Boost compatibility** - Builds Boost 1.85.0 from source to meet RStudio requirements
- **System integration** - Creates desktop entry and system-wide installation
- **Multi-core compilation** - Uses all available CPU cores for faster builds
- **Error handling** - Comprehensive error checking and recovery options
- **Graceful fallbacks** - Multiple download sources and fallback strategies

## 📋 Requirements

- Ubuntu 24.04 LTS
- At least 8GB free disk space
- 4GB+ RAM recommended
- Sudo privileges
- Stable internet connection
- 30-60 minutes compilation time

## 🛠 Usage

### Quick Start

```bash
# Download the script
wget https://raw.githubusercontent.com/Montereytony/ubuntu_24.04_rstudio-build-script/main/compile_rstudio.sh

# Make it executable
chmod +x compile_rstudio.sh

# Run the script
./compile_rstudio.sh
```

### Manual Installation

1. Clone this repository:
```bash
git clone https://github.com/yourusername/rstudio-build-script.git
cd rstudio-build-script
```

2. Run the compilation script:
```bash
chmod +x compile_rstudio.sh
./compile_rstudio.sh
```

3. Wait for compilation to complete (30-60 minutes)

4. Launch RStudio:
```bash
rstudio
```

## 🔧 What the Script Does

1. **Updates system packages** and installs build dependencies
2. **Safely handles Node.js** - checks for critical dependencies before removal
3. **Downloads and compiles Boost 1.85.0** from source (Ubuntu's version is too old)
4. **Downloads RStudio source code** from the official repository
5. **Configures and builds** RStudio using CMake and make
6. **Installs system-wide** with proper desktop integration
7. **Creates desktop entry** for easy access from applications menu

## ⚠️ Important Notes

- **Preserves existing software**: The script checks for critical dependencies (like `fastx4-server`) before removing packages
- **Boost compilation**: Takes 15-30 minutes to build Boost from source
- **Multiple fallbacks**: If downloads fail, the script tries alternative sources
- **Clean installation**: Option to remove build files after successful compilation

## 🐛 Troubleshooting

### Common Issues

**Node.js conflicts:**
```bash
# If you get Node.js dependency errors, install nodejs first:
sudo apt install nodejs npm
```

**Boost download failures:**
The script automatically tries multiple sources. If all fail, it falls back to system Boost with compatibility flags.

**Missing dependencies:**
```bash
# Update package lists and try again:
sudo apt update
sudo apt upgrade
./compile_rstudio.sh
```

**Compilation errors:**
Check the build log for specific errors. Most issues are dependency-related and can be resolved by installing missing packages.

### Getting Help

1. Check the [Issues](https://github.com/yourusername/rstudio-build-script/issues) page
2. Review the troubleshooting section above
3. Create a new issue with your error log

## 📝 Configuration

The script uses these default settings (editable at the top of the script):

- **RStudio Version**: 2024.04.2+764 (stable release)
- **Boost Version**: 1.85.0
- **Install Directory**: `$HOME/rstudio-build`
- **CPU Cores**: All available cores (`nproc`)

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit your changes: `git commit -m 'Add amazing feature'`
4. Push to the branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- RStudio team for the excellent IDE
- Ubuntu community for packaging support
- Boost developers for the essential libraries

## 📈 Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history and changes.

---

**Note**: This script is tested on Ubuntu 24.04 LTS. While it may work on other Ubuntu versions or Debian-based distributions, your mileage may vary.
