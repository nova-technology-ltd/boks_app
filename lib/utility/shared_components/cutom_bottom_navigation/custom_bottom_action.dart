import 'package:boks/utility/constants/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../constants/app_colors.dart';

class CustomBottomAction extends StatelessWidget {
  final String home;
  final String search;
  final String cart;
  final String profile;
  final VoidCallback onHomeClick;
  final VoidCallback onSearchClick;
  final VoidCallback onCartClick;
  final VoidCallback onProfileClick;
  const CustomBottomAction({super.key, required this.home, required this.search, required this.cart, required this.onHomeClick, required this.onSearchClick, required this.onCartClick, required this.profile, required this.onProfileClick});

  @override
  Widget build(BuildContext context) {
    final mobileView = MediaQuery.of(context).size.width < 600;
    return Container(
      height: 55,
      width: mobileView ? MediaQuery.of(context).size.width / 2.2 : 200,
      decoration: BoxDecoration(
        color: Color(AppColors.primaryColor),
        borderRadius: BorderRadius.circular(22)
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(child: IconButton(onPressed: onHomeClick, icon: Icon(home == "Home" ? IconlyBold.home : IconlyLight.home, color: Colors.white.withOpacity(0.8), size: 21,))),
            Expanded(child: IconButton(onPressed: onSearchClick, icon: Image.asset(home == "Search" ? AppIcons.bottomNavPieSelected : AppIcons.bottomNavPieUnselected , color: Colors.white.withOpacity(0.8),))),
            Expanded(child: IconButton(onPressed: onCartClick, icon: Icon(home == "Cart" ? IconlyBold.notification : IconlyLight.notification, color: Colors.white.withOpacity(0.8), size: 21,))),
            Expanded(child: IconButton(onPressed: onProfileClick, icon: Icon(home == "Profile" ? IconlyBold.setting : IconlyLight.setting, color: Colors.white.withOpacity(0.8), size: 21,))),
          ],
        ),
      ),
    );
  }
}
