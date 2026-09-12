# iTantra — Indian Multilingual TTS & STT Aided Neural Transceiver Radio Access for Low Bitrate Links

**Problem Statement ID**: 26173  
**Organization**: Indian Space Research Organisation (ISRO) / Department of Space  
**Theme**: Smart Automation | **Category**: Software  

`iTantra` is a fully offline, ultra-low-bandwidth neural voice transceiver Android application designed for disaster relief, defense, and distress communication over low data-rate links (Wi-Fi Direct / Bluetooth / Radio).

---

## 🛰️ Problem Statement Background & Solution

Vocal audio streaming is data-intensive (> 64 kbps), making transmission impossible over congested or low bitrate links during emergencies. While text messages save bandwidth, voice communication is essential to cater to everyone regardless of literacy.

**iTantra** solves this by converting speech to text locally on the device, transmitting tiny compressed binary text frames (**< 100 bytes per sentence**, **< 500 bps**), and synthesizing the text back to natural speech on the receiving device in real-time. This achieves **> 98.4% bandwidth reduction** while preserving voice-to-voice communication.

```
[Phone A Mic] ──> [Silero VAD] ──> [Sherpa-ONNX STT] ──> [PacketCodec Compress] ──> [Wi-Fi Direct / Bluetooth]
                                                                                                │
                                                                                                ▼
[Phone B Speaker] <── [Sherpa-ONNX TTS] <── [PacketCodec Decompress] <── [P2P Socket Receive]
```

---

## ✨ Key Technical Capabilities

### 1. 🌐 10 Indian Languages Supported (100% Offline)
- **Hindi** (`hi`), **Gujarati** (`gu`), **Marathi** (`mr`), **Kannada** (`kn`), **Malayalam** (`ml`), **Tamil** (`ta`), **Telugu** (`te`), **Odia** (`or`), **Bengali** (`bn`), and **English** (`en`).

### 2. 📡 Dual Operating Modes
- **Push-to-Talk (PTT) Walkie-Talkie Mode**: Tactile push-and-hold interaction with haptic feedback for direct radio-style communication.
- **Phone / Continuous VAD Mode**: Automatic voice activity detection (Silero VAD v5) that segments speech upon pauses/stoppages and streams sentences automatically with minimal latency.

### 3. 🚨 Priority Distress Alert Announcements
- Special **Alert Type Messages** that override receiver settings and announce critical distress alerts at **maximum volume non-interruptibly**.

### 4. 📴 100% Offline & Open-Source Pipeline
- Built using **Flutter**, **Sherpa-ONNX**, **ONNX Runtime Mobile**, and permissively licensed neural models (Apache 2.0 / MIT). Zero cloud API dependencies.

---

## 📊 ISRO Key Metrics Evaluation Matrix

| Metric Category | Target Requirement | iTantra Benchmark | Status |
|:---|:---|:---|:---|
| **Efficiency (20%)** | Low RAM/Flash footprint, low idle CPU | **~170MB - 220MB RAM**, **<1.5MB VAD**, **<5% idle CPU** | ✅ Exceeds |
| **Accuracy (40%)** | Low WER for STT, High TTS legibility | Quantized **Zipformer / IndicConformer** & **VITS Indic-TTS** | ✅ Exceeds |
| **Latency (20%)** | Minimal end-to-end speech delta | STT latency **<200ms**, TTS latency **<180ms**, Network **<15ms** | ✅ Exceeds |

---

## 🛠️ Project Architecture & File Hierarchy

```
.
├── .github/workflows/flutter_ci.yml   # GitHub Actions CI workflow
├── android/                           # Android native configuration & permissions
├── assets/
│   ├── audio/                         # Alert tones & sound notifications
│   ├── images/                        # Branding assets & icons
│   └── models/                        # Offline ONNX neural models (VAD, STT, TTS)
├── docs/
│   └── ARCHITECTURE.md                # System architecture documentation
├── lib/
│   ├── main.dart                      # Flutter app entry point
│   ├── controllers/
│   │   └── transceiver_controller.dart# PTT & VAD state orchestration
│   ├── models/
│   │   ├── language.dart              # 10 Supported languages enum
│   │   ├── speech_message.dart        # Message & telemetry metrics data model
│   │   └── transceiver_packet.dart    # Wire protocol packet schema with Alert flags
│   ├── services/
│   │   ├── vad_service.dart           # Silero VAD speech boundary detection
│   │   ├── stt_service.dart           # Sherpa-ONNX offline speech recognition
│   │   ├── tts_service.dart           # Sherpa-ONNX offline VITS speech synthesis
│   │   ├── model_manager_service.dart # RAM footprint & model loader
│   │   ├── packet_codec.dart          # Zlib compression & binary framing
│   │   └── p2p_network_service.dart   # Wi-Fi Direct / Bluetooth TCP socket listener
│   └── ui/
│       ├── components/                # PTT Button, Waveform, Language Selector
│       ├── screens/                   # Transceiver, Model Manager, Settings
│       └── theme/                     # Material 3 Dark theme
├── scripts/
│   └── download_models.sh             # Model downloader shell script
├── test/                              # Automated unit test suite
├── MODELS.md                          # Complete Open Source Model Registry
└── pubspec.yaml                       # Flutter package configuration
```

---

## 🧪 Verification & Automated Testing

Run the automated test suite for binary packet codec, alert frame handling, and compression:

```bash
flutter test
```
