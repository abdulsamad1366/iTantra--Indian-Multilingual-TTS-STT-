# iTantra Architecture Overview

`iTantra` is an offline Indian Multilingual Push-to-Talk (PTT) Transceiver powered by Sherpa-ONNX neural speech models and peer-to-peer (P2P) mesh networking.

## Directory Structure

```
.
├── android/                   # Android native platform configurations and permissions
├── assets/                    # Static app assets and neural speech models
│   ├── audio/                 # Sound effects & tone notifications
│   ├── images/                # UI icons and branding graphics
│   └── models/                # Offline ONNX STT, TTS, and VAD neural models
├── docs/                      # Technical documentation and architecture diagrams
│   └── ARCHITECTURE.md
├── lib/                       # Core Dart/Flutter application source code
│   ├── controllers/           # Application state controllers & transceivers
│   ├── models/                # Data objects (Language, Packet, SpeechMessage)
│   ├── services/              # STT, TTS, VAD, P2P network, and codec services
│   ├── ui/                    # User Interface (Components, Screens, Theme)
│   └── main.dart              # Flutter app entry point
├── scripts/                   # Helper bash scripts (model fetchers, build helpers)
│   └── download_models.sh
├── test/                      # Unit tests for codecs, state, and languages
├── MODELS.md                  # Detailed open-source speech model registry
├── README.md                  # Main repository README & user quickstart guide
└── pubspec.yaml               # Flutter package configuration & dependencies
```

## Core Subsystems

1. **Neural Speech Subsystem (`lib/services/`)**:
   - `vad_service.dart`: Silero VAD v5 for speech activity detection.
   - `stt_service.dart`: Zipformer/IndicConformer/MMS ONNX speech recognition.
   - `tts_service.dart`: VITS Indic-TTS speech synthesis.
   - `model_manager_service.dart`: Manages model lifecycle and memory allocation.

2. **Network & Codec Subsystem (`lib/services/`)**:
   - `p2p_network_service.dart`: Local P2P discovery & binary socket communication.
   - `packet_codec.dart`: Lightweight binary packet encoding/decoding (<100 byte text payloads).

3. **Controller & UI Subsystem (`lib/controllers/`, `lib/ui/`)**:
   - `transceiver_controller.dart`: Orchestrates PTT events, STT transcription, and TTS output.
   - `transceiver_screen.dart`: Main push-to-talk interface with live waveform visualizer.
