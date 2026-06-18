import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_pilot/core/l10n/l10n.dart';
import 'package:goal_pilot/core/theme/app_colors.dart';
import 'package:goal_pilot/core/utils/date_utils.dart' as gp_date;
import 'package:goal_pilot/core/utils/failure_message.dart';
import 'package:goal_pilot/features/personal_tasks/domain/entities/personal_task.dart';
import 'package:goal_pilot/features/personal_tasks/presentation/providers/personal_task_providers.dart';
import 'package:intl/intl.dart';

Future<void> showPersonalTaskSheet({
  required BuildContext context,
  required WidgetRef ref,
  PersonalTask? existing,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => PersonalTaskSheet(existing: existing),
  );
}

class PersonalTaskSheet extends ConsumerStatefulWidget {
  const PersonalTaskSheet({super.key, this.existing});

  final PersonalTask? existing;

  @override
  ConsumerState<PersonalTaskSheet> createState() => _PersonalTaskSheetState();
}

class _PersonalTaskSheetState extends ConsumerState<PersonalTaskSheet> {
  final _titleController = TextEditingController();
  late DateTime _dueDate;
  DateTime? _reminderAt;
  bool _reminderEnabled = false;
  bool _isSubmitting = false;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    if (existing != null) {
      _titleController.text = existing.title;
      _dueDate = existing.dueDate;
      _reminderAt = existing.reminderAt;
      _reminderEnabled = existing.reminderAt != null;
    } else {
      _dueDate = gp_date.DateUtils.dateOnly(DateTime.now());
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked != null) {
      setState(() => _dueDate = gp_date.DateUtils.dateOnly(picked));
    }
  }

  Future<void> _pickReminder() async {
    final initial = _reminderAt ??
        DateTime(
          _dueDate.year,
          _dueDate.month,
          _dueDate.day,
          DateTime.now().hour,
          DateTime.now().minute,
        );

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (pickedDate == null || !mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (pickedTime == null) return;

    setState(() {
      _reminderAt = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      _reminderEnabled = true;
    });
  }

  Future<void> _submit() async {
    final l10n = context.l10n;
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    setState(() => _isSubmitting = true);
    try {
      final repository = await ref.read(personalTaskRepositoryProvider.future);
      final reminder = _reminderEnabled ? _reminderAt : null;

      if (_isEditing) {
        await repository.updateTask(
          id: widget.existing!.id,
          title: title,
          dueDate: _dueDate,
          reminderAt: reminder,
          clearReminder: !_reminderEnabled,
        );
      } else {
        await repository.addTask(
          title: title,
          dueDate: _dueDate,
          reminderAt: reminder,
        );
      }

      if (mounted) Navigator.of(context).pop();
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failureMessage(error, l10n))),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  String _formatDate(DateTime date) {
    final locale = Localizations.localeOf(context).toString();
    return DateFormat.yMMMd(locale).format(date);
  }

  String? _formatReminder() {
    if (_reminderAt == null) return null;
    final locale = Localizations.localeOf(context).toString();
    return DateFormat.yMMMd(locale).add_Hm().format(_reminderAt!);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(24, 16, 24, 24 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.slate500.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _isEditing ? l10n.personalTaskEditTitle : l10n.personalTaskAddTitle,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.personalTaskAddDesc,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.slate500,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _titleController,
            enabled: !_isSubmitting,
            autofocus: !_isEditing,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: l10n.personalTaskHint,
              border: const OutlineInputBorder(),
            ),
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 16),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.personalTaskDueDate),
            subtitle: Text(_formatDate(_dueDate)),
            trailing: const Icon(Icons.calendar_today_outlined),
            onTap: _isSubmitting ? null : _pickDueDate,
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.personalTaskReminder),
            subtitle: _reminderEnabled && _formatReminder() != null
                ? Text(_formatReminder()!)
                : Text(l10n.personalTaskReminderDesc),
            value: _reminderEnabled,
            activeThumbColor: AppColors.cyan,
            onChanged: _isSubmitting
                ? null
                : (value) {
                    setState(() {
                      _reminderEnabled = value;
                      if (!value) _reminderAt = null;
                    });
                    if (value) _pickReminder();
                  },
          ),
          if (_reminderEnabled)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: _isSubmitting ? null : _pickReminder,
                icon: const Icon(Icons.schedule_outlined),
                label: Text(l10n.personalTaskChangeReminder),
              ),
            ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _isSubmitting ? null : _submit,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.cyan,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: _isSubmitting
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    _isEditing
                        ? l10n.personalTaskSave
                        : l10n.personalTaskAddButton,
                  ),
          ),
        ],
      ),
    );
  }
}
