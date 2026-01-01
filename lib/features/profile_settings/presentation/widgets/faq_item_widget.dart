import 'package:flutter/material.dart';
import 'package:ahioma_food_template/features/profile_settings/presentation/screens/help_center_screen.dart';

class FAQItemWidget extends StatelessWidget {
  const FAQItemWidget({
    required this.faq,
    required this.onTap,
    super.key,
  });

  final FAQItem faq;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      faq.question,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    faq.isExpanded
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_down,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
              if (faq.isExpanded && faq.answer.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  faq.answer,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
