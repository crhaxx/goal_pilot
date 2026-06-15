import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goal_pilot/core/di/core_providers.dart';
import 'package:goal_pilot/core/l10n/l10n.dart';
import 'package:goal_pilot/core/presentation/widgets/app_logo.dart';
import 'package:goal_pilot/core/router/app_router.dart';
import 'package:goal_pilot/core/theme/app_colors.dart';
import 'package:goal_pilot/features/settings/presentation/providers/api_key_providers.dart';
import 'package:goal_pilot/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

const _googleAiStudioUrl = 'https://aistudio.google.com/apikey';

/// Onboarding gate and settings screen for BYOK Gemini API key setup.
class ApiKeySetupScreen extends ConsumerStatefulWidget {
  const ApiKeySetupScreen({
    super.key,
    this.isOnboarding = false,
  });

  /// When true, user must save a key before continuing to the app.
  final bool isOnboarding;

  @override
  ConsumerState<ApiKeySetupScreen> createState() => _ApiKeySetupScreenState();
}

class _ApiKeySetupScreenState extends ConsumerState<ApiKeySetupScreen> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscureKey = true;
  bool _hasExistingKey = false;
  bool _loadingStatus = true;

  @override
  void initState() {
    super.initState();
    _loadExistingKeyStatus();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadExistingKeyStatus() async {
    final hasKey =
        await ref.read(geminiApiKeyRepositoryProvider).hasApiKey();
    if (!mounted) return;
    setState(() {
      _hasExistingKey = hasKey;
      _loadingStatus = false;
    });
  }

  Future<void> _openGoogleAiStudio() async {
    final uri = Uri.parse(_googleAiStudioUrl);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.apiKeySetupOpenStudioFailed)),
      );
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.success,
      ),
    );
  }

  Future<void> _validateAndSave() async {
    if (!_formKey.currentState!.validate()) return;

    final l10n = context.l10n;
    try {
      await ref
          .read(apiKeySetupControllerProvider.notifier)
          .validateAndSave(_controller.text.trim());
      if (!mounted) return;

      ref.invalidate(hasSavedGeminiApiKeyProvider);
      ref.read(geminiApiKeyConfiguredProvider.notifier).state = true;
      setState(() => _hasExistingKey = true);
      _controller.clear();
      _showMessage(l10n.apiKeySetupSuccess);

      if (widget.isOnboarding) {
        context.go(AppRoutes.home);
      }
    } catch (e) {
      if (!mounted) return;
      _showMessage(apiKeySetupErrorMessage(e), isError: true);
    }
  }

  Future<void> _clearKey() async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.apiKeySetupClearConfirmTitle),
        content: Text(l10n.apiKeySetupClearConfirmDesc),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.back),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: Text(l10n.apiKeySetupClear),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    try {
      await ref.read(apiKeySetupControllerProvider.notifier).clearKey();
      if (!mounted) return;

      ref.invalidate(hasSavedGeminiApiKeyProvider);
      ref.read(geminiApiKeyConfiguredProvider.notifier).state = false;
      setState(() {
        _hasExistingKey = false;
        _controller.clear();
      });
      _showMessage(l10n.apiKeySetupCleared);
    } catch (e) {
      if (!mounted) return;
      _showMessage(apiKeySetupErrorMessage(e), isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final isSaving = ref.watch(apiKeySetupControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.apiKeySetupTitle),
        automaticallyImplyLeading: !widget.isOnboarding,
      ),
      body: SafeArea(
        child: _loadingStatus
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                children: [
                  if (widget.isOnboarding) ...[
                    const Center(child: AppLogo(size: 72, borderRadius: 18)),
                    const SizedBox(height: 20),
                  ],
                  Text(
                    l10n.apiKeySetupSubtitle,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: AppColors.slate500,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _StatusBanner(configured: _hasExistingKey, l10n: l10n),
                  const SizedBox(height: 24),
                  Text(
                    l10n.apiKeySetupHowToTitle,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _StepCard(
                    step: 1,
                    title: l10n.apiKeySetupStep1Title,
                    description: l10n.apiKeySetupStep1Desc,
                    actionLabel: l10n.apiKeySetupOpenStudio,
                    onAction: _openGoogleAiStudio,
                  ),
                  const SizedBox(height: 8),
                  _StepCard(
                    step: 2,
                    title: l10n.apiKeySetupStep2Title,
                    description: l10n.apiKeySetupStep2Desc,
                  ),
                  const SizedBox(height: 8),
                  _StepCard(
                    step: 3,
                    title: l10n.apiKeySetupStep3Title,
                    description: l10n.apiKeySetupStep3Desc,
                  ),
                  const SizedBox(height: 8),
                  _StepCard(
                    step: 4,
                    title: l10n.apiKeySetupStep4Title,
                    description: l10n.apiKeySetupStep4Desc,
                  ),
                  const SizedBox(height: 24),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              l10n.apiKeySetupFieldLabel,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _controller,
                              obscureText: _obscureKey,
                              autocorrect: false,
                              enableSuggestions: false,
                              decoration: InputDecoration(
                                hintText: l10n.apiKeySetupFieldHint,
                                prefixIcon: const Icon(Icons.key_outlined),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureKey
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                  ),
                                  onPressed: () => setState(
                                    () => _obscureKey = !_obscureKey,
                                  ),
                                ),
                                border: const OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return l10n.apiKeySetupFieldRequired;
                                }
                                if (value.trim().length < 20) {
                                  return l10n.apiKeySetupFieldTooShort;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.apiKeySetupPrivacyNote,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.slate500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: isSaving ? null : _validateAndSave,
                    icon: isSaving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.verified_outlined),
                    label: Text(l10n.apiKeySetupValidateSave),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.cyan,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                  if (_hasExistingKey) ...[
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: isSaving ? null : _clearKey,
                      icon: const Icon(Icons.delete_outline),
                      label: Text(l10n.apiKeySetupClear),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ],
                  if (widget.isOnboarding && _hasExistingKey) ...[
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => context.go(AppRoutes.home),
                      child: Text(l10n.apiKeySetupContinue),
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({required this.configured, required this.l10n});

  final bool configured;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = configured ? AppColors.success : AppColors.warning;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Icon(
            configured ? Icons.check_circle_outline : Icons.info_outline,
            color: color,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              configured
                  ? l10n.apiKeySetupStatusConfigured
                  : l10n.apiKeySetupStatusMissing,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({
    required this.step,
    required this.title,
    required this.description,
    this.actionLabel,
    this.onAction,
  });

  final int step;
  final String title;
  final String description;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: AppColors.cyan,
              foregroundColor: Colors.white,
              child: Text(
                '$step',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.slate500,
                      height: 1.45,
                    ),
                  ),
                  if (actionLabel != null && onAction != null) ...[
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: onAction,
                        icon: const Icon(Icons.open_in_new, size: 18),
                        label: Text(actionLabel!),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
