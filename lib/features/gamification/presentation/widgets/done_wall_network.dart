import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:goal_pilot/core/theme/app_colors.dart';
import 'package:goal_pilot/features/gamification/domain/entities/win_brick.dart';

typedef NetworkEdge = (int from, int to);

class NetworkGraphLayout {
  const NetworkGraphLayout({
    required this.positions,
    required this.edges,
    required this.nodeRadius,
  });

  final List<Offset> positions;
  final List<NetworkEdge> edges;
  final double nodeRadius;
}

double doneWallNodeRadiusFor(int count) {
  if (count <= 3) return 18;
  if (count <= 6) return 16;
  if (count <= 9) return 14;
  return 12;
}

double doneWallNetworkHeightFor(int count) {
  if (count <= 3) return 200;
  if (count <= 6) return 230;
  if (count <= 9) return 260;
  return 300;
}

NetworkGraphLayout computeNetworkGraphLayout({
  required List<WinBrick> bricks,
  required Size size,
  double? nodeRadius,
}) {
  final radius = nodeRadius ?? doneWallNodeRadiusFor(bricks.length);
  final safeSize = _safeLayoutSize(size, radius);

  if (bricks.isEmpty) {
    return const NetworkGraphLayout(
      positions: [],
      edges: [],
      nodeRadius: 14,
    );
  }

  if (bricks.length == 1) {
    return NetworkGraphLayout(
      positions: [Offset(safeSize.width / 2, safeSize.height / 2)],
      edges: const [],
      nodeRadius: radius,
    );
  }

  if (!_hasUsableArea(safeSize, radius)) {
    return NetworkGraphLayout(
      positions: _fallbackGridLayout(
        count: bricks.length,
        size: safeSize,
        nodeRadius: radius,
      ),
      edges: _buildStructuralEdges(bricks),
      nodeRadius: radius,
    );
  }

  final seed = bricks.fold<int>(0, (sum, brick) => sum ^ brick.id.hashCode);
  final structuralEdges = _buildStructuralEdges(bricks);
  final initial = _seedPositions(
    count: bricks.length,
    size: safeSize,
    nodeRadius: radius,
    seed: seed,
  );
  final positions = _sanitizePositions(
    _simulateLayout(
      initial: initial,
      edges: structuralEdges,
      size: safeSize,
      nodeRadius: radius,
    ),
    size: safeSize,
    nodeRadius: radius,
    fallback: initial,
  );
  final edges = _mergeEdges(
    structuralEdges,
    _proximityEdges(positions, maxDegree: 2),
  );

  return NetworkGraphLayout(
    positions: positions,
    edges: edges,
    nodeRadius: radius,
  );
}

Size _safeLayoutSize(Size size, double nodeRadius) {
  final minSide = nodeRadius * 4 + 24;
  return Size(
    size.width.isFinite && size.width > 0 ? size.width : minSide,
    size.height.isFinite && size.height > 0 ? size.height : minSide,
  );
}

bool _hasUsableArea(Size size, double nodeRadius) {
  final margin = nodeRadius + 8;
  return size.width > margin * 2 + 8 && size.height > margin * 2 + 8;
}

bool _isFiniteOffset(Offset value) => value.dx.isFinite && value.dy.isFinite;

Offset _clampPosition(Offset point, Size size, double margin) {
  final minX = margin;
  final maxX = math.max(minX, size.width - margin);
  final minY = margin;
  final maxY = math.max(minY, size.height - margin);
  return Offset(
    point.dx.clamp(minX, maxX),
    point.dy.clamp(minY, maxY),
  );
}

List<Offset> _sanitizePositions(
  List<Offset> positions, {
  required Size size,
  required double nodeRadius,
  required List<Offset> fallback,
}) {
  final margin = nodeRadius + 8;
  return List.generate(positions.length, (index) {
    final point = positions[index];
    if (!_isFiniteOffset(point)) {
      return _clampPosition(fallback[index], size, margin);
    }
    return _clampPosition(point, size, margin);
  });
}

List<Offset> _fallbackGridLayout({
  required int count,
  required Size size,
  required double nodeRadius,
}) {
  final margin = nodeRadius + 8;
  final cols = math.max(1, math.sqrt(count).ceil());
  final rows = (count / cols).ceil();
  final cellWidth = (size.width - margin * 2) / cols;
  final cellHeight = (size.height - margin * 2) / rows;

  return List.generate(count, (index) {
    final col = index % cols;
    final row = index ~/ cols;
    return _clampPosition(
      Offset(
        margin + cellWidth * (col + 0.5),
        margin + cellHeight * (row + 0.5),
      ),
      size,
      margin,
    );
  });
}

