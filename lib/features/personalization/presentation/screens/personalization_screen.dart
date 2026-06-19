import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goal_pilot/core/l10n/l10n.dart';
import 'package:goal_pilot/core/router/app_router.dart';
import 'package:goal_pilot/core/theme/app_colors.dart';
import 'package:goal_pilot/features/personalization/domain/entities/challenge_area.dart';
import 'package:goal_pilot/features/personalization/domain/entities/coaching_focus_style.dart';
import 'package:goal_pilot/features/personalization/domain/entities/daily_schedule_rhythm.dart';
import 'package:goal_pilot/features/personalization/domain/entities/milestone_granularity.dart';
import 'package:goal_pilot/features/personalization/domain/entities/motivation_driver.dart';
import 'package:goal_pilot/features/personalization/domain/entities/occupation_status.dart';
import 'package:goal_pilot/features/personalization/domain/entities/user_personalization.dart';
import 'package:goal_pilot/features/personalization/domain/utils/profile_completion.dart';
import 'package:goal_pilot/features/personalization/presentation/providers/personalization_providers.dart';
import 'package:goal_pilot/features/personalization/presentation/utils/profile_preview_builder.dart';
import 'package:goal_pilot/features/personalization/presentation/widgets/profile_hero_header.dart';
import 'package:goal_pilot/features/personalization/presentation/widgets/profile_option_tile.dart';
import 'package:goal_pilot/features/personalization/presentation/widgets/profile_preview_card.dart';
import 'package:goal_pilot/features/personalization/presentation/widgets/profile_section_header.dart';
import 'package:goal_pilot/l10n/app_localizations.dart';

class PersonalizationScreen extends ConsumerStatefulWidget {
  const PersonalizationScreen({super.key});

  @override
  ConsumerState<PersonalizationScreen> createState() =>
      _PersonalizationScreenState();
}

class _PersonalizationScreenState extends ConsumerState<PersonalizationScreen> {
  final _displayNameController = TextEditingController();
  final _bioController = TextEditingController();

  bool _enabled = false;
  DailyScheduleRhythm? _scheduleRhythm;
  CoachingFocusStyle? _coachingStyle;
  OccupationStatus? _occupationStatus;
  MilestoneGranularity? _milestoneGranularity;
  MotivationDriver? _motivationDriver;
  Set<ChallengeArea> _challengeAreas = {};
  bool _dirty = false;
  bool _saving = false;

