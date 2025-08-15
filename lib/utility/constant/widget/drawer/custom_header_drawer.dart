import 'package:flutter/material.dart';
import 'package:mersin_map_follow_app/utility/constant/color/colors.dart';
import 'package:mersin_map_follow_app/utility/constant/theme/text_theme.dart';

class DrawerHeaderCard extends StatelessWidget {
  final String avatar;
  final String name;
  final String email;

  const DrawerHeaderCard({
    super.key,
    required this.avatar,
    required this.name,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryColor, // tema rengine göre değiştir
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: Colors.white,
            backgroundImage: AssetImage(avatar),
          ),
          const SizedBox(height: 16),
          Text('Hoşgeldiniz', style: AppTextStyle.orelegaOneRegular20Purple),
          const SizedBox(height: 2),
          Text('$name\n$email', style: AppTextStyle.nunitoRegular14Purple),
        ],
      ),
    );
  }
}
