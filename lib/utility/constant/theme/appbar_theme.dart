import 'package:flutter/material.dart';
import 'package:mersin_map_follow_app/utility/constant/color/colors.dart';
import 'package:mersin_map_follow_app/utility/constant/theme/text_theme.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyle.olegaOne32White,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
    );
  }
}
