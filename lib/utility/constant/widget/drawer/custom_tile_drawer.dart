import 'package:flutter/material.dart';
import 'package:mersin_map_follow_app/utility/constant/color/colors.dart';
import 'package:mersin_map_follow_app/utility/constant/theme/text_theme.dart';

class DrawerTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const DrawerTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryColor, size: 24),
      title: Text(label, style: AppTextStyle.nunitoBold16White),
      onTap: onTap,
    );
  }
}
