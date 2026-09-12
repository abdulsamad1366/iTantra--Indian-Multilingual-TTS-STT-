# iTantra Architecture Overview

`iTantra` is an offline Indian Multilingual Push-to-Talk (PTT) Transceiver powered by Sherpa-ONNX neural speech models and peer-to-peer (P2P) mesh networking.

---

## 1. Transmitter Data Flow (Microphone to Network)

```
USER
  │
  ▼
MICROPHONE
  │
  ▼
AudioRecord
  │
  ▼
PCM (Pulse Code Modulation)
  │
  ▼
VAD (Voice Activity Detector)
  │
  ▼
Speech detected
  │
  ▼
STT ENGINE (Sherpa-ONNX Offline STT)
  │
  ▼
"मुझे मदद चाहिए" (Recognized Text)
  │
  ▼
TEXT PROCESSOR
  │
  ▼
PACKET ENCODER (Zlib Deflate + 23-byte Binary Header)
  │
  ▼
Wi-Fi / Bluetooth
```

---

## 2. Receiver Data Flow (Network to Speaker)

```
Wi-Fi / Bluetooth
  │
  ▼
PACKET RECEIVER
  │
  ▼
PACKET DECODER
  │
  ▼
"मुझे मदद चाहिए" (Received Text)
  │
  ▼
TTS ENGINE (Sherpa-ONNX VITS Offline TTS)
  │
  ▼
PCM AUDIO (16kHz / 22.05kHz Audio Buffer)
  │
  ▼
AUDIO PLAYER
  │
  ▼
SPEAKER
```

---

## 3. VAD Architecture Flow (20% Efficiency Optimization)

*Don't have the STT model continuously process everything.*

```
Microphone
  │
  ▼
Audio chunks
  │
  ▼
VAD (Silero VAD / Energy RMS)
 ├── Silence ──> ignore
 └── Speech  ──> STT buffer
                  │
                  ▼
                Endpoint detected (Pause / Stoppage)
                  │
                  ▼
                STT final (Triggers STT model inference once per utterance)
```

*This eliminates continuous model inference, saving CPU cycles, reducing battery drain, and optimizing the 20% Efficiency score.*

---

## 4. Directory Structure

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

---

## 5. Core Subsystems

1. **Neural Speech Subsystem (`lib/services/`)**:
   - `vad_service.dart`: Silero VAD v5 / Energy RMS PCM chunking and speech boundary detection.
   - `stt_service.dart`: Sherpa-ONNX offline speech recognition for 10 Indian languages + English.
   - `tts_service.dart`: VITS Indic-TTS offline speech synthesis producing PCM audio buffers.
   - `model_manager_service.dart`: Manages ONNX model lifecycle and memory allocation.

2. **Network & Codec Subsystem (`lib/services/`)**:
   - `p2p_network_service.dart`: Local P2P discovery & binary socket communication over Wi-Fi/Bluetooth.
   - `packet_codec.dart`: Lightweight binary packet encoding/decoding (<100 byte text payloads).

3. **Controller & UI Subsystem (`lib/controllers/`, `lib/ui/`)**:
   - `transceiver_controller.dart`: Orchestrates PTT events, VAD continuous listening, STT transcription, and TTS output.
   - `transceiver_screen.dart`: Main push-to-talk interface with live PCM waveform visualizer.
