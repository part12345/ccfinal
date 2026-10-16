import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CompanyLogo extends StatelessWidget {
  final String company;
  final double size;

  const CompanyLogo({
    super.key,
    required this.company,
    this.size = 50,
  });

  IconData _getIcon() {
    final name = company.toLowerCase();

    if (name.contains('google')) {
      return Icons.g_mobiledata;
    }

    if (name.contains('microsoft')) {
      return Icons.window;
    }

    if (name.contains('apple')) {
      return Icons.apple;
    }

    if (name.contains('amazon')) {
      return Icons.shopping_cart;
    }

    if (name.contains('facebook') || name.contains('meta')) {
      return Icons.facebook;
    }

    if (name.contains('abc')) {
      return Icons.business;
    }

    if (name.contains('tech')) {
      return Icons.computer;
    }

    if (name.contains('global')) {
      return Icons.public;
    }

    return Icons.business;
  }

  Color _getColor() {
    final name = company.toLowerCase();

    if (name.contains('google')) {
      return AppColors.red;
    }

    if (name.contains('microsoft')) {
      return AppColors.blue;
    }

    if (name.contains('apple')) {
      return Colors.black;
    }

    if (name.contains('amazon')) {
      return AppColors.orange;
    }

    if (name.contains('facebook') || name.contains('meta')) {
      return const Color(0xFF1877F2);
    }

    if (name.contains('abc')) {
      return AppColors.red;
    }

    if (name.contains('tech')) {
      return AppColors.blue;
    }

    if (name.contains('global')) {
      return AppColors.green;
    }

    return AppColors.primary;
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          _getIcon(),
          color: color,
          size: size * .55,
        ),
      ),
    );
  }
}
