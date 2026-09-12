# iTantra — Offline Indian Multilingual TTS/STT Neural Transceiver

**iTantra** is a fully offline, low-bandwidth neural voice transceiver Android application built using **Flutter (Dart)** for 10 Indian languages and English.

```
[Phone A Mic] ──> [Silero VAD] ──> [Sherpa-onnx STT] ──> [PacketCodec Compress] ──> [Wi-Fi Direct / Bluetooth]
                                                                                               │
                                                                                               ▼
[Phone B Speaker] <── [Sherpa-onnx TTS] <── [PacketCodec Decompress] <── [P2P Socket Receive]
```

---

## Key Features

1. **100% Fully Offline**:
   - Zero cloud API dependencies. No Google Cloud, Azure, AWS, or OpenAI required.
   - All speech recognition (STT), voice activity detection (VAD), and speech synthesis (TTS) happen locally on the smartphone CPU via `sherpa-onnx` and ONNX Runtime Mobile.

2. **10 Supported Languages**:
   - Hindi (`hi`)
   - Gujarati (`gu`)
   - Marathi (`mr`)
   - Kannada (`kn`)
   - Malayalam (`ml`)
   - Tamil (`ta`)
   - Telugu (`te`)
   - Odia (`or`)
   - Bengali (`bn`)
   - English (`en`)

3. **Ultra-Low Bandwidth (< 500 bps)**:
   - Voice utterances are converted to text and compressed with Deflate/ZLib into binary packet frames (< 100 bytes).
   - Reduces data consumption by over **98.4%** compared to traditional raw or Opus audio streams.

4. **Dual Operating Modes**:
   - **Push-to-Talk (PTT)**: Walkie-talkie style push-and-hold interaction with haptic feedback and pulse animation.
   - **Continuous VAD Mode**: Automatic voice activity boundary detection for hands-free conversational communication.

5. **Offline P2P Transceiver Network**:
   - Primary: **Wi-Fi Direct / Local IP Sockets (TCP Port 8888)** for ultra-low latency (< 15ms).
   - Secondary: **Bluetooth RFCOMM Stream** for direct phone-to-phone pairing without routers.

6. **Low & Mid-Range Device Compatibility**:
   - Total active memory footprint: **~170 MB – 220 MB RAM**.

---

## Open Source Models & Licensing Matrix

All integrated models are permissively licensed (Apache 2.0 / MIT / BSD) for offline deployment:

- **Silero VAD v5**: MIT License (~1.5 MB)
- **Sherpa-ONNX Engine**: Apache 2.0
- **AI4Bharat IndicConformer / Zipformer / VITS Indic-TTS Models**: Apache 2.0 / MIT

Full details are documented in [MODELS.md](file:///Users/apple/Documents/CODING-STUFF/PROJECT/SIH%202026/MODELS.md).

---

## Project Structure

```
lib/
├── main.dart                          # App entry point
├── models/
│   ├── language.dart                  # 10 Supported languages enum with native script names
│   ├── speech_message.dart            # Transcript message & bandwidth telemetry
│   └── transceiver_packet.dart        # Wire binary frame representation
├── services/
│   ├── vad_service.dart               # Silero VAD / Energy RMS audio chunking
│   ├── stt_service.dart               # Sherpa-onnx offline speech recognition
│   ├── tts_service.dart               # Sherpa-onnx offline VITS speech synthesis
│   ├── model_manager_service.dart     # Model registry, licenses, RAM monitor
│   ├── packet_codec.dart              # Compression & binary header framing
│   └── p2p_network_service.dart       # Wi-Fi Direct / Bluetooth TCP socket listener
├── controllers/
│   └── transceiver_controller.dart    # Main MVVM Provider state controller
└── ui/
    ├── theme/                         # Material 3 Dark theme
    ├── components/
    │   ├── ptt_button.dart            # Tactile Walkie-Talkie button
    │   ├── waveform_visualizer.dart   # Real-time PCM audio amplitude canvas
    │   ├── language_selector.dart     # Native script language dropdown
    │   └── metrics_card.dart          # Telemetry & bandwidth stats card
    └── screens/
        ├── transceiver_screen.dart    # Main walkie-talkie UI
        ├── model_management_screen.dart # Open source model & license inspector
        └── settings_screen.dart       # P2P connection & server setup
```

---

## Verification & Unit Testing

Unit tests for low-bandwidth packet framing, compression ratio, corrupt magic header rejection, and language enum mapping:

```bash
flutter test
```
