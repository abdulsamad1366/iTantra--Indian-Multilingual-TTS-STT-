import 'package:flutter/material.dart';
import '../../models/speech_message.dart';
import '../theme/app_theme.dart';

class MetricsCard extends StatelessWidget {
  final SpeechMessage? latestMessage;

  const MetricsCard({super.key, this.latestMessage});

  @override
  Widget build(BuildContext context) {
    final msg = latestMessage;

    final packetBytes = msg?.compressedPacketBytes ?? 68;
    final sttLatency = msg?.sttLatencyMs ?? 210;
    final txLatency = msg?.transmissionLatencyMs ?? 14;
    final ttsLatency = msg?.ttsLatencyMs ?? 125;
    final compression = msg?.compressionRatio ?? 98.5;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.speed, size: 16, color: AppTheme.activeGreen),
                    SizedBox(width: 6),
                    Text(
                      "TRANSCEIVER TELEMETRY",
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.activeGreen.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    "${compression.toStringAsFixed(1)}% BANDWIDTH SAVED",
                    style: const TextStyle(
                      color: AppTheme.activeGreen,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMetricTile("Packet Size", "$packetBytes B", Icons.data_usage, AppTheme.primaryColor),
                _buildMetricTile("STT Latency", "${sttLatency}ms", Icons.graphic_eq, Colors.amber),
                _buildMetricTile("P2P Tx", "${txLatency}ms", Icons.wifi_tethering, AppTheme.activeGreen),
                _buildMetricTile("TTS Latency", "${ttsLatency}ms", Icons.volume_up, Colors.cyan),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile(String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 9,
          ),
        ),
      ],
    );
  }
}
