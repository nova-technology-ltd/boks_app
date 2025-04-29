import 'package:boks/utility/constants/app_colors.dart';
import 'package:boks/utility/constants/app_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsOptionCardStyleOne extends StatelessWidget {
  final String icon;
  final Icon? iconTwo;
  final String title;
  final String? value;
  final bool isValueColored;
  final bool hasSwitch;
  final bool? switchValue;
  final VoidCallback? onClick;
  final ValueChanged<bool>? onFlip;

  const SettingsOptionCardStyleOne({
    super.key,
    required this.icon,
    required this.title,
    this.value,
    required this.isValueColored,
    required this.hasSwitch,
    this.onFlip,
    this.onClick,
    this.iconTwo,
    this.switchValue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Material(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onClick,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 35,
            width: MediaQuery.of(context).size.width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Leading icon and title
                Row(
                  children: [
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Color(AppColors.primaryColor).withOpacity(0.05),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: SizedBox(
                          height: 13,
                          width: 13,
                          child: iconTwo ?? Image.asset(
                            icon,
                            color: Color(AppColors.primaryColor),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // Trailing widget
                if (hasSwitch)
                  Transform.scale(
                    scale: 0.7,
                    child: CupertinoSwitch(
                      value: switchValue ?? false,
                      activeColor: Color(AppColors.primaryColor),
                      onChanged: onFlip,
                    ),
                  )
                else if (value != null)
                  Row(
                    children: [
                      Text(
                        value!,
                        style: TextStyle(
                          color: isValueColored
                              ? Color(AppColors.primaryColor)
                              : Colors.grey,
                          fontWeight: FontWeight.w300,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.grey,
                        size: 13,
                      ),
                    ],
                  )
                else
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.grey,
                    size: 13,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}