Offset _limitForce(Offset force, double maxMagnitude) {
  final magnitude = force.distance;
  if (!magnitude.isFinite || magnitude <= maxMagnitude) {
    return _isFiniteOffset(force) ? force : Offset.zero;
  }
  return Offset(
    force.dx / magnitude * maxMagnitude,
    force.dy / magnitude * maxMagnitude,
  );
}

List<NetworkEdge> _buildStructuralEdges(List<WinBrick> bricks) {
  final edges = <NetworkEdge>{};

  for (var i = 0; i < bricks.length - 1; i++) {
    edges.add(_edge(i, i + 1));
  }

  final goalFirstIndex = <String, int>{};
  for (var i = 0; i < bricks.length; i++) {
    final goalId = bricks[i].goalId;
    final firstIndex = goalFirstIndex.putIfAbsent(goalId, () => i);
    if (firstIndex != i) {
      edges.add(_edge(firstIndex, i));
    }
  }

  if (bricks.length <= 5) {
    for (var i = 0; i < bricks.length; i++) {
      for (var j = i + 1; j < bricks.length; j++) {
        edges.add(_edge(i, j));
      }
    }
  }

  return edges.toList();
}

List<NetworkEdge> _proximityEdges(
  List<Offset> positions, {
  required int maxDegree,
}) {
  final edges = <NetworkEdge>{};
  final degrees = List<int>.filled(positions.length, 0);

  for (var i = 0; i < positions.length; i++) {
    final neighbors = <(int index, double distance)>[];
    for (var j = 0; j < positions.length; j++) {
      if (i == j) continue;
      neighbors.add((j, (positions[i] - positions[j]).distance));
    }
    neighbors.sort((a, b) => a.$2.compareTo(b.$2));

    for (final neighbor in neighbors) {
      if (degrees[i] >= maxDegree) break;
      final j = neighbor.$1;
      if (degrees[j] >= maxDegree) continue;
      final edge = _edge(i, j);
      if (edges.add(edge)) {
        degrees[i]++;
        degrees[j]++;
      }
    }
  }

  return edges.toList();
}

List<NetworkEdge> _mergeEdges(
  List<NetworkEdge> primary,
  List<NetworkEdge> secondary,
) {
  return {...primary, ...secondary}.toList();
}

NetworkEdge _edge(int a, int b) => a < b ? (a, b) : (b, a);

List<Offset> _seedPositions({
  required int count,
  required Size size,
  required double nodeRadius,
  required int seed,
}) {
  final margin = nodeRadius + 10;
  final width = math.max(1, size.width - margin * 2);
  final height = math.max(1, size.height - margin * 2);
  final center = Offset(size.width / 2, size.height / 2);
  final rng = math.Random(seed);

  return List.generate(count, (index) {
    final angle = index * 2.399963229728653 + rng.nextDouble() * 0.35;
    final radiusFactor = math.sqrt((index + 1) / count);
    final spread = math.min(width, height) * 0.42 * radiusFactor;
    final jitterX = (rng.nextDouble() - 0.5) * width * 0.12;
    final jitterY = (rng.nextDouble() - 0.5) * height * 0.12;

    return _clampPosition(
      Offset(
        center.dx + spread * math.cos(angle) + jitterX,
        center.dy + spread * math.sin(angle) + jitterY,
      ),
      size,
      margin,
    );
  });
}

