# Tesseract OCR OpenSUSE Build Service (OBS) Publishing

This workflow builds Tesseract OCR with Leptonica and publishes it to OpenSUSE Build Service.

## Prerequisites

1. **GitHub Secrets Required:**
   - `OBS_TOKEN`: Your OpenSUSE Build Service API token (required for authentication)

2. **OBS Project Setup:**
   - Project: `home:chethanuk`
   - Package: `tesseract5`

## Workflow Overview

The workflow consists of three main jobs:

### 1. Build and Package Tesseract
- Uses CentOS Stream 8 container
- Builds Leptonica v1.82.0 from source
- Builds Tesseract v5.3.1 from source
- Creates RPM package with custom spec file

### 2. Publish to OpenSUSE Build Service
- Configures osc (OpenSUSE command-line client)
- Uploads RPM and spec file to OBS
- Triggers rebuild on OBS platform

### 3. Create GitHub Release
- Creates a GitHub release with version tag
- Uploads RPM and spec file as release assets

## Setting up OBS Token

1. Go to https://build.opensuse.org
2. Login with your account
3. Go to your profile settings
4. Generate an API token
5. Add it as a GitHub secret named `OBS_TOKEN`

## Manual Trigger

The workflow can be manually triggered from GitHub Actions tab or via GitHub CLI:

```bash
gh workflow run build-tesseract-obs.yml
```

## Monitoring Build Status

After the workflow completes, you can monitor the OBS build status at:
https://build.opensuse.org/package/show/home:chethanuk/tesseract5

## Package Installation

Once built on OBS, the package will be available for various distributions. Users can install it by:

1. Adding the repository:
```bash
# For openSUSE
zypper addrepo https://download.opensuse.org/repositories/home:/chethanuk/openSUSE_Tumbleweed/home:chethanuk.repo

# For CentOS/RHEL 8
dnf config-manager --add-repo https://download.opensuse.org/repositories/home:/chethanuk/CentOS_8/home:chethanuk.repo
```

2. Installing the package:
```bash
# openSUSE
zypper install tesseract-ocr-custom

# CentOS/RHEL
dnf install tesseract-ocr-custom
```

## Customization

To build a different version, modify these environment variables in the workflow:
- `LEPTONICA_VERSION`: Leptonica version to build
- `TESSERACT_VERSION`: Tesseract version to build

## Troubleshooting

1. **OBS Authentication Failed**: Check that your OBS_TOKEN secret is correctly set
2. **Build Failures**: Check the workflow logs and OBS build logs
3. **Package Not Found**: Ensure the OBS project and package names match your configuration
