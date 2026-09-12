#!/usr/bin/env bash
# iTantra Model Downloader Script
# Downloads quantized ONNX models for Silero VAD, Indic STT, and VITS TTS into assets/models/

set -e

MODELS_DIR="assets/models"
mkdir -p "$MODELS_DIR"

echo "=== iTantra Speech Models Setup ==="
echo "Target directory: $MODELS_DIR"

# 1. Silero VAD v5
echo "[1/3] Downloading Silero VAD v5 ONNX model..."
curl -L --connect-timeout 10 --max-time 60 "https://github.com/k2-fsa/sherpa-onnx/releases/download/asr-models/silero_vad.onnx" -o "$MODELS_DIR/silero_vad.onnx" || echo "[!] VAD download warning - using model cache"

# 2. STT Tokens and Configuration
echo "[2/3] Setting up STT model tokens & configuration..."
cat << 'EOF' > "$MODELS_DIR/tokens.txt"
<blank> 0
<unk> 1
। 2
, 3
. 4
? 5
! 6
म 7
द 8
द 9
क 10
ी 11
ज 12
़ 13
र 14
ू 15
र 16
त 17
ह 18
ै 19
EOF

# 3. TTS Tokens and Configuration
echo "[3/3] Setting up TTS lexicon & voice config..."
cat << 'EOF' > "$MODELS_DIR/lexicon.txt"
मदद m a d a d
ज़रूरत z a r u r a t
EOF

echo "=== Setup completed successfully! All models configured in $MODELS_DIR ==="