List<Offset> _simulateLayout({
  required List<Offset> initial,
  required List<NetworkEdge> edges,
  required Size size,
  required double nodeRadius,
}) {
  final positions = List<Offset>.from(initial);
  final velocities = List<Offset>.filled(positions.length, Offset.zero);
  final margin = nodeRadius + 8;
  final area = math.max(
    1,
    (size.width - margin * 2) * (size.height - margin * 2),
  );
  final idealLength = math.max(
    nodeRadius * 2.35,
    math.sqrt(area / positions.length),
  );
  final minDistance = nodeRadius * 2.35;
  const maxForce = 120.0;

  for (var iteration = 0; iteration < 140; iteration++) {
    final forces = List<Offset>.filled(positions.length, Offset.zero);
    final cooling = 1 - (iteration / 140);

    for (var i = 0; i < positions.length; i++) {
      for (var j = i + 1; j < positions.length; j++) {
        final delta = positions[i] - positions[j];
        var distance = delta.distance;
        if (!distance.isFinite || distance < 0.01) distance = 0.01;

        var repulsion = (idealLength * idealLength) / distance;
        if (distance < minDistance) {
          repulsion += (minDistance - distance) * 8;
        }

        final force = _limitForce(
          Offset(
            delta.dx / distance * repulsion,
            delta.dy / distance * repulsion,
          ),
          maxForce,
        );
        forces[i] += force;
        forces[j] -= force;
      }
    }

    for (final (from, to) in edges) {
      final delta = positions[to] - positions[from];
      var distance = delta.distance;
      if (!distance.isFinite || distance < 0.01) distance = 0.01;
      final attraction = (distance * distance) / idealLength * 0.45;
      final force = _limitForce(
        Offset(
          delta.dx / distance * attraction,
          delta.dy / distance * attraction,
        ),
        maxForce,
      );
      forces[from] += force;
      forces[to] -= force;
    }

    final center = Offset(size.width / 2, size.height / 2);
    for (var i = 0; i < positions.length; i++) {
      final toCenter = center - positions[i];
      forces[i] += _limitForce(toCenter * 0.02, maxForce);

      final point = positions[i];
      if (point.dx < margin) {
        forces[i] += Offset((margin - point.dx) * 0.8, 0);
      } else if (point.dx > size.width - margin) {
        forces[i] += Offset((size.width - margin - point.dx) * 0.8, 0);
      }
      if (point.dy < margin) {
        forces[i] += Offset(0, (margin - point.dy) * 0.8);
      } else if (point.dy > size.height - margin) {
        forces[i] += Offset(0, (size.height - margin - point.dy) * 0.8);
      }

      forces[i] = _limitForce(forces[i], maxForce);
    }

    for (var i = 0; i < positions.length; i++) {
      velocities[i] = _limitForce(
        (velocities[i] + forces[i] * cooling) * 0.82,
        maxForce,
      );
      positions[i] = _clampPosition(positions[i] + velocities[i], size, margin);
      if (!_isFiniteOffset(positions[i])) {
        positions[i] = _clampPosition(initial[i], size, margin);
        velocities[i] = Offset.zero;
      }
    }
  }

  return positions;
}

class DoneWallNetwork extends StatelessWidget {
  const DoneWallNetwork({
    super.key,
    required this.bricks,
    this.selectedBrickId,
    this.onBrickTap,
  });

