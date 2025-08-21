#!/bin/bash

# RStudio Compilation Script for Ubuntu 24.04
# This script downloads and compiles RStudio from source

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
RSTUDIO_VERSION="2024.04.2+764"  # Latest stable version as of early 2024
INSTALL_DIR="$HOME/rstudio-build"
BOOST_VERSION="1.85.0"
BOOST_VERSION_UNDERSCORE="1_85_0"
SOCI_VERSION="4.0.3"
CORES=$(nproc)

echo -e "${GREEN}Starting RStudio compilation for Ubuntu 24.04${NC}"
echo "Using $CORES CPU cores for compilation"

# Function to print status
print_status() {
    echo -e "${YELLOW}[INFO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# Update system
print_status "Updating system packages..."
sudo apt update

# Install build dependencies (excluding Node.js initially)
print_status "Installing build dependencies..."
sudo apt install -y \
    build-essential \
    cmake \
    git \
    libssl-dev \
    libclang-dev \
    libpq5 \
    libpq-dev \
    libxml2-dev \
    libxslt1-dev \
    libcurl4-openssl-dev \
    libcairo2-dev \
    libpango1.0-dev \
    libgtk-3-dev \
    libglib2.0-dev \
    libxtst6 \
    libnss3-dev \
    libxrandr2 \
    libasound2-dev \
    libxss1 \
    libdrm2 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libatk-bridge2.0-dev \
    libgtk-3-dev \
    libgdk-pixbuf2.0-dev \
    uuid-dev \
    ant \
    openjdk-17-jdk \
    r-base \
    r-base-dev \
    python3 \
    python3-pip \
    wget \
    unzip \
    libegl1-mesa-dev \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    libxcursor-dev \
    libxinerama-dev \
    libxi-dev \
    curl \
    ca-certificates \
    gnupg \
    libbz2-dev \
    libz-dev \
    libsqlite3-dev \
    postgresql-server-dev-all

# Check for existing Node.js installations and handle conflicts more carefully
print_status "Checking for existing Node.js installations..."
if dpkg -l | grep -q nodejs; then
    print_status "Found existing nodejs installation. Checking for conflicts..."
    # Only remove if there are no critical dependencies
    CRITICAL_DEPS=$(apt-cache rdepends nodejs | grep -v "Reverse Depends" | grep -E "(fastx|bioinformatics|analysis)" || true)
    if [ -n "$CRITICAL_DEPS" ]; then
        print_status "Found critical dependencies. Skipping nodejs removal."
        print_status "Will try to work with existing nodejs installation."
        SKIP_NODE_INSTALL=true
    else
        print_status "No critical dependencies found. Safe to remove."
        sudo apt remove -y nodejs npm || true
        sudo apt autoremove -y
        SKIP_NODE_INSTALL=false
    fi
else
    SKIP_NODE_INSTALL=false
fi

# Install Node.js only if we don't have a working version
if [ "$SKIP_NODE_INSTALL" = false ]; then
    # Install Node.js via snap (more reliable on Ubuntu 24.04)
    print_status "Installing Node.js via snap..."
    sudo snap install node --classic
else
    print_status "Using existing Node.js installation..."
fi

# Verify Node.js installation
if command -v node &> /dev/null || command -v nodejs &> /dev/null; then
    if command -v node &> /dev/null; then
        NODE_VERSION=$(node --version)
        NODE_CMD="node"
    else
        NODE_VERSION=$(nodejs --version)
        NODE_CMD="nodejs"
    fi
    print_success "Node.js available: $NODE_VERSION (command: $NODE_CMD)"
else
    print_error "Node.js installation failed"
    exit 1
fi

# Install Yarn via npm (use appropriate npm command)
print_status "Installing Yarn..."
if command -v npm &> /dev/null; then
    sudo npm install -g yarn
elif [ "$SKIP_NODE_INSTALL" = false ] && command -v snap &> /dev/null; then
    # For snap-installed node
    sudo snap run node.npm install -g yarn
else
    print_error "Cannot find npm to install Yarn"
    exit 1
fi

# Verify Yarn installation
if command -v yarn &> /dev/null; then
    YARN_VERSION=$(yarn --version)
    print_success "Yarn installed: $YARN_VERSION"
else
    print_error "Yarn installation failed"
    exit 1
fi

# Install Pandoc (required for RStudio)
print_status "Installing Pandoc..."
PANDOC_VERSION="3.1.11"
wget https://github.com/jgm/pandoc/releases/download/${PANDOC_VERSION}/pandoc-${PANDOC_VERSION}-1-amd64.deb
sudo dpkg -i pandoc-${PANDOC_VERSION}-1-amd64.deb
rm pandoc-${PANDOC_VERSION}-1-amd64.deb

# Build Boost from source (Ubuntu 24.04's Boost is too old)
print_status "Building Boost ${BOOST_VERSION} from source..."
cd "$INSTALL_DIR"
if [ ! -d "boost_${BOOST_VERSION_UNDERSCORE}" ]; then
    # Try multiple download sources for Boost
    BOOST_DOWNLOADED=false
    
    # Source 1: SourceForge (most reliable)
    print_status "Downloading Boost from SourceForge..."
    if wget -q --spider "https://sourceforge.net/projects/boost/files/boost/${BOOST_VERSION}/boost_${BOOST_VERSION_UNDERSCORE}.tar.bz2"; then
        wget "https://sourceforge.net/projects/boost/files/boost/${BOOST_VERSION}/boost_${BOOST_VERSION_UNDERSCORE}.tar.bz2/download" -O boost_${BOOST_VERSION_UNDERSCORE}.tar.bz2
        if file boost_${BOOST_VERSION_UNDERSCORE}.tar.bz2 | grep -q "bzip2"; then
            BOOST_DOWNLOADED=true
            print_success "Downloaded Boost from SourceForge"
        else
            rm -f boost_${BOOST_VERSION_UNDERSCORE}.tar.bz2
        fi
    fi
    
    # Source 2: GitHub mirror as backup
    if [ "$BOOST_DOWNLOADED" = false ]; then
        print_status "Trying GitHub mirror..."
        if wget -q --spider "https://archives.boost.io/release/${BOOST_VERSION}/source/boost_${BOOST_VERSION_UNDERSCORE}.tar.bz2"; then
            wget "https://archives.boost.io/release/${BOOST_VERSION}/source/boost_${BOOST_VERSION_UNDERSCORE}.tar.bz2"
            if file boost_${BOOST_VERSION_UNDERSCORE}.tar.bz2 | grep -q "bzip2"; then
                BOOST_DOWNLOADED=true
                print_success "Downloaded Boost from archives.boost.io"
            else
                rm -f boost_${BOOST_VERSION_UNDERSCORE}.tar.bz2
            fi
        fi
    fi
    
    # Source 3: Use system package temporarily if download fails
    if [ "$BOOST_DOWNLOADED" = false ]; then
        print_status "Download failed, checking if system Boost might work..."
        SYSTEM_BOOST_VERSION=$(dpkg -l | grep libboost-dev | awk '{print $3}' | head -1 | cut -d. -f1-2 || echo "0.0")
        if [ -n "$SYSTEM_BOOST_VERSION" ] && [ "$SYSTEM_BOOST_VERSION" != "0.0" ]; then
            print_status "Found system Boost $SYSTEM_BOOST_VERSION, will try with additional CMake flags"
            USE_SYSTEM_BOOST=true
        else
            print_error "Could not download Boost and no system Boost found. Installing system Boost as fallback..."
            sudo apt install -y libboost-all-dev
            USE_SYSTEM_BOOST=true
        fi
    else
        # Extract the downloaded archive
        print_status "Extracting Boost archive..."
        tar -xjf boost_${BOOST_VERSION_UNDERSCORE}.tar.bz2
        if [ $? -eq 0 ]; then
            rm boost_${BOOST_VERSION_UNDERSCORE}.tar.bz2
            USE_SYSTEM_BOOST=false
        else
            print_error "Failed to extract Boost. Falling back to system Boost..."
            sudo apt install -y libboost-all-dev
            USE_SYSTEM_BOOST=true
        fi
    fi
fi

if [ "$USE_SYSTEM_BOOST" != true ] && [ -d "boost_${BOOST_VERSION_UNDERSCORE}" ]; then
    cd boost_${BOOST_VERSION_UNDERSCORE}
    if [ ! -f "b2" ]; then
        print_status "Bootstrapping Boost..."
        ./bootstrap.sh --prefix=/usr/local
    fi

    print_status "Building Boost libraries (this may take 15-30 minutes)..."
    sudo ./b2 -j${CORES} --with-system --with-filesystem --with-date_time --with-regex --with-thread --with-chrono --with-atomic install

    print_success "Boost ${BOOST_VERSION} installed successfully!"
    cd "$INSTALL_DIR"
    BOOST_CMAKE_FLAGS="-DBoost_ROOT=/usr/local -DBoost_INCLUDE_DIR=/usr/local/include -DBoost_LIBRARY_DIR=/usr/local/lib"
else
    print_status "Using system Boost installation"
    BOOST_CMAKE_FLAGS="-DBoost_NO_BOOST_CMAKE=ON"
fi

# Build SOCI from source (required for RStudio)
print_status "Building SOCI ${SOCI_VERSION} from source..."
cd "$INSTALL_DIR"
if [ ! -d "soci-${SOCI_VERSION}" ]; then
    print_status "Downloading SOCI..."
    wget "https://github.com/SOCI/soci/archive/refs/tags/v${SOCI_VERSION}.tar.gz" -O soci-${SOCI_VERSION}.tar.gz
    tar -xzf soci-${SOCI_VERSION}.tar.gz
    rm soci-${SOCI_VERSION}.tar.gz
fi

cd soci-${SOCI_VERSION}
mkdir -p build
cd build

print_status "Configuring SOCI build..."
cmake .. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr/local \
    -DSOCI_CXX11=ON \
    -DSOCI_TESTS=OFF \
    -DWITH_BOOST=ON \
    -DWITH_POSTGRESQL=ON \
    -DWITH_SQLITE3=ON \
    $BOOST_CMAKE_FLAGS

print_status "Building SOCI..."
make -j${CORES}

print_status "Installing SOCI..."
sudo make install

print_success "SOCI ${SOCI_VERSION} installed successfully!"
cd "$INSTALL_DIR"

# Create build directory
print_status "Creating build directory..."
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"

# Download RStudio source
print_status "Downloading RStudio source code..."
if [ ! -d "rstudio" ]; then
    git clone https://github.com/rstudio/rstudio.git
fi

cd rstudio
git checkout "v${RSTUDIO_VERSION}"

# Initialize submodules
print_status "Initializing git submodules..."
git submodule update --init --recursive

# Create build directory
mkdir -p build
cd build

# Configure build with CMake
print_status "Configuring build with CMake..."
cmake .. \
    -DRSTUDIO_TARGET=Desktop \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr/local \
    -DRSTUDIO_BOOST_SIGNALS_VERSION=2 \
    $BOOST_CMAKE_FLAGS

# Build RStudio
print_status "Building RStudio (this will take a while)..."
make -j${CORES}

# Check if build was successful
if [ $? -eq 0 ]; then
    print_success "RStudio built successfully!"
    
    # Install RStudio
    print_status "Installing RStudio..."
    sudo make install
    
    # Create desktop entry
    print_status "Creating desktop entry..."
    sudo tee /usr/share/applications/rstudio.desktop > /dev/null << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=RStudio
Comment=IDE for R
Exec=/usr/local/bin/rstudio %F
Icon=rstudio
StartupNotify=true
MimeType=text/x-r-source;text/x-r;text/x-R;text/x-r-doc;text/x-r-sweave;text/x-r-markdown;text/x-r-html;text/x-r-presentation;application/x-r-data;application/x-r-project;text/x-r-history;text/x-r-profile;text/x-dcf;
Categories=Development;IDE;
Keywords=R;Statistics;
EOF

    # Copy icon if it exists
    if [ -f "../src/cpp/desktop/resources/icons/RStudio.png" ]; then
        sudo cp ../src/cpp/desktop/resources/icons/RStudio.png /usr/share/pixmaps/rstudio.png
    fi
    
    print_success "RStudio installation completed!"
    print_status "You can now run RStudio by typing 'rstudio' in terminal or finding it in your applications menu."
    
else
    print_error "Build failed! Please check the error messages above."
    exit 1
fi

# Clean up build files (optional)
read -p "Do you want to remove build files to save space? (y/N): " -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_status "Cleaning up build files..."
    cd "$INSTALL_DIR"
    rm -rf rstudio
    print_success "Build files cleaned up."
fi

print_success "Script completed successfully!"
echo ""
echo "RStudio has been compiled and installed from source."
echo "Build directory: $INSTALL_DIR"
echo ""
echo "To run RStudio:"
echo "  - Type 'rstudio' in terminal"
echo "  - Or find it in your applications menu"