  @override
  void dispose() {
    _displayNameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _syncFromPersonalization(UserPersonalization personalization) {
    _enabled = personalization.enabled;
    _displayNameController.text = personalization.displayName ?? '';
    _scheduleRhythm = personalization.scheduleRhythm;
    _coachingStyle = personalization.coachingStyle;
    _occupationStatus = personalization.occupationStatus;
    _milestoneGranularity = personalization.milestoneGranularity;
    _motivationDriver = personalization.motivationDriver;
    _challengeAreas = Set.of(personalization.challengeAreas);
    _bioController.text = personalization.userBio ?? '';
    _dirty = false;
  }

  UserPersonalization _buildDraft() {
    final displayName = _displayNameController.text.trim();
    final bio = _bioController.text.trim();
    return UserPersonalization(
      enabled: _enabled,
      displayName: displayName.isEmpty ? null : displayName,
      scheduleRhythm: _scheduleRhythm,
      coachingStyle: _coachingStyle,
      occupationStatus: _occupationStatus,
      milestoneGranularity: _milestoneGranularity,
      motivationDriver: _motivationDriver,
      challengeAreas: _challengeAreas,
      userBio: bio.isEmpty ? null : bio,
    );
  }

  void _markDirty() {
    if (!_dirty) setState(() => _dirty = true);
  }

  Future<void> _save() async {
    if (_saving) return;

    setState(() => _saving = true);
    try {
      await ref
          .read(personalizationControllerProvider.notifier)
          .updatePersonalization(_buildDraft());
      if (!mounted) return;
      setState(() => _dirty = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.personalizationSaved),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.errorPrefix('$e')),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _confirmClear() async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.personalizationClear),
        content: Text(l10n.personalizationClearConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.personalizationClear),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      await ref.read(personalizationControllerProvider.notifier).clearAll();
      if (!mounted) return;
      _syncFromPersonalization(const UserPersonalization());
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.personalizationClearDone),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.errorPrefix('$e')),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _toggleChallenge(ChallengeArea area) {
    setState(() {
      if (_challengeAreas.contains(area)) {
        _challengeAreas = Set.of(_challengeAreas)..remove(area);
      } else {
        _challengeAreas = Set.of(_challengeAreas)..add(area);
      }
    });
    _markDirty();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final personalizationAsync = ref.watch(personalizationControllerProvider);

    return Scaffold(
      body: personalizationAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(l10n.errorPrefix('$error'))),
        data: (saved) {
          if (!_dirty && !_saving) {
            _syncFromPersonalization(saved);
          }

          final draft = _buildDraft();
          final fieldsEnabled = _enabled;
          final completion = ProfileCompletion.percent(draft);
          final bottomPadding = _dirty ? 160.0 : 100.0;

          return Stack(
            children: [
              CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    floating: true,
                    title: Text(l10n.personalizationTitle),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.settings_outlined),
                        tooltip: l10n.settingsTitle,
                        onPressed: () => context.push(AppRoutes.settings),
                      ),
                      if (_dirty)
                        TextButton(
                          onPressed: _saving ? null : _save,
                          child: _saving
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(l10n.personalizationSave),
                        ),
                    ],
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    sliver: SliverToBoxAdapter(
                      child: ProfileHeroHeaderWithController(
                        completionPercent: completion,
                        isActive: _enabled,
                        activeLabel: l10n.personalizationStatusActive,
                        inactiveLabel: l10n.personalizationStatusInactive,
                        completionLabel: l10n.personalizationCompletionLabel,
                        subtitle: l10n.personalizationHeroSubtitle,
                        controller: _displayNameController,
                        displayNameHint: l10n.personalizationDisplayNameHint,
                        onDisplayNameChanged: (_) => _markDirty(),
                        fieldsEnabled: fieldsEnabled,
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    sliver: SliverToBoxAdapter(
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                          side: BorderSide(
                            color: _enabled
                                ? AppColors.cyan.withValues(alpha: 0.35)
                                : Theme.of(context)
                                    .dividerColor
                                    .withValues(alpha: 0.4),
                          ),
                        ),
                        child: SwitchListTile(
                          title: Text(
                            l10n.personalizationEnabled,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          subtitle: Text(l10n.personalizationEnabledDesc),
                          value: _enabled,
                          activeThumbColor: AppColors.cyan,
                          onChanged: (value) {
                            setState(() => _enabled = value);
                            _markDirty();
                          },
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                    sliver: SliverToBoxAdapter(
                      child: ProfilePreviewCard(
                        title: l10n.personalizationPreviewTitle,
                        previewText: ProfilePreviewBuilder.build(l10n, draft),
                        isActive: _enabled && draft.hasContent,
                        activeHint: l10n.personalizationPreviewActiveHint,
                        inactiveHint: l10n.personalizationPreviewInactiveHint,
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 28, 16, 0),
                    sliver: SliverToBoxAdapter(
                      child: ProfileSectionHeader(
                        icon: Icons.wb_sunny_outlined,
                        title: l10n.personalizationLifestyleSection,
                        subtitle: l10n.personalizationLifestyleSectionDesc,
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    sliver: SliverToBoxAdapter(
                      child: Text(
                        l10n.personalizationScheduleRhythm,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.slate500,
                            ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    sliver: SliverList.separated(
                      itemCount: DailyScheduleRhythm.values.length + 1,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return ProfileOptionTile(
                            icon: Icons.remove_circle_outline,
                            label: l10n.personalizationNotSpecified,
                            selected: _scheduleRhythm == null,
                            enabled: fieldsEnabled,
                            onTap: () {
                              setState(() => _scheduleRhythm = null);
                              _markDirty();
                            },
                          );
                        }
                        final value = DailyScheduleRhythm.values[index - 1];
                        return ProfileOptionTile(
                          icon: _scheduleIcon(value),
                          label: _scheduleLabel(l10n, value),
                          description: _scheduleDesc(l10n, value),
                          selected: _scheduleRhythm == value,
                          enabled: fieldsEnabled,
                          onTap: () {
                            setState(() => _scheduleRhythm = value);
                            _markDirty();
                          },
                        );
                      },
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                    sliver: SliverToBoxAdapter(
                      child: Text(
                        l10n.personalizationOccupation,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.slate500,
                            ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 2.4,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index == 0) {
                            return _OccupationChip(
                              label: l10n.personalizationNotSpecified,
                              icon: Icons.remove_circle_outline,
                              selected: _occupationStatus == null,
                              enabled: fieldsEnabled,
                              onTap: () {
                                setState(() => _occupationStatus = null);
                                _markDirty();
                              },
                            );
                          }
                          final value = OccupationStatus.values[index - 1];
                          return _OccupationChip(
                            label: _occupationLabel(l10n, value),
                            icon: _occupationIcon(value),
                            selected: _occupationStatus == value,
                            enabled: fieldsEnabled,
                            onTap: () {
                              setState(() => _occupationStatus = value);
                              _markDirty();
                            },
                          );
                        },
                        childCount: OccupationStatus.values.length + 1,
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 28, 16, 0),
                    sliver: SliverToBoxAdapter(
                      child: ProfileSectionHeader(
                        icon: Icons.psychology_outlined,
                        title: l10n.personalizationCoachingSection,
                        subtitle: l10n.personalizationCoachingSectionDesc,
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    sliver: SliverToBoxAdapter(
                      child: Text(
                        l10n.personalizationCoachingStyle,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.slate500,
                            ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    sliver: SliverList.separated(
                      itemCount: CoachingFocusStyle.values.length + 1,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return ProfileCoachingCard(
                            emoji: '✨',
                            label: l10n.personalizationNotSpecified,
                            description: l10n.personalizationPreviewStyleDefault,
                            selected: _coachingStyle == null,
                            enabled: fieldsEnabled,
                            onTap: () {
                              setState(() => _coachingStyle = null);
                              _markDirty();
                            },
                          );
                        }
                        final style = CoachingFocusStyle.values[index - 1];
                        return ProfileCoachingCard(
                          emoji: _coachingEmoji(style),
                          label: _coachingLabel(l10n, style),
                          description: _coachingDesc(l10n, style),
                          selected: _coachingStyle == style,
                          enabled: fieldsEnabled,
                          onTap: () {
                            setState(() => _coachingStyle = style);
                            _markDirty();
                          },
                        );
                      },
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                    sliver: SliverToBoxAdapter(
                      child: Text(
                        l10n.personalizationMilestoneGranularity,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.slate500,
                            ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    sliver: SliverList.separated(
                      itemCount: MilestoneGranularity.values.length + 1,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return ProfileOptionTile(
                            icon: Icons.remove_circle_outline,
                            label: l10n.personalizationNotSpecified,
                            selected: _milestoneGranularity == null,
                            enabled: fieldsEnabled,
                            onTap: () {
                              setState(() => _milestoneGranularity = null);
                              _markDirty();
                            },
                          );
                        }
                        final value = MilestoneGranularity.values[index - 1];
                        return ProfileOptionTile(
                          icon: _milestoneIcon(value),
                          label: _milestoneLabel(l10n, value),
                          description: _milestoneDesc(l10n, value),
                          selected: _milestoneGranularity == value,
                          enabled: fieldsEnabled,
                          onTap: () {
                            setState(() => _milestoneGranularity = value);
                            _markDirty();
                          },
                        );
                      },
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                    sliver: SliverToBoxAdapter(
                      child: Text(
                        l10n.personalizationMotivationDriver,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.slate500,
                            ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 1.15,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index == 0) {
                            return _MotivationCard(
                              icon: Icons.remove_circle_outline,
                              label: l10n.personalizationNotSpecified,
                              description: null,
                              selected: _motivationDriver == null,
                              enabled: fieldsEnabled,
                              onTap: () {
                                setState(() => _motivationDriver = null);
                                _markDirty();
                              },
                            );
                          }
                          final value = MotivationDriver.values[index - 1];
                          return _MotivationCard(
                            icon: _motivationIcon(value),
                            label: _motivationLabel(l10n, value),
                            description: _motivationDesc(l10n, value),
                            selected: _motivationDriver == value,
                            enabled: fieldsEnabled,
                            onTap: () {
                              setState(() => _motivationDriver = value);
                              _markDirty();
                            },
                          );
                        },
                        childCount: MotivationDriver.values.length + 1,
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                    sliver: SliverToBoxAdapter(
                      child: Text(
                        l10n.personalizationChallengeAreas,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.slate500,
                            ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    sliver: SliverToBoxAdapter(
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: ChallengeArea.values.map((area) {
                          final selected = _challengeAreas.contains(area);
                          return FilterChip(
                            label: Text(_challengeLabel(l10n, area)),
                            selected: selected,
                            showCheckmark: true,
                            selectedColor: AppColors.cyan.withValues(alpha: 0.15),
                            checkmarkColor: AppColors.cyan,
                            side: BorderSide(
                              color: selected
                                  ? AppColors.cyan
                                  : Theme.of(context)
                                      .dividerColor
                                      .withValues(alpha: 0.5),
                            ),
                            onSelected: fieldsEnabled
                                ? (_) => _toggleChallenge(area)
                                : null,
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 28, 16, 0),
                    sliver: SliverToBoxAdapter(
                      child: ProfileSectionHeader(
                        icon: Icons.edit_note_outlined,
                        title: l10n.personalizationAboutSection,
                        subtitle: l10n.personalizationAboutSectionDesc,
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    sliver: SliverToBoxAdapter(
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                          side: BorderSide(
                            color: Theme.of(context)
                                .dividerColor
                                .withValues(alpha: 0.4),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: TextField(
                            controller: _bioController,
                            enabled: fieldsEnabled,
                            maxLines: 6,
                            minLines: 4,
                            decoration: InputDecoration(
                              hintText: l10n.personalizationUserBioHint,
                              border: InputBorder.none,
                            ),
                            onChanged: (_) => _markDirty(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                    sliver: SliverToBoxAdapter(
                      child: ProfilePrivacyNote(text: l10n.personalizationPrivacyNote),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(16, 20, 16, bottomPadding),
                    sliver: SliverToBoxAdapter(
                      child: OutlinedButton.icon(
                        onPressed: _confirmClear,
                        icon: const Icon(Icons.delete_outline),
                        label: Text(l10n.personalizationClear),
                      ),
                    ),
                  ),
                ],
              ),
              if (_dirty)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: ProfileSaveBar(
                    saveLabel: l10n.personalizationSave,
                    onSave: _save,
                    saving: _saving,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  IconData _scheduleIcon(DailyScheduleRhythm value) => switch (value) {
        DailyScheduleRhythm.earlyBird => Icons.wb_sunny_outlined,
        DailyScheduleRhythm.nightOwl => Icons.nightlight_outlined,
        DailyScheduleRhythm.flexible => Icons.schedule_outlined,
        DailyScheduleRhythm.irregular => Icons.shuffle_outlined,
      };

  IconData _occupationIcon(OccupationStatus value) => switch (value) {
        OccupationStatus.student => Icons.school_outlined,
        OccupationStatus.employed => Icons.work_outline,
        OccupationStatus.selfEmployed => Icons.storefront_outlined,
        OccupationStatus.freelancing => Icons.laptop_mac_outlined,
        OccupationStatus.unemployed => Icons.search_outlined,
        OccupationStatus.caregiving => Icons.family_restroom_outlined,
        OccupationStatus.retired => Icons.beach_access_outlined,
      };

  IconData _milestoneIcon(MilestoneGranularity value) => switch (value) {
        MilestoneGranularity.microSteps => Icons.grain,
        MilestoneGranularity.balanced => Icons.linear_scale,
        MilestoneGranularity.ambitious => Icons.rocket_launch_outlined,
      };

  IconData _motivationIcon(MotivationDriver value) => switch (value) {
        MotivationDriver.encouragement => Icons.favorite_outline,
        MotivationDriver.accountability => Icons.fact_check_outlined,
        MotivationDriver.autonomy => Icons.explore_outlined,
        MotivationDriver.challenge => Icons.local_fire_department_outlined,
      };

  String _coachingEmoji(CoachingFocusStyle value) => switch (value) {
        CoachingFocusStyle.empathetic => '💙',
        CoachingFocusStyle.balanced => '⚖️',
        CoachingFocusStyle.direct => '🎯',
        CoachingFocusStyle.military => '🎖️',
      };

  String _scheduleLabel(AppLocalizations l10n, DailyScheduleRhythm value) {
    return switch (value) {
      DailyScheduleRhythm.earlyBird => l10n.personalizationScheduleEarlyBird,
      DailyScheduleRhythm.nightOwl => l10n.personalizationScheduleNightOwl,
      DailyScheduleRhythm.flexible => l10n.personalizationScheduleFlexible,
      DailyScheduleRhythm.irregular => l10n.personalizationScheduleIrregular,
    };
  }

  String _scheduleDesc(AppLocalizations l10n, DailyScheduleRhythm value) {
    return switch (value) {
      DailyScheduleRhythm.earlyBird =>
        l10n.personalizationScheduleEarlyBirdDesc,
      DailyScheduleRhythm.nightOwl => l10n.personalizationScheduleNightOwlDesc,
      DailyScheduleRhythm.flexible => l10n.personalizationScheduleFlexibleDesc,
      DailyScheduleRhythm.irregular =>
        l10n.personalizationScheduleIrregularDesc,
    };
  }

  String _coachingLabel(AppLocalizations l10n, CoachingFocusStyle value) {
    return switch (value) {
      CoachingFocusStyle.empathetic => l10n.personalizationStyleEmpathetic,
      CoachingFocusStyle.balanced => l10n.personalizationStyleBalanced,
      CoachingFocusStyle.direct => l10n.personalizationStyleDirect,
      CoachingFocusStyle.military => l10n.personalizationStyleMilitary,
    };
  }

  String _coachingDesc(AppLocalizations l10n, CoachingFocusStyle value) {
    return switch (value) {
      CoachingFocusStyle.empathetic => l10n.personalizationStyleEmpatheticDesc,
      CoachingFocusStyle.balanced => l10n.personalizationStyleBalancedDesc,
      CoachingFocusStyle.direct => l10n.personalizationStyleDirectDesc,
      CoachingFocusStyle.military => l10n.personalizationStyleMilitaryDesc,
    };
  }

  String _occupationLabel(AppLocalizations l10n, OccupationStatus value) {
    return switch (value) {
      OccupationStatus.student => l10n.personalizationOccupationStudent,
      OccupationStatus.employed => l10n.personalizationOccupationEmployed,
      OccupationStatus.selfEmployed =>
        l10n.personalizationOccupationSelfEmployed,
      OccupationStatus.freelancing =>
        l10n.personalizationOccupationFreelancing,
      OccupationStatus.unemployed => l10n.personalizationOccupationUnemployed,
      OccupationStatus.caregiving => l10n.personalizationOccupationCaregiving,
      OccupationStatus.retired => l10n.personalizationOccupationRetired,
    };
  }

  String _milestoneLabel(AppLocalizations l10n, MilestoneGranularity value) {
    return switch (value) {
      MilestoneGranularity.microSteps => l10n.personalizationMilestoneMicro,
      MilestoneGranularity.balanced => l10n.personalizationMilestoneBalanced,
      MilestoneGranularity.ambitious => l10n.personalizationMilestoneAmbitious,
    };
  }

  String _milestoneDesc(AppLocalizations l10n, MilestoneGranularity value) {
    return switch (value) {
      MilestoneGranularity.microSteps =>
        l10n.personalizationMilestoneMicroDesc,
      MilestoneGranularity.balanced =>
        l10n.personalizationMilestoneBalancedDesc,
      MilestoneGranularity.ambitious =>
        l10n.personalizationMilestoneAmbitiousDesc,
    };
  }

  String _motivationLabel(AppLocalizations l10n, MotivationDriver value) {
    return switch (value) {
      MotivationDriver.encouragement =>
        l10n.personalizationMotivationEncouragement,
      MotivationDriver.accountability =>
        l10n.personalizationMotivationAccountability,
      MotivationDriver.autonomy => l10n.personalizationMotivationAutonomy,
      MotivationDriver.challenge => l10n.personalizationMotivationChallenge,
    };
  }

  String _motivationDesc(AppLocalizations l10n, MotivationDriver value) {
    return switch (value) {
      MotivationDriver.encouragement =>
        l10n.personalizationMotivationEncouragementDesc,
      MotivationDriver.accountability =>
        l10n.personalizationMotivationAccountabilityDesc,
      MotivationDriver.autonomy => l10n.personalizationMotivationAutonomyDesc,
      MotivationDriver.challenge => l10n.personalizationMotivationChallengeDesc,
    };
  }

  String _challengeLabel(AppLocalizations l10n, ChallengeArea value) {
    return switch (value) {
      ChallengeArea.procrastination =>
        l10n.personalizationChallengeProcrastination,
      ChallengeArea.inconsistency => l10n.personalizationChallengeInconsistency,
      ChallengeArea.overwhelm => l10n.personalizationChallengeOverwhelm,
      ChallengeArea.perfectionism => l10n.personalizationChallengePerfectionism,
      ChallengeArea.timeManagement =>
        l10n.personalizationChallengeTimeManagement,
    };
  }
}

class _OccupationChip extends StatelessWidget {
  const _OccupationChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
    required this.enabled,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: selected
          ? AppColors.cyan.withValues(alpha: 0.08)
          : theme.cardColor,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected
                  ? AppColors.cyan
                  : theme.dividerColor.withValues(alpha: 0.45),
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: selected ? AppColors.cyan : AppColors.slate500,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MotivationCard extends StatelessWidget {
  const _MotivationCard({
    required this.icon,
    required this.label,
    required this.description,
    required this.selected,
    required this.onTap,
    required this.enabled,
  });

  final IconData icon;
  final String label;
  final String? description;
  final bool selected;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: selected
          ? AppColors.cyan.withValues(alpha: 0.08)
          : theme.cardColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected
                  ? AppColors.cyan
                  : theme.dividerColor.withValues(alpha: 0.45),
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 20,
                color: selected ? AppColors.cyan : AppColors.slate500,
              ),
              const Spacer(),
              Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (description != null) ...[
                const SizedBox(height: 2),
                Text(
                  description!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.slate500,
                    fontSize: 11,
                    height: 1.25,
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
