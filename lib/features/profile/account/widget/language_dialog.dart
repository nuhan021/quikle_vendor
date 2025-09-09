import 'package:flutter/material.dart';
import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/custom_button.dart';

class LanguageDialog extends StatelessWidget {
  final String selectedLanguage;
  final List<String> languages;
  final ValueChanged<String> onLanguageChanged;

  const LanguageDialog({
    super.key,
    required this.selectedLanguage,
    required this.languages,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Language Settings",
              style: getTextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            /// Dropdown Label
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Choose Language",
                style: getTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 6),

            /// Dropdown
            DropdownButtonFormField<String>(
              dropdownColor: Colors.white,
              initialValue: selectedLanguage,
              style: getTextStyle(fontSize: 14, color: Colors.black87),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
              ),
              items: languages
                  .map(
                    (lang) => DropdownMenuItem(
                      value: lang,
                      child: Text(
                        lang,
                        style: getTextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  onLanguageChanged(value);
                }
              },
            ),

            const SizedBox(height: 20),

            /// Save Button (CustomButton)
            CustomButton(
              text: "Save Language",
              onPressed: () {
                Navigator.pop(context, selectedLanguage);
              },
              backgroundColor: Colors.black,
              textColor: Colors.white,
              height: 45,
              borderRadius: 8,
            ),
          ],
        ),
      ),
    );
  }
}
