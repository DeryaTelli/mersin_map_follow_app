import 'package:flutter/material.dart';
import 'package:mersin_map_follow_app/utility/constant/color/colors.dart';
import 'package:mersin_map_follow_app/utility/constant/theme/text_theme.dart';

class TopSearchBar extends StatelessWidget {
  const TopSearchBar({
    super.key,
    required this.onMenuTap,
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  final VoidCallback onMenuTap;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 12,
          right: 12,
          top: media.padding.top == 0 ? 8 : 0,
        ),
        child: Row(
          children: [
            // Menü butonu
            InkWell(
              onTap: onMenuTap,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFDA9A22),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.menu, color: Colors.white),
              ),
            ),
            const SizedBox(width: 8),
            // Arama barı
            Expanded(
              child: Container(
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.secondaryColor,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                      color: Colors.black.withOpacity(.15),
                    ),
                  ],
                ),
                child: TextField(
                  controller: controller,
                  onChanged: onChanged,
                  cursorColor: AppColors.primaryColor,
                  textAlignVertical:
                      TextAlignVertical.center, // Yazı + caret ortada
                  style: AppTextStyle.nunitoRegular16,
                  decoration: InputDecoration(
                    hintText: 'Search workers',
                    hintStyle: AppTextStyle.nunitoRegular16Gray,
                    border: InputBorder.none,
                    isCollapsed: true, // Extra padding’i kapatır
                    prefixIcon: const Icon(
                      Icons.search,
                      size: 20,
                      color: AppColors.primaryColor,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: onClear,
                      child: const Icon(
                        Icons.close_rounded,
                        size: 20,
                        color: Colors.orange,
                      ),
                    ),
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 40,
                      minHeight: 42,
                    ),
                    suffixIconConstraints: const BoxConstraints(
                      minWidth: 40,
                      minHeight: 42,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 4,
                    ), // Yatay boşluk
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
