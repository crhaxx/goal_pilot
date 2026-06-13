import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_pilot/core/l10n/l10n.dart';
import 'package:goal_pilot/core/theme/app_colors.dart';
import 'package:goal_pilot/core/utils/failure_message.dart';
import 'package:goal_pilot/features/coach/data/repositories/roleplay_repository_impl.dart';
import 'package:goal_pilot/features/coach/domain/entities/chat_message.dart';
import 'package:goal_pilot/features/coach/domain/entities/chat_role.dart';
import 'package:goal_pilot/features/goals/domain/entities/goal.dart';
import 'package:goal_pilot/features/goals/domain/entities/roleplay_evaluation.dart';
import 'package:goal_pilot/features/goals/presentation/providers/goal_providers.dart';

Future<void> showRoleplaySheet({
  required BuildContext context,
  required Goal goal,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => RoleplaySheet(goal: goal),
  );
}

class RoleplaySheet extends ConsumerStatefulWidget {
  const RoleplaySheet({super.key, required this.goal});

  final Goal goal;

  @override
  ConsumerState<RoleplaySheet> createState() => _RoleplaySheetState();
}

class _RoleplaySheetState extends ConsumerState<RoleplaySheet> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  List<ChatMessage> _messages = [];
  RoleplayEvaluation? _evaluation;
  static const _evaluationThreshold = 5;

  String get _sessionKey {
    final milestone = widget.goal.roleplayMilestone;
    return RoleplayRepositoryImpl.sessionKey(
      widget.goal.id,
      milestone?.id ?? widget.goal.id,
    );
  }

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final history = await ref.read(roleplayHistoryProvider(_sessionKey).future);
    if (mounted) {
      setState(() => _messages = history);
      _scrollToBottom();
      _maybeEvaluate();
    }
  }

  int get _userMessageCount =>
      _messages.where((m) => m.role.isUser).length;

  Future<void> _maybeEvaluate() async {
    if (_evaluation != null || _userMessageCount < _evaluationThreshold) return;

    try {
      final evaluation = await ref.read(roleplayControllerProvider.notifier).evaluate(
            goal: widget.goal,
            history: _messages,
          );
      if (mounted && evaluation != null) {
        setState(() => _evaluation = evaluation);
      }
    } catch (_) {
      // Evaluation is optional delight — don't block chat.
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _evaluation != null) return;

    _controller.clear();
    FocusScope.of(context).unfocus();

    final optimisticUser = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      role: ChatRole.user,
      content: text,
      timestamp: DateTime.now(),
      goalId: widget.goal.id,
    );

    setState(() => _messages = [..._messages, optimisticUser]);
    _scrollToBottom();

    try {
      await ref.read(roleplayControllerProvider.notifier).send(
            message: text,
            goal: widget.goal,
            history: _messages.where((m) => m.id != optimisticUser.id).toList(),
          );

      if (!mounted) return;
      ref.invalidate(roleplayHistoryProvider(_sessionKey));
      await _loadHistory();
      await _maybeEvaluate();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _messages = _messages.where((m) => m.id != optimisticUser.id).toList();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(failureMessage(e, context.l10n)),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final scenario = widget.goal.roleplayMilestone?.roleplayScenario;
    final isLoading = ref.watch(roleplayControllerProvider).isLoading;

    if (scenario == null) {
      return SizedBox(
        height: 200,
        child: Center(child: Text(l10n.roleplayUnavailable)),
      );
    }

    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.85,
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.slate200,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.theater_comedy, color: AppColors.deepBlue),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.roleplaySimulator(scenario.characterRole),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  scenario.scenarioBrief,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.slate500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.roleplayMessagesToEval(
                    _userMessageCount,
                    _evaluationThreshold,
                  ),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.cyan,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          if (_evaluation != null)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cyan.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.roleplayScore(_evaluation!.score),
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(_evaluation!.summary),
                  if (_evaluation!.improvements.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      l10n.roleplayImprove,
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    ..._evaluation!.improvements.map((i) => Text('• $i')),
                  ],
                ],
              ),
            ),
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        '${scenario.opponentPersona}\n\n${l10n.roleplayEmpty}',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge,
                      ),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length + (isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (isLoading && index == _messages.length) {
                        return const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        );
                      }

                      final message = _messages[index];
                      final isUser = message.role.isUser;

                      return Align(
                        alignment:
                            isUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.sizeOf(context).width * 0.78,
                          ),
                          decoration: BoxDecoration(
                            color: isUser
                                ? AppColors.deepBlue
                                : AppColors.slate100,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            message.content,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: isUser ? Colors.white : AppColors.navy,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          const Divider(height: 1),
          Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 12,
              bottom: MediaQuery.viewInsetsOf(context).bottom + 12,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    enabled: !isLoading && _evaluation == null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _send(),
                    decoration: InputDecoration(
                      hintText: _evaluation == null
                          ? l10n.roleplayReplyHint
                          : l10n.roleplayComplete,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed:
                      isLoading || _evaluation != null ? null : _send,
                  icon: const Icon(Icons.send),
                  color: Colors.white,
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.deepBlue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
