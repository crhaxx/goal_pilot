import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_pilot/core/l10n/l10n.dart';
import 'package:goal_pilot/core/theme/app_colors.dart';
import 'package:goal_pilot/core/utils/failure_message.dart';
import 'package:goal_pilot/features/journal/domain/entities/journal_entry.dart';
import 'package:goal_pilot/features/journal/presentation/providers/journal_providers.dart';
import 'package:goal_pilot/features/settings/presentation/providers/settings_providers.dart';
import 'package:intl/intl.dart';

class JournalScreen extends ConsumerWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final entriesAsync = ref.watch(journalEntriesStreamProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.journalTitle),
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.journalTabToday),
              Tab(text: l10n.journalTabHistory),
            ],
          ),
        ),
        body: entriesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) =>
              Center(child: Text(failureMessage(error, l10n))),
          data: (entries) => TabBarView(
            children: [
              _JournalTodayTab(entries: entries),
              _JournalHistoryTab(entries: entries),
            ],
          ),
        ),
      ),
    );
  }
}

class _JournalTodayTab extends ConsumerStatefulWidget {
  const _JournalTodayTab({required this.entries});

  final List<JournalEntry> entries;

  @override
  ConsumerState<_JournalTodayTab> createState() => _JournalTodayTabState();
}

class _JournalTodayTabState extends ConsumerState<_JournalTodayTab> {
  final _controller = TextEditingController();
  DateTime? _editingDate;
  bool _dirty = false;
  bool _saving = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  JournalEntry? _entryForDate(DateTime date) {
    for (final entry in widget.entries) {
      if (entry.date.year == date.year &&
          entry.date.month == date.month &&
          entry.date.day == date.day) {
        return entry;
      }
    }
    return null;
  }

  void _loadEntry(JournalEntry? entry, DateTime journalDate) {
    if (_dirty && _editingDate == journalDate) return;
    _editingDate = journalDate;
    _controller.text = entry?.content ?? '';
    _dirty = false;
  }

  Future<void> _save(DateTime journalDate) async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      await saveJournalEntry(
        ref,
        date: journalDate,
        content: _controller.text,
      );
      if (mounted) {
        setState(() {
          _dirty = false;
          _saving = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.journalSaved)),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
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
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final settings = ref.watch(appSettingsProvider);
    final journalDate = ref.watch(currentJournalDateProvider);
    final unlockAt = ref.watch(journalDayUnlockProvider);
    final dateFormat = DateFormat.yMMMMd();
    final currentEntry = _entryForDate(journalDate);
    _loadEntry(currentEntry, journalDate);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      children: [
        if (unlockAt != null) ...[
          Card(
            color: AppColors.cyan.withValues(alpha: 0.08),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.schedule, color: theme.colorScheme.secondary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.journalDayUnlocksAt(
                        MaterialLocalizations.of(context).formatTimeOfDay(
                          TimeOfDay(
                            hour: settings.journalDayStartHour,
                            minute: settings.journalDayStartMinute,
                          ),
                        ),
                      ),
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
        Text(
          l10n.journalCurrentDay(dateFormat.format(journalDate)),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.journalCurrentDayHint,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.slate500,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _controller,
          maxLines: 8,
          minLines: 5,
          onChanged: (_) => setState(() => _dirty = true),
          decoration: InputDecoration(
            hintText: l10n.journalEntryHint,
            alignLabelWithHint: true,
          ),
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: _saving ? null : () => _save(journalDate),
          icon: _saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.save_outlined),
          label: Text(_saving ? l10n.saving : l10n.journalSave),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.cyan,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ],
    );
  }
}

class _JournalHistoryTab extends ConsumerWidget {
  const _JournalHistoryTab({required this.entries});

  final List<JournalEntry> entries;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final journalDate = ref.watch(currentJournalDateProvider);

    final pastEntries = entries
        .where((e) => e.date.isBefore(journalDate) && !e.isEmpty)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    if (pastEntries.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.history,
                size: 48,
                color: AppColors.slate500.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.journalNoPastEntries,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.slate500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: pastEntries.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final entry = pastEntries[index];
        return _PastEntryCard(
          entry: entry,
          onTap: () => _showEntrySheet(context, ref, entry),
        );
      },
    );
  }

  Future<void> _showEntrySheet(
    BuildContext context,
    WidgetRef ref,
    JournalEntry entry,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _JournalEntrySheet(entry: entry),
    );
  }
}

class _PastEntryCard extends StatelessWidget {
  const _PastEntryCard({
    required this.entry,
    required this.onTap,
  });

  final JournalEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final dateFormat = DateFormat.yMMMMd();
    final preview = entry.content.trim();
    final lines = preview.split('\n');
    final shortPreview = lines.length > 3
        ? '${lines.take(3).join('\n')}…'
        : preview;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dateFormat.format(entry.date),
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      preview.isEmpty ? l10n.journalEntryEmpty : shortPreview,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: preview.isEmpty ? AppColors.slate500 : null,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right, color: AppColors.slate500),
            ],
          ),
        ),
      ),
    );
  }
}

class _JournalEntrySheet extends ConsumerStatefulWidget {
  const _JournalEntrySheet({required this.entry});

  final JournalEntry entry;

  @override
  ConsumerState<_JournalEntrySheet> createState() => _JournalEntrySheetState();
}

class _JournalEntrySheetState extends ConsumerState<_JournalEntrySheet> {
  late final TextEditingController _controller;
  bool _dirty = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.entry.content);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      await saveJournalEntry(
        ref,
        date: widget.entry.date,
        content: _controller.text,
      );
      if (!mounted) return;
      setState(() {
        _dirty = false;
        _saving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.journalSaved)),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
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
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final dateFormat = DateFormat.yMMMMd();

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 24,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.slate200,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              dateFormat.format(widget.entry.date),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: TextField(
                  controller: _controller,
                  maxLines: null,
                  minLines: 8,
                  onChanged: (_) {
                    if (!_dirty) setState(() => _dirty = true);
                  },
                  decoration: InputDecoration(
                    hintText: l10n.journalEntryHint,
                    alignLabelWithHint: true,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _saving || !_dirty ? null : _save,
              icon: _saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save_outlined),
              label: Text(_saving ? l10n.saving : l10n.journalSave),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.cyan,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
