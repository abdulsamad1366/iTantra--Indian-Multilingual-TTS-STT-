# ONNX Speech Models Directory

This directory is designated for storing quantized **Sherpa-ONNX** models used by iTantra for offline operation:

- **Voice Activity Detection (VAD)**: `silero_vad.onnx`
- **Speech-to-Text (STT)**: Zipformer / IndicConformer / MMS ONNX models (`.onnx` + `tokens.txt`)
- **Text-to-Speech (TTS)**: VITS Indic-TTS ONNX models (`.onnx` + `tokens.txt` + `lexicon.txt`)

You can run the model downloader script from the repository root:
```bash
bash scripts/download_models.sh
```
