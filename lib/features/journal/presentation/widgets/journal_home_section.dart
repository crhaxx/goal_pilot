import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goal_pilot/core/l10n/l10n.dart';
import 'package:goal_pilot/core/router/app_router.dart';
import 'package:goal_pilot/core/theme/app_colors.dart';
import 'package:goal_pilot/features/journal/presentation/providers/journal_providers.dart';
import 'package:goal_pilot/features/settings/presentation/providers/settings_providers.dart';
import 'package:intl/intl.dart';

class JournalHomeSection extends ConsumerWidget {
  const JournalHomeSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final journalDate = ref.watch(currentJournalDateProvider);
    final entry = ref.watch(currentJournalEntryProvider);
    final unlockAt = ref.watch(journalDayUnlockProvider);
    final settings = ref.watch(appSettingsProvider);
    final dateFormat = DateFormat.MMMd();

    final preview = entry?.content.trim() ?? '';
    final hasContent = preview.isNotEmpty;

    return Card(
      child: InkWell(
        onTap: () => context.go(AppRoutes.journal),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.deepBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.menu_book_outlined,
                      color: AppColors.deepBlue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.journalTitle,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          l10n.journalCurrentDay(dateFormat.format(journalDate)),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.slate500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
              const SizedBox(height: 12),
              if (unlockAt != null)
                Text(
                  l10n.journalDayUnlocksAt(
                    MaterialLocalizations.of(context).formatTimeOfDay(
                      TimeOfDay(
                        hour: settings.journalDayStartHour,
                        minute: settings.journalDayStartMinute,
                      ),
                    ),
                  ),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.slate500,
                  ),
                )
              else if (hasContent)
                Text(
                  preview.length > 160 ? '${preview.substring(0, 160)}…' : preview,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
                )
              else
                Text(
                  l10n.journalEmptyPrompt,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.slate500,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
