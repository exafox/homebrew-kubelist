# Release Process for Kubelist

This document outlines the process for creating releases of kubelist.

## Pre-Release Checklist

- [ ] All tests pass locally
- [ ] Documentation is up to date
- [ ] Version number updated in:
  - [ ] `kubelist` script (`VERSION` variable)
  - [ ] `homebrew-formula/kubelist.rb`
  - [ ] `install.sh`
  - [ ] Man page (`kubelist.1`)

## Creating a Release

### 1. Prepare the Release

```bash
# Update version in all files
export NEW_VERSION="1.0.1"

# Update kubelist script
sed -i '' "s/VERSION=\".*\"/VERSION=\"$NEW_VERSION\"/" kubelist

# Update install script
sed -i '' "s/VERSION=\".*\"/VERSION=\"$NEW_VERSION\"/" install.sh

# Update Homebrew formula
sed -i '' "s/version \".*\"/version \"$NEW_VERSION\"/" homebrew-formula/kubelist.rb
sed -i '' "s/v[0-9.]*.tar.gz/v$NEW_VERSION.tar.gz/" homebrew-formula/kubelist.rb

# Update man page date
sed -i '' "s/\".*\" \"Version.*\"/\"$(date '+%B %d, %Y')\" \"Version $NEW_VERSION\"/" man/man1/kubelist.1

# Commit changes
git add .
git commit -m "Bump version to $NEW_VERSION"
git push origin main
```

### 2. Create GitHub Release

```bash
# Create and push tag
git tag -a "v$NEW_VERSION" -m "Release v$NEW_VERSION"
git push origin "v$NEW_VERSION"
```

Then on GitHub:
1. Go to Releases → Create a new release
2. Choose the tag you just created
3. Fill in release notes
4. Attach any additional assets if needed
5. Publish the release

### 3. Update Homebrew Formula SHA256

```bash
# Download the release tarball
curl -L "https://github.com/your-username/kubelist/archive/v$NEW_VERSION.tar.gz" -o "kubelist-$NEW_VERSION.tar.gz"

# Calculate SHA256
NEW_SHA=$(shasum -a 256 "kubelist-$NEW_VERSION.tar.gz" | cut -d' ' -f1)
echo "New SHA256: $NEW_SHA"

# Update the formula
sed -i '' "s/sha256 \".*\"/sha256 \"$NEW_SHA\"/" homebrew-formula/kubelist.rb

# Commit the updated formula
git add homebrew-formula/kubelist.rb
git commit -m "Update Homebrew formula SHA256 for v$NEW_VERSION"
git push origin main
```

### 4. Update Homebrew Tap (if you have one)

If you maintain a separate `homebrew-kubelist` repository:

```bash
# In your homebrew-kubelist repository
cp ../kubelist/homebrew-formula/kubelist.rb ./kubelist.rb
git add kubelist.rb
git commit -m "Update kubelist to v$NEW_VERSION"
git push origin main
```

### 5. Test the Release

```bash
# Test direct installation
./install.sh

# Test Homebrew formula (if available)
brew install --build-from-source homebrew-formula/kubelist.rb
brew test kubelist

# Verify functionality
kubelist --version
kubelist --help
```

## Release Notes Template

Use this template for GitHub releases:

```markdown
## kubelist v1.0.1

### New Features
- Feature description

### Bug Fixes  
- Bug fix description

### Changes
- Change description

### Installation

#### Homebrew (macOS/Linux)
```bash
brew install your-username/kubelist/kubelist
```

#### Direct Installation
```bash
curl -sSL https://raw.githubusercontent.com/your-username/kubelist/v1.0.1/install.sh | bash
```

#### Manual Installation
Download the `kubelist` script and man page from this release.

### Checksums
- kubelist script: `sha256sum`
- Source tarball: `sha256sum`
```

## Post-Release Tasks

- [ ] Announce on relevant platforms (if applicable)
- [ ] Update any documentation that references the old version
- [ ] Monitor for issues with the new release

## Rollback Process

If a release has critical issues:

1. **Immediate**: Update install script to point to previous version
2. **Short-term**: Create a hotfix release
3. **Homebrew**: Update tap to previous working version

```bash
# Emergency rollback of install script
PREVIOUS_VERSION="1.0.0"
sed -i '' "s/VERSION=\".*\"/VERSION=\"$PREVIOUS_VERSION\"/" install.sh
git add install.sh
git commit -m "Emergency rollback to v$PREVIOUS_VERSION"
git push origin main
```
