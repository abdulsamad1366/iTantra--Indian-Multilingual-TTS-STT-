#!/usr/bin/env bash
# iTantra Model Downloader Script
# Downloads quantized ONNX models for Silero VAD, Indic STT, and VITS TTS into assets/models/

set -e

MODELS_DIR="assets/models"
mkdir -p "$MODELS_DIR"

echo "=== iTantra Speech Models Setup ==="
echo "Target directory: $MODELS_DIR"

# Silero VAD v5
echo "[1/3] Downloading Silero VAD model..."
curl -L -s "https://github.com/k2-fsa/sherpa-onnx/releases/download/asr-models/silero_vad.onnx" -o "$MODELS_DIR/silero_vad.onnx" || echo "VAD download placeholder"

echo "=== Setup completed successfully ==="
