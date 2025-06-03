#!/bin/bash

# Test script to validate spec templates

echo "Testing spec template substitution..."

# Test variables
TESSERACT_VERSION="5.5.1"
LEPTONICA_VERSION="1.85.0"
DATE="Mon Jun 03 2025"

echo ""
echo "=== Testing AlmaLinux 8 spec template ==="
sed -e "s/\${TESSERACT_VERSION}/$TESSERACT_VERSION/g" \
    -e "s/\${LEPTONICA_VERSION}/$LEPTONICA_VERSION/g" \
    -e "s/\${DATE}/$DATE/g" \
    spec-templates/almalinux8.spec.template > /tmp/test-almalinux8.spec

echo "First 20 lines of generated spec:"
head -20 /tmp/test-almalinux8.spec

echo ""
echo "=== Testing Amazon Linux 2023 spec template ==="
sed -e "s/\${TESSERACT_VERSION}/$TESSERACT_VERSION/g" \
    -e "s/\${LEPTONICA_VERSION}/$LEPTONICA_VERSION/g" \
    -e "s/\${DATE}/$DATE/g" \
    spec-templates/amazonlinux2023.spec.template > /tmp/test-amazonlinux2023.spec

echo "First 20 lines of generated spec:"
head -20 /tmp/test-amazonlinux2023.spec

echo ""
echo "=== Checking for proper substitution ==="
echo "AlmaLinux 8 spec:"
grep -E "(Version:|Release:|Changelog)" /tmp/test-almalinux8.spec | head -5

echo ""
echo "Amazon Linux 2023 spec:"
grep -E "(Version:|Release:|Changelog)" /tmp/test-amazonlinux2023.spec | head -5

echo ""
echo "Test complete!"
