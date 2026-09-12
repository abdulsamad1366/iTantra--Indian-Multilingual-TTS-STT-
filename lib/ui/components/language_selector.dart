import 'package:flutter/material.dart';
import '../../models/language.dart';
import '../theme/app_theme.dart';

class LanguageSelector extends StatelessWidget {
  final String label;
  final AppLanguage selectedLanguage;
  final ValueChanged<AppLanguage> onLanguageChanged;

  const LanguageSelector({
    super.key,
    required this.label,
    required this.selectedLanguage,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<AppLanguage>(
              value: selectedLanguage,
              isExpanded: true,
              dropdownColor: AppTheme.surfaceColor,
              icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.primaryColor),
              items: AppLanguage.values.map((lang) {
                return DropdownMenuItem<AppLanguage>(
                  value: lang,
                  child: Row(
                    children: [
                      Text(
                        lang.displayName,
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "(${lang.nativeName})",
                        style: const TextStyle(
                          color: AppTheme.activeGreen,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (lang) {
                if (lang != null) onLanguageChanged(lang);
              },
            ),
          ),
        ],
      ),
    );
  }
}
