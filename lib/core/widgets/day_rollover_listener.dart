import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_pilot/core/providers/today_provider.dart';

/// Keeps [todayProvider] in sync when the app resumes after midnight.
class DayRolloverListener extends ConsumerStatefulWidget {
  const DayRolloverListener({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<DayRolloverListener> createState() =>
      _DayRolloverListenerState();
}

class _DayRolloverListenerState extends ConsumerState<DayRolloverListener>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(todayProvider.notifier).syncWithClock();
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
