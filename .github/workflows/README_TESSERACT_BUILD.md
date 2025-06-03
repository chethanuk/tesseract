# Tesseract OCR Multi-Version Build and Publish Workflow

This workflow implements a comprehensive CI/CD pipeline for building, signing, publishing, and verifying Tesseract OCR RPM packages across multiple Tesseract and Leptonica version combinations.

## Overview

The workflow provides:
- Matrix builds for 4 Tesseract versions (5.3.1, 5.3.4, 5.4.1, 5.5.1) × 2 Leptonica versions (1.82.0, 1.85.0)
- Support for AlmaLinux 8 and Amazon Linux 2023
- GPG signing for package security
- Publishing to both GitHub Releases and openSUSE Build Service (OBS)
- Comprehensive verification on multiple OS environments
- Automated workflow summary reporting

## Workflow Structure

### 1. GPG Key Setup (`setup_gpg_key`)
- Generates a 4096-bit RSA GPG key for package signing
- Creates "Tesseract OCR Build Bot" identity
- Exports public key for distribution
- **Note**: In production, use a pre-existing key stored in GitHub Secrets

### 2. Build Jobs

#### AlmaLinux 8 Build (`build_and_package_tesseract`)
- Builds Leptonica and Tesseract from source
- Creates RPM package with proper metadata
- Includes GPG signing configuration
- Supports all matrix combinations

#### Amazon Linux 2023 Build (`build_for_amazon_linux_2023`)
- Similar to AlmaLinux build but optimized for AL2023
- Handles lib64 directories properly
- Uses Amazon-specific release tags

### 3. Publishing Jobs

#### GitHub Release Publishing (`publish_to_github_release`)
- Creates version-specific releases
- Uploads RPM and spec files
- Tags format: `v{tesseract_version}-leptonica{leptonica_version}`

#### OBS Publishing (`publish_to_obs`)
- Pushes to openSUSE Build Service
- Manages versioned packages
- Handles authentication via secrets

### 4. Verification Jobs

#### GitHub Release Verification (`verify_github_release`)
- Downloads and installs RPMs from GitHub
- Tests on AlmaLinux 8 and Amazon Linux 2023
- Performs functional OCR tests
- Verifies installed files and languages

#### OBS Package Verification (`verify_obs_packages`)
- Adds OBS repositories for each OS
- Installs from OBS repositories
- Tests on openSUSE Leap 15.5, AlmaLinux 8, and AL2023
- Verifies package signatures where supported

### 5. Workflow Summary (`workflow_summary`)
- Aggregates results from all jobs
- Provides installation instructions
- Reports failures and successes
- Creates GitHub Actions summary

## Configuration

### Required Secrets
- `OBS_PASSWORD`: Authentication for openSUSE Build Service
- `GITHUB_TOKEN`: Automatically provided by GitHub Actions

### Environment Variables
- `OBS_PROJECT`: Default is `home:chethanuk1989`
- `OBS_PACKAGE`: Default is `tesseract-ocr`

### Matrix Configuration
```yaml
tesseract_version: ["5.3.1", "5.3.4", "5.4.1", "5.5.1"]
leptonica_version: ["1.82.0", "1.85.0"]
```

## Security Best Practices

### GPG Signing
- All RPMs include GPG signing directives
- Public key distributed via artifacts
- Signature verification in verification jobs

### Repository Security
- HTTPS for all downloads
- GPG key import for OBS repositories
- SSL certificate verification

### Build Security
- Containerized builds for isolation
- Minimal privilege execution
- Clean build environments

## Installation Instructions

### From GitHub Releases
```bash
# Download specific version
wget https://github.com/{owner}/{repo}/releases/download/v5.5.1-leptonica1.85.0/tesseract-ocr-5.5.1-1.el8.x86_64.rpm

# Install
sudo dnf install ./tesseract-ocr-5.5.1-1.el8.x86_64.rpm
```

### From OBS Repository

#### AlmaLinux 8 / RHEL 8
```bash
# Add repository
sudo dnf config-manager --add-repo https://download.opensuse.org/repositories/home:chethanuk1989/RHEL_8/home:chethanuk1989.repo

# Install
sudo dnf install tesseract-ocr
```

#### Amazon Linux 2023
```bash
# Add repository
sudo dnf config-manager --add-repo https://download.opensuse.org/repositories/home:chethanuk1989/AmazonLinux_2023/home:chethanuk1989.repo

# Install
sudo dnf install tesseract-ocr
```

#### openSUSE Leap 15.5
```bash
# Add repository
sudo zypper addrepo https://download.opensuse.org/repositories/home:chethanuk1989/openSUSE_Leap_15.5/home:chethanuk1989.repo

# Refresh and install
sudo zypper refresh
sudo zypper install tesseract-ocr
```

## Troubleshooting

### Build Failures
- Check matrix combination compatibility
- Verify dependency availability
- Review container logs

### Publishing Failures
- Verify OBS credentials
- Check GitHub permissions
- Ensure unique version tags

### Verification Failures
- Check repository connectivity
- Verify GPG key availability
- Review package dependencies

## Maintenance

### Adding New Versions
1. Update matrix configuration in workflow
2. Test compatibility locally
3. Create PR with changes
4. Monitor workflow execution

### Updating Dependencies
1. Update BuildRequires in spec file generation
2. Test on all target platforms
3. Update verification tests if needed

### Security Updates
1. Rotate GPG keys annually
2. Update repository URLs as needed
3. Review and update SSL certificates

## Performance Optimization

The workflow uses:
- `max-parallel: 2` to limit concurrent matrix jobs
- `fail-fast: false` to complete all builds
- Conditional job execution
- Artifact retention limits (30 days)

## Contributing

When contributing:
1. Test changes on a feature branch
2. Ensure all matrix combinations build
3. Verify package installation works
4. Update documentation as needed

## License

This workflow is part of the Tesseract OCR project and follows the same licensing terms.
