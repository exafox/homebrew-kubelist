# Kubelist Homebrew Formula

This directory contains the Homebrew formula for kubelist.

## Quick Installation

```bash
# Install via Homebrew (once the tap is set up)
brew install your-username/kubelist/kubelist

# Or install directly from this repository
brew install --build-from-source homebrew-formula/kubelist.rb
```

## Setting Up Your Own Homebrew Tap

To distribute kubelist via Homebrew, you'll need to create a Homebrew tap:

### 1. Create a Homebrew Tap Repository

Create a new GitHub repository named `homebrew-kubelist` (must start with `homebrew-`):

```bash
# Create the repository on GitHub, then:
git clone https://github.com/your-username/homebrew-kubelist.git
cd homebrew-kubelist

# Copy the formula
cp /path/to/kubelist/homebrew-formula/kubelist.rb ./kubelist.rb

# Commit and push
git add kubelist.rb
git commit -m "Add kubelist formula"
git push origin main
```

### 2. Update Formula URLs

Before publishing, update the formula with the correct information:

1. **Update the homepage URL** in `kubelist.rb`
2. **Update the source URL** to point to your GitHub releases
3. **Calculate and update the SHA256 hash** of your release tarball
4. **Update the GitHub username** in the formula

### 3. Generate SHA256 Hash

When you create a GitHub release, calculate the SHA256 hash:

```bash
# Download your release tarball
curl -L https://github.com/your-username/kubelist/archive/v1.0.0.tar.gz -o kubelist-1.0.0.tar.gz

# Calculate SHA256
shasum -a 256 kubelist-1.0.0.tar.gz
```

Update the `sha256` field in the formula with this hash.

### 4. Test the Formula

Test your formula locally before publishing:

```bash
# Install from local formula
brew install --build-from-source ./kubelist.rb

# Test the installation
kubelist --version
kubelist --help

# Run the formula's built-in tests
brew test kubelist

# Uninstall for clean testing
brew uninstall kubelist
```

### 5. Publish Your Tap

Once your `homebrew-kubelist` repository is ready:

```bash
# Users can then install with:
brew tap your-username/kubelist
brew install kubelist

# Or in one command:
brew install your-username/kubelist/kubelist
```

## Formula Details

The kubelist formula:

- **Depends on**: `kubectl` (automatically installed if not present)
- **Installs**: 
  - `kubelist` script to `/usr/local/bin/`
  - Man page to `/usr/local/share/man/man1/`
- **Tests**: Verifies installation and basic functionality

## Updating the Formula

When you release a new version:

1. Update the `version` field
2. Update the `url` to point to the new release
3. Update the `sha256` hash
4. Commit and push to your tap repository

## Alternative Installation Methods

If you don't want to maintain a Homebrew tap, users can:

```bash
# Install directly from the formula file
brew install https://raw.githubusercontent.com/your-username/kubelist/main/homebrew-formula/kubelist.rb

# Use the installation script
curl -sSL https://raw.githubusercontent.com/your-username/kubelist/main/install.sh | bash
```
