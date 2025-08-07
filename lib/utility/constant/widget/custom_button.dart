import 'package:flutter/material.dart';
import 'package:mersin_map_follow_app/utility/constant/theme/button_theme.dart';
import 'package:mersin_map_follow_app/utility/constant/theme/text_theme.dart';

enum ButtonType { filled, outlined }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonType type;
  final double height;
  final double width;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = ButtonType.outlined,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = WidgetStateProperty.resolveWith<Color?>((
      Set<WidgetState> states,
    ) {
      if (type == ButtonType.outlined) {
        return states.contains(WidgetState.pressed)
            ? AppButtonTheme.primaryColor
            : Colors.transparent;
      } else {
        return AppButtonTheme.primaryColor;
      }
    });

    final side = WidgetStateProperty.resolveWith<BorderSide?>((
      Set<WidgetState> states,
    ) {
      return type == ButtonType.outlined
          ? BorderSide(color: AppButtonTheme.primaryColor, width: 2)
          : BorderSide.none;
    });

    return SizedBox(
      height: height,
      width: width,
      child: TextButton(
        style: ButtonStyle(
          animationDuration: const Duration(
            milliseconds: 400,
          ), // arkaplan rengi degisimi icin sure koyduk
          backgroundColor: backgroundColor,
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppButtonTheme.borderRadius),
            ),
          ),
          side: side,
          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
            EdgeInsets.symmetric(horizontal: AppButtonTheme.horizontalPadding),
          ),
        ),
        onPressed: onPressed,
        child: Text(text, style: AppTextStyle.nunitoExtraBold16White),
      ),
    );
  }
}
