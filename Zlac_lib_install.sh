#!/usr/bin/env bash

set -e  # Exit on any command failing

# ------------------------------------------------------------------------------
# 0) Create a new directory for all clones and builds
# ------------------------------------------------------------------------------

WORK_DIR="$HOME/zlac_libraries"  # Change this to any directory you prefer
echo "Creating and using directory: $WORK_DIR"
mkdir -p "$WORK_DIR"
cd "$WORK_DIR"

# ------------------------------------------------------------------------------
# 1) ZLAC8015D_python
# ------------------------------------------------------------------------------
LIB1_REPO="https://github.com/asman100/ZLAC8015D_python.git"
LIB1_DIR="ZLAC8015D_python"

echo "----------------------------------------------------------"
echo "Cloning and installing ZLAC8015D_python..."
echo "Repository: $LIB1_REPO"
echo "----------------------------------------------------------"

# Clone if not already present
if [ -d "$LIB1_DIR" ]; then
  echo "Directory '$LIB1_DIR' already exists, skipping clone..."
else
  git clone "$LIB1_REPO" "$LIB1_DIR"
fi

pushd "$LIB1_DIR" >/dev/null

# 1. Install Python dependencies
echo "Installing Python 3 dependencies for ZLAC8015D_python..."
sudo pip3 install pymodbus==2.5.3

# 2. Install the package
echo "Running setup.py install for ZLAC8015D_python..."
sudo python3 setup.py install

popd >/dev/null

# 3. Add user to dialout group
echo "Adding current user to dialout group..."
sudo usermod -a -G dialout "$USER"
echo "----------------------------------------------------------"
echo "ZLAC8015D_python installation complete."
echo "----------------------------------------------------------"

# ------------------------------------------------------------------------------
# 2) serial (branch: foxy)
# ------------------------------------------------------------------------------
LIB2_REPO="https://github.com/ZhaoXiangBox/serial.git"
LIB2_BRANCH="foxy"
LIB2_DIR="serial"

echo "----------------------------------------------------------"
echo "Cloning and installing serial (branch: $LIB2_BRANCH)..."
echo "Repository: $LIB2_REPO"
echo "----------------------------------------------------------"

# Clone if not already present
if [ -d "$LIB2_DIR" ]; then
  echo "Directory '$LIB2_DIR' already exists, skipping clone..."
else
  git clone -b "$LIB2_BRANCH" "$LIB2_REPO" "$LIB2_DIR"
fi

pushd "$LIB2_DIR" >/dev/null

mkdir -p build
cd build
cmake ..
make
sudo make install

popd >/dev/null

echo "----------------------------------------------------------"
echo "serial (branch: $LIB2_BRANCH) installation complete."
echo "----------------------------------------------------------"

echo "All installations are done!"
