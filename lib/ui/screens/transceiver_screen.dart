import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/transceiver_controller.dart';
import '../../models/speech_message.dart';
import '../../services/p2p_network_service.dart';
import '../components/language_selector.dart';
import '../components/metrics_card.dart';
import '../components/ptt_button.dart';
import '../components/waveform_visualizer.dart';
import '../theme/app_theme.dart';
import 'model_management_screen.dart';
import 'settings_screen.dart';

class TransceiverScreen extends StatelessWidget {
  const TransceiverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TransceiverController>();

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.radio, color: AppTheme.activeGreen, size: 22),
            SizedBox(width: 8),
            Text(
              "iTantra Transceiver",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.memory, color: AppTheme.textSecondary),
            tooltip: "Models & Licenses",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ModelManagementScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: AppTheme.textSecondary),
            tooltip: "Connection Settings",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildConnectionHeader(context, controller),
            _buildModeToggleBar(controller),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    child: LanguageSelector(
                      label: "Tx (Speak)",
                      selectedLanguage: controller.sourceLanguage,
                      onLanguageChanged: (lang) => controller.setSourceLanguage(lang),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: LanguageSelector(
                      label: "Rx (Synthesize)",
                      selectedLanguage: controller.targetLanguage,
                      onLanguageChanged: (lang) => controller.setTargetLanguage(lang),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: MetricsCard(
                latestMessage: controller.messages.isNotEmpty ? controller.messages.first : null,
              ),
            ),
            Expanded(
              child: controller.messages.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      reverse: true,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: controller.messages.length,
                      itemBuilder: (context, index) {
                        return _buildMessageBubble(controller.messages[index]);
                      },
                    ),
            ),
            WaveformVisualizer(
              amplitudes: controller.livePcmAmplitudes,
              isActive: controller.isRecording || controller.isProcessingStt || controller.isProcessingTts,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: PttButton(
                isRecording: controller.isRecording,
                isProcessing: controller.isProcessingStt || controller.isProcessingTts,
                onPressStart: () => controller.startPttRecording(),
                onPressEnd: () => controller.stopPttRecordingAndSend(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionHeader(BuildContext context, TransceiverController controller) {
    final status = controller.connectionStatus;
    final peer = controller.connectedPeer;

    Color statusColor;
    String statusText;

    switch (status) {
      case ConnectionStatus.connectedServer:
        statusColor = AppTheme.activeGreen;
        statusText = "HOSTING P2P • Connected to ${peer ?? 'Peer'}";
        break;
      case ConnectionStatus.connectedClient:
        statusColor = AppTheme.activeGreen;
        statusText = "CONNECTED • Host ${peer ?? 'Peer'}";
        break;
      case ConnectionStatus.connecting:
        statusColor = Colors.amber;
        statusText = "CONNECTING P2P PAIR...";
        break;
      case ConnectionStatus.disconnected:
        statusColor = Colors.redAccent;
        statusText = "OFFLINE MODE • Standalone Transceiver";
        break;
    }

    return Container(
      width: double.infinity,
      color: statusColor.withOpacity(0.15),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(shape: BoxShape.circle, color: statusColor),
          ),
          const SizedBox(width: 8),
          Text(
            statusText,
            style: TextStyle(
              color: statusColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeToggleBar(TransceiverController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => controller.setMode(true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: controller.isPushToTalkMode ? AppTheme.primaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: const Text(
                  "PUSH-TO-TALK (PTT)",
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => controller.setMode(false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: !controller.isPushToTalkMode ? AppTheme.activeGreen : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: const Text(
                  "CONTINUOUS VAD MODE",
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.record_voice_over, size: 48, color: AppTheme.textSecondary.withOpacity(0.4)),
          const SizedBox(height: 12),
          const Text(
            "Press & Hold Push to Talk to Communicate",
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 4),
          const Text(
            "Audio is processed 100% offline & transmitted as compressed text",
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(SpeechMessage msg) {
    final isMe = msg.isSentByMe;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: isMe ? AppTheme.primaryColor.withOpacity(0.85) : AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomRight: isMe ? Radius.zero : const Radius.circular(16),
            bottomLeft: !isMe ? Radius.zero : const Radius.circular(16),
          ),
          border: Border.all(
            color: isMe ? AppTheme.primaryColor : const Color(0xFF334155),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  msg.senderName,
                  style: TextStyle(
                    color: isMe ? Colors.white70 : AppTheme.activeGreen,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "${msg.compressedPacketBytes} B",
                  style: const TextStyle(color: Colors.white54, fontSize: 9),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              msg.text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "${msg.sourceLanguage.code.toUpperCase()} → ${msg.targetLanguage.code.toUpperCase()}",
                  style: const TextStyle(color: Colors.white38, fontSize: 9),
                ),
                const SizedBox(width: 8),
                Text(
                  "${msg.timestamp.hour}:${msg.timestamp.minute.toString().padLeft(2, '0')}",
                  style: const TextStyle(color: Colors.white38, fontSize: 9),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
