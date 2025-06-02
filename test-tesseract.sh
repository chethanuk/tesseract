#!/bin/bash
# Test script for Tesseract OCR installation

set -e

echo "=== Tesseract OCR Installation Test ==="
echo

# Check if tesseract is installed
if ! command -v tesseract &> /dev/null; then
    echo "ERROR: Tesseract is not installed or not in PATH"
    exit 1
fi

# Display version
echo "1. Tesseract Version:"
tesseract --version
echo

# Check available languages
echo "2. Available Languages:"
tesseract --list-langs
echo

# Test basic OCR functionality if test image is provided
if [ $# -eq 1 ]; then
    TEST_IMAGE="$1"
    if [ -f "$TEST_IMAGE" ]; then
        echo "3. Testing OCR on: $TEST_IMAGE"
        OUTPUT_BASE="${TEST_IMAGE%.*}_output"
        tesseract "$TEST_IMAGE" "$OUTPUT_BASE" -l eng
        
        if [ -f "${OUTPUT_BASE}.txt" ]; then
            echo "OCR Output:"
            echo "----------------------------------------"
            cat "${OUTPUT_BASE}.txt"
            echo "----------------------------------------"
            echo "OCR test completed successfully!"
            rm -f "${OUTPUT_BASE}.txt"
        else
            echo "ERROR: OCR output file not created"
            exit 1
        fi
    else
        echo "WARNING: Test image not found: $TEST_IMAGE"
    fi
else
    echo "3. OCR Test: Skipped (no test image provided)"
    echo "   Usage: $0 <test_image.png>"
fi

echo
echo "=== Tesseract installation test completed ==="