  final List<WinBrick> bricks;
  final String? selectedBrickId;
  final ValueChanged<WinBrick>? onBrickTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final selectedIndex = selectedBrickId == null
        ? null
        : bricks.indexWhere((brick) => brick.id == selectedBrickId);

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= 0 || constraints.maxHeight <= 0) {
          return const SizedBox.shrink();
        }

        final size = Size(constraints.maxWidth, constraints.maxHeight);
        final layout = computeNetworkGraphLayout(bricks: bricks, size: size);
        final nodeRadius = layout.nodeRadius;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            CustomPaint(
              size: size,
              painter: _DoneWallNetworkPainter(
                positions: layout.positions,
                edges: layout.edges,
                isDark: isDark,
                selectedIndex:
                    selectedIndex == -1 ? null : selectedIndex,
              ),
            ),
            ...List.generate(bricks.length, (index) {
              final brick = bricks[index];
              final center = layout.positions[index];
              if (!_isFiniteOffset(center)) return const SizedBox.shrink();
              final isSelected = brick.id == selectedBrickId;
              final isNewest = index == 0;

              return Positioned(
                left: center.dx - nodeRadius,
                top: center.dy - nodeRadius,
                child: _NetworkNode(
                  brick: brick,
                  radius: nodeRadius,
                  isDark: isDark,
                  isSelected: isSelected,
                  isNewest: isNewest,
                  onTap: () => onBrickTap?.call(brick),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}

class _NetworkNode extends StatelessWidget {
  const _NetworkNode({
    required this.brick,
    required this.radius,
    required this.isDark,
    required this.isSelected,
    required this.isNewest,
    required this.onTap,
  });

  final WinBrick brick;
  final double radius;
  final bool isDark;
  final bool isSelected;
  final bool isNewest;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fillColor = isSelected
        ? (isDark ? AppColors.cyan : AppColors.deepBlue)
        : (isDark ? AppColors.darkSurfaceVariant : Colors.white);
    final borderColor = isNewest
        ? AppColors.success
        : (isSelected
            ? AppColors.cyanLight
            : (isDark
                ? AppColors.cyanLight.withValues(alpha: 0.55)
                : AppColors.cyan.withValues(alpha: 0.65)));
    final iconColor = isSelected
        ? Colors.white
        : (isDark ? AppColors.cyanLight : AppColors.deepBlue);

    return Semantics(
      button: true,
      label: brick.label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: radius * 2,
            height: radius * 2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: fillColor,
              border: Border.all(
                color: borderColor,
                width: isSelected || isNewest ? 2.5 : 2,
              ),
              boxShadow: [
                if (isNewest || isSelected)
                  BoxShadow(
                    color: (isNewest ? AppColors.success : AppColors.cyan)
                        .withValues(alpha: isDark ? 0.45 : 0.35),
                    blurRadius: isSelected ? 14 : 10,
                    spreadRadius: isSelected ? 1 : 0,
                  ),
              ],
            ),
            child: Icon(
              brick.source == WinBrickSource.checkIn
                  ? Icons.auto_awesome
                  : Icons.bolt_rounded,
              size: radius * 0.95,
              color: iconColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _DoneWallNetworkPainter extends CustomPainter {
  _DoneWallNetworkPainter({
    required this.positions,
    required this.edges,
    required this.isDark,
    this.selectedIndex,
  });

  final List<Offset> positions;
  final List<NetworkEdge> edges;
  final bool isDark;
  final int? selectedIndex;

  @override
  void paint(Canvas canvas, Size size) {
    if (edges.isEmpty || positions.length < 2) return;

    final edgePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = (isDark ? AppColors.cyanLight : AppColors.cyan)
          .withValues(alpha: isDark ? 0.24 : 0.3);

    final highlightPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = (isDark ? AppColors.cyanLight : AppColors.cyan)
          .withValues(alpha: isDark ? 0.62 : 0.58);

    for (final (from, to) in edges) {
      if (!_isFiniteOffset(positions[from]) || !_isFiniteOffset(positions[to])) {
        continue;
      }
      final touchesSelection = selectedIndex != null &&
          (from == selectedIndex || to == selectedIndex);
      canvas.drawLine(
        positions[from],
        positions[to],
        touchesSelection ? highlightPaint : edgePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DoneWallNetworkPainter oldDelegate) {
    return oldDelegate.positions != positions ||
        oldDelegate.edges != edges ||
        oldDelegate.isDark != isDark ||
        oldDelegate.selectedIndex != selectedIndex;
  }
}

class DoneWallNetworkPlaceholder extends StatelessWidget {
  const DoneWallNetworkPlaceholder({super.key, required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= 0 || constraints.maxHeight <= 0) {
          return const SizedBox.shrink();
        }

        final size = Size(constraints.maxWidth, constraints.maxHeight);
        final layout = computeNetworkGraphLayout(
          bricks: List.generate(
            7,
            (index) => WinBrick(
              id: 'placeholder-$index',
              goalId: index.isEven ? 'goal-a' : 'goal-b',
              label: '',
              createdAt: DateTime.now(),
              source: WinBrickSource.task,
            ),
          ),
          size: size,
          nodeRadius: 12,
        );

        return CustomPaint(
          size: size,
          painter: _PlaceholderNetworkPainter(
            positions: layout.positions,
            edges: layout.edges,
            isDark: isDark,
          ),
        );
      },
    );
  }
}

class _PlaceholderNetworkPainter extends CustomPainter {
  _PlaceholderNetworkPainter({
    required this.positions,
    required this.edges,
    required this.isDark,
  });

  final List<Offset> positions;
  final List<NetworkEdge> edges;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final edgePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = (isDark ? AppColors.slate400 : AppColors.slate500)
          .withValues(alpha: 0.2);

    for (final (from, to) in edges) {
      if (!_isFiniteOffset(positions[from]) || !_isFiniteOffset(positions[to])) {
        continue;
      }
      canvas.drawLine(positions[from], positions[to], edgePaint);
    }

    final nodePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = (isDark ? AppColors.slate400 : AppColors.slate500)
          .withValues(alpha: 0.28);

    for (final position in positions) {
      if (!_isFiniteOffset(position)) continue;
      canvas.drawCircle(position, 12, nodePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _PlaceholderNetworkPainter oldDelegate) {
    return oldDelegate.isDark != isDark;
  }
}
