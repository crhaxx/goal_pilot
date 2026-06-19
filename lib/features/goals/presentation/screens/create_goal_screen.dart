import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goal_pilot/core/di/core_providers.dart';
import 'package:goal_pilot/core/l10n/l10n.dart';
import 'package:goal_pilot/core/router/app_router.dart';
import 'package:goal_pilot/core/theme/app_colors.dart';
import 'package:goal_pilot/core/utils/failure_message.dart';
import 'package:goal_pilot/features/goals/domain/entities/goal_priority.dart';
import 'package:goal_pilot/features/goals/domain/entities/goal_schedule.dart';
import 'package:goal_pilot/features/goals/domain/entities/goal_template_id.dart';
import 'package:goal_pilot/features/goals/domain/templates/goal_template_catalog.dart';
import 'package:goal_pilot/features/goals/domain/utils/goal_schedule_utils.dart';
import 'package:goal_pilot/features/goals/presentation/providers/goal_providers.dart';
import 'package:goal_pilot/features/goals/presentation/widgets/goal_priority_badge.dart';
import 'package:goal_pilot/features/goals/presentation/widgets/goal_schedule_picker.dart';
import 'package:goal_pilot/features/goals/presentation/widgets/goal_template_picker.dart';
import 'package:goal_pilot/features/settings/presentation/providers/settings_providers.dart';

class CreateGoalScreen extends ConsumerStatefulWidget {
  const CreateGoalScreen({super.key});

  @override
  ConsumerState<CreateGoalScreen> createState() => _CreateGoalScreenState();
}

class _CreateGoalScreenState extends ConsumerState<CreateGoalScreen> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  GoalPriority _priority = GoalPriority.medium;
  GoalSchedule _schedule = GoalSchedule.everyDay;
  GoalTemplateId? _selectedTemplate;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _selectTemplate(GoalTemplateId templateId) {
    final localeCode = ref.read(appSettingsProvider).localeCode ?? 'en';
    final template = GoalTemplateCatalog.get(templateId, localeCode);
    setState(() {
      _selectedTemplate = templateId;
      _controller.text = template.aiPrompt;
    });
  }

  Future<void> _submitWithAi() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();

    try {
      final goal = await ref
          .read(createGoalControllerProvider.notifier)
          .submit(
            _controller.text,
            priority: _priority,
            schedule: _schedule,
            schedulePromptLine: GoalScheduleUtils.decompositionPromptLine(
              _schedule,
              context.l10n,
            ),
          );

      if (!mounted || goal == null) return;
      context.pushReplacement(AppRoutes.goalDetail(goal.id));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(failureMessage(e, context.l10n)),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _submitFromTemplate() async {
    final templateId = _selectedTemplate;
    if (templateId == null) return;

    FocusScope.of(context).unfocus();

    try {
      final goal = await ref
          .read(createGoalControllerProvider.notifier)
          .submitFromTemplate(
            templateId,
            priority: _priority,
            schedule: _schedule,
          );

      if (!mounted || goal == null) return;
      context.pushReplacement(AppRoutes.goalDetail(goal.id));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(failureMessage(e, context.l10n)),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final createState = ref.watch(createGoalControllerProvider);
    final isLoading = createState.isLoading;
    final hasApiKey = ref.watch(geminiApiKeyConfiguredProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.createGoalTitle),
      ),
      body: AbsorbPointer(
        absorbing: isLoading,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.createGoalHeadline,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.createGoalDesc,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.slate500,
                  ),
                ),
                const SizedBox(height: 24),
                GoalTemplatePicker(
                  selectedTemplate: _selectedTemplate,
                  enabled: !isLoading,
                  onTemplateSelected: _selectTemplate,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _controller,
                  maxLines: 4,
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: (_) {
                    if (_selectedTemplate != null) {
                      setState(() => _selectedTemplate = null);
                    }
                  },
                  decoration: InputDecoration(
                    hintText: l10n.createGoalHint,
                    alignLabelWithHint: true,
                  ),
                  validator: (value) {
                    if (_selectedTemplate != null) return null;
                    if (value == null || value.trim().length < 5) {
                      return l10n.createGoalValidation;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                GoalPriorityCard(
                  priority: _priority,
                  embedded: true,
                  enabled: !isLoading,
                  onPriorityChanged: (value) =>
                      setState(() => _priority = value),
                ),
                const SizedBox(height: 24),
                GoalScheduleCard(
                  schedule: _schedule,
                  enabled: !isLoading,
                  onScheduleChanged: (value) =>
                      setState(() => _schedule = value),
                ),
                const SizedBox(height: 24),
                if (isLoading) ...[
                  const LinearProgressIndicator(),
                  const SizedBox(height: 12),
                  Text(
                    l10n.createGoalPlanning,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.slate500,
                    ),
                  ),
                ] else ...[
                  if (_selectedTemplate != null)
                    OutlinedButton.icon(
                      onPressed: _submitFromTemplate,
                      icon: const Icon(Icons.checklist_rounded),
                      label: Text(l10n.useTemplatePlan),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  if (_selectedTemplate != null) const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: hasApiKey ? _submitWithAi : null,
                    icon: const Icon(Icons.auto_awesome),
                    label: Text(l10n.generatePlan),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: AppColors.cyan,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  if (!hasApiKey) ...[
                    const SizedBox(height: 12),
                    Text(
                      l10n.createGoalAiRequiresKey,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.slate500,
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
