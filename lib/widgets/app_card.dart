import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const AppCard({super.key, required this.child, this.padding = const EdgeInsets.all(18)});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: isDark ? .9 : .75)),
        boxShadow: [BoxShadow(
          color: (isDark ? Colors.black : const Color(0xFF5145A8)).withValues(alpha: isDark ? .12 : .035),
          blurRadius: 20, offset: const Offset(0, 7),
        )],
      ),
      child: child,
    );
  }
}
