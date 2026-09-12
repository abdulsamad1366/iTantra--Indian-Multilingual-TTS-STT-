import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/transceiver_controller.dart';
import '../../models/language.dart';
import '../../services/model_manager_service.dart';
import '../theme/app_theme.dart';

class ModelManagementScreen extends StatelessWidget {
  const ModelManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TransceiverController>();
    final modelManager = controller.modelManager;

    final sttModels = modelManager.getAllSttModels();
    final ttsModels = modelManager.getAllTtsModels();
    final vadModel = modelManager.vadModel;

    final currentRamFootprint = modelManager.getTotalActiveRamFootprintMb(
      controller.sourceLanguage,
      controller.targetLanguage,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Open Source Models & Licenses"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // RAM Footprint Summary Card
          Card(
            color: AppTheme.surfaceColor,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.memory, color: AppTheme.activeGreen),
                      SizedBox(width: 8),
                      Text(
                        "ACTIVE MEMORY & RAM FOOTPRINT",
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildRamStat("Total RAM Usage", "${currentRamFootprint.toStringAsFixed(1)} MB"),
                      _buildRamStat("VAD Engine", "${vadModel.ramFootprintMb} MB"),
                      _buildRamStat("Active STT", "${modelManager.getSttModelInfo(controller.sourceLanguage).ramFootprintMb} MB"),
                      _buildRamStat("Active TTS", "${modelManager.getTtsModelInfo(controller.targetLanguage).ramFootprintMb} MB"),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Fully compatible with low and mid-range Android smartphones (< 300 MB total RAM threshold).",
                    style: TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // VAD Model Section
          const Text(
            "VOICE ACTIVITY DETECTION (VAD)",
            style: TextStyle(color: AppTheme.activeGreen, fontSize: 12, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          _buildModelTile(vadModel),

          const SizedBox(height: 16),

          // STT Models Section
          const Text(
            "SPEECH-TO-TEXT (STT) MODELS (10 LANGUAGES)",
            style: TextStyle(color: AppTheme.activeGreen, fontSize: 12, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          ...sttModels.map((model) => _buildModelTile(model)).toList(),

          const SizedBox(height: 16),

          // TTS Models Section
          const Text(
            "TEXT-TO-SPEECH (TTS) VITS MODELS",
            style: TextStyle(color: AppTheme.activeGreen, fontSize: 12, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          ...ttsModels.map((model) => _buildModelTile(model)).toList(),
        ],
      ),
    );
  }

  Widget _buildRamStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: const TextStyle(color: AppTheme.primaryColor, fontSize: 14, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 9)),
      ],
    );
  }

  Widget _buildModelTile(ModelInfo model) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(
          model.name,
          style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            Text("Repo: ${model.repository}", style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
            Text("License: ${model.license} • Languages: ${model.languages}", style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text("${model.sizeMb} MB", style: const TextStyle(color: AppTheme.activeGreen, fontWeight: FontWeight.bold, fontSize: 12)),
            const Text("Offline ONNX", style: TextStyle(color: AppTheme.textSecondary, fontSize: 9)),
          ],
        ),
      ),
    );
  }
}
