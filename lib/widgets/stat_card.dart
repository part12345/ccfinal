import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final Color background;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Theme.of(context).colorScheme.surface : Colors.white,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(color: isDark ? Theme.of(context).colorScheme.outline : color.withValues(alpha: .12)),
        boxShadow: [BoxShadow(
          color: (isDark ? Colors.black : color).withValues(alpha: isDark ? .10 : .07),
          blurRadius: 18, offset: const Offset(0, 7),
        )],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Container(
              width: 39, height: 39,
              decoration: BoxDecoration(color: color.withValues(alpha: isDark ? .19 : .12), borderRadius: BorderRadius.circular(13)),
              child: Icon(icon, size: 20, color: isDark ? color.withValues(alpha: .95) : color),
            ),
            const Spacer(),
            Icon(Icons.north_east_rounded, size: 16, color: color.withValues(alpha: .65)),
          ]),
          Text(value, style: TextStyle(fontSize: 27, height: 1, fontWeight: FontWeight.w900, letterSpacing: -1, color: Theme.of(context).colorScheme.onSurface)),
          Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}
