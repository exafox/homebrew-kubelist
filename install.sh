#!/bin/bash

# kubelist installation script
# This script installs kubelist to /usr/local/bin and optionally installs the man page

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script configuration
SCRIPT_NAME="kubelist"
VERSION="1.0.0"
INSTALL_DIR="/usr/local/bin"
MAN_DIR="/usr/local/share/man/man1"

# GitHub repository information
GITHUB_USER="your-username"
GITHUB_REPO="kubelist"
GITHUB_URL="https://github.com/${GITHUB_USER}/${GITHUB_REPO}"

# Function to print colored output
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

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check if running as root
is_root() {
    [ "${EUID:-$(id -u)}" -eq 0 ]
}

# Function to download file
download_file() {
    local url="$1"
    local output="$2"
    
    if command_exists curl; then
        curl -fsSL "$url" -o "$output"
    elif command_exists wget; then
        wget -q "$url" -O "$output"
    else
        print_error "Neither curl nor wget is available. Please install one of them."
        exit 1
    fi
}

# Function to install kubelist
install_kubelist() {
    local temp_dir
    temp_dir=$(mktemp -d)
    local script_path="${temp_dir}/${SCRIPT_NAME}"
    local man_path="${temp_dir}/${SCRIPT_NAME}.1"
    
    print_status "Downloading kubelist v${VERSION}..."
    
    # Download the main script
    download_file "${GITHUB_URL}/raw/v${VERSION}/${SCRIPT_NAME}" "$script_path"
    
    # Download the man page
    download_file "${GITHUB_URL}/raw/v${VERSION}/man/man1/${SCRIPT_NAME}.1" "$man_path"
    
    # Make script executable
    chmod +x "$script_path"
    
    # Install script
    print_status "Installing kubelist to ${INSTALL_DIR}..."
    if is_root; then
        cp "$script_path" "${INSTALL_DIR}/${SCRIPT_NAME}"
    else
        sudo cp "$script_path" "${INSTALL_DIR}/${SCRIPT_NAME}"
    fi
    
    # Install man page
    print_status "Installing man page to ${MAN_DIR}..."
    if is_root; then
        mkdir -p "$MAN_DIR"
        cp "$man_path" "${MAN_DIR}/${SCRIPT_NAME}.1"
        mandb >/dev/null 2>&1 || true
    else
        sudo mkdir -p "$MAN_DIR"
        sudo cp "$man_path" "${MAN_DIR}/${SCRIPT_NAME}.1"
        sudo mandb >/dev/null 2>&1 || true
    fi
    
    # Cleanup
    rm -rf "$temp_dir"
    
    print_success "kubelist v${VERSION} installed successfully!"
}

# Function to verify installation
verify_installation() {
    print_status "Verifying installation..."
    
    if command_exists kubelist; then
        local installed_version
        installed_version=$(kubelist --version 2>/dev/null | grep -o 'version [0-9.]*' | cut -d' ' -f2)
        if [ "$installed_version" = "$VERSION" ]; then
            print_success "kubelist v${installed_version} is working correctly"
        else
            print_warning "Version mismatch: expected ${VERSION}, found ${installed_version}"
        fi
    else
        print_error "kubelist not found in PATH after installation"
        exit 1
    fi
    
    # Check if man page is available
    if man kubelist >/dev/null 2>&1; then
        print_success "Man page installed successfully"
    else
        print_warning "Man page may not be installed correctly"
    fi
}

# Function to check prerequisites
check_prerequisites() {
    print_status "Checking prerequisites..."
    
    # Check if kubectl is installed
    if ! command_exists kubectl; then
        print_error "kubectl is not installed or not in PATH"
        print_error "Please install kubectl first: https://kubernetes.io/docs/tasks/tools/"
        exit 1
    fi
    
    print_success "kubectl found: $(kubectl version --client --short 2>/dev/null || kubectl version --client 2>/dev/null | head -1)"
    
    # Check if we have permission to install
    if [ ! -w "$INSTALL_DIR" ] && ! is_root; then
        print_status "Installation requires sudo privileges"
    fi
}

# Function to show usage
show_usage() {
    cat << EOF
kubelist Installation Script

USAGE:
    $0 [OPTIONS]

OPTIONS:
    -h, --help      Show this help message
    -v, --version   Show version information
    --uninstall     Uninstall kubelist

EXAMPLES:
    $0              Install kubelist
    $0 --uninstall  Remove kubelist

This script will install kubelist to ${INSTALL_DIR} and the man page to ${MAN_DIR}.
EOF
}

# Function to uninstall kubelist
uninstall_kubelist() {
    print_status "Uninstalling kubelist..."
    
    # Remove script
    if [ -f "${INSTALL_DIR}/${SCRIPT_NAME}" ]; then
        if is_root; then
            rm "${INSTALL_DIR}/${SCRIPT_NAME}"
        else
            sudo rm "${INSTALL_DIR}/${SCRIPT_NAME}"
        fi
        print_success "Removed ${INSTALL_DIR}/${SCRIPT_NAME}"
    else
        print_warning "${INSTALL_DIR}/${SCRIPT_NAME} not found"
    fi
    
    # Remove man page
    if [ -f "${MAN_DIR}/${SCRIPT_NAME}.1" ]; then
        if is_root; then
            rm "${MAN_DIR}/${SCRIPT_NAME}.1"
            mandb >/dev/null 2>&1 || true
        else
            sudo rm "${MAN_DIR}/${SCRIPT_NAME}.1"
            sudo mandb >/dev/null 2>&1 || true
        fi
        print_success "Removed ${MAN_DIR}/${SCRIPT_NAME}.1"
    else
        print_warning "${MAN_DIR}/${SCRIPT_NAME}.1 not found"
    fi
    
    print_success "kubelist uninstalled successfully!"
}

# Main script
main() {
    case "${1:-}" in
        -h|--help)
            show_usage
            exit 0
            ;;
        -v|--version)
            echo "kubelist installation script v${VERSION}"
            exit 0
            ;;
        --uninstall)
            uninstall_kubelist
            exit 0
            ;;
        "")
            check_prerequisites
            install_kubelist
            verify_installation
            echo
            print_success "Installation complete! Try running: kubelist --help"
            print_status "View the manual with: man kubelist"
            ;;
        *)
            print_error "Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"
