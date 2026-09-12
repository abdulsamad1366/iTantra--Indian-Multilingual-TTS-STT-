import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class PttButton extends StatefulWidget {
  final bool isRecording;
  final bool isProcessing;
  final VoidCallback onPressStart;
  final VoidCallback onPressEnd;

  const PttButton({
    super.key,
    required this.isRecording,
    required this.isProcessing,
    required this.onPressStart,
    required this.onPressEnd,
  });

  @override
  State<PttButton> createState() => _PttButtonState();
}

class _PttButtonState extends State<PttButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isRecording = widget.isRecording;

    return GestureDetector(
      onTapDown: (_) {
        HapticFeedback.heavyImpact();
        widget.onPressStart();
      },
      onTapUp: (_) {
        HapticFeedback.lightImpact();
        widget.onPressEnd();
      },
      onTapCancel: () {
        widget.onPressEnd();
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final pulse = isRecording ? _controller.value * 12.0 : 0.0;
          return Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: isRecording
                      ? AppTheme.recordingRed.withOpacity(0.5)
                      : AppTheme.primaryColor.withOpacity(0.3),
                  blurRadius: 20 + pulse,
                  spreadRadius: 4 + pulse / 2,
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 70,
              backgroundColor: isRecording ? AppTheme.recordingRed : AppTheme.primaryColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isRecording ? Icons.mic : Icons.mic_none,
                    size: 48,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    isRecording ? "TRANSMITTING" : "PUSH TO TALK",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
