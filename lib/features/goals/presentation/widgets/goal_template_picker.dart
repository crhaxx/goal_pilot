import 'package:flutter/material.dart';
import 'package:goal_pilot/core/l10n/l10n.dart';
import 'package:goal_pilot/core/theme/app_colors.dart';
import 'package:goal_pilot/features/goals/domain/entities/goal_template_id.dart';
import 'package:goal_pilot/features/goals/domain/templates/goal_template_catalog.dart';

class GoalTemplatePicker extends StatelessWidget {
  const GoalTemplatePicker({
    super.key,
    required this.selectedTemplate,
    required this.onTemplateSelected,
    this.enabled = true,
  });

  final GoalTemplateId? selectedTemplate;
  final ValueChanged<GoalTemplateId> onTemplateSelected;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.goalTemplatesTitle,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.goalTemplatesDesc,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.slate500,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: GoalTemplateCatalog.all.map((templateId) {
            final isSelected = selectedTemplate == templateId;
            return FilterChip(
              selected: isSelected,
              onSelected: enabled ? (_) => onTemplateSelected(templateId) : null,
              avatar: Icon(
                _iconFor(templateId),
                size: 18,
                color: isSelected ? AppColors.cyan : AppColors.slate500,
              ),
              label: Text(_labelFor(templateId, l10n)),
            );
          }).toList(),
        ),
      ],
    );
  }

  static IconData _iconFor(GoalTemplateId id) {
    return switch (id) {
      GoalTemplateId.learnLanguage => Icons.translate_rounded,
      GoalTemplateId.loseWeight => Icons.monitor_weight_outlined,
      GoalTemplateId.finishProject => Icons.rocket_launch_outlined,
    };
  }

  static String _labelFor(GoalTemplateId id, AppLocalizations l10n) {
    return switch (id) {
      GoalTemplateId.learnLanguage => l10n.goalTemplateLearnLanguage,
      GoalTemplateId.loseWeight => l10n.goalTemplateLoseWeight,
      GoalTemplateId.finishProject => l10n.goalTemplateFinishProject,
    };
  }
}
