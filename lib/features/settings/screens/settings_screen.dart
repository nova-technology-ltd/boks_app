import 'package:boks/features/profile/model/user_provider.dart';
import 'package:boks/features/settings/components/settings_option_card_style_one.dart';
import 'package:boks/features/settings/screens/other_screens/profile_settings.dart';
import 'package:boks/features/settings/screens/other_screens/security/security_settings_screen.dart';
import 'package:boks/utility/constants/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../utility/constants/app_colors.dart';
import '../components/referral_section.dart';
import 'other_screens/help_center/screens/help_center_screen.dart';
import 'other_screens/write_us_a_review_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String getTimeZone() {
    Duration offset = DateTime.now().timeZoneOffset;
    int hours = offset.inHours;
    int minutes = offset.inMinutes.remainder(60);

    String sign = hours >= 0 ? '+' : '-';
    String formattedTimeZone =
        "GMT$sign${hours.abs().toString().padLeft(2, '0')}:${minutes.abs().toString().padLeft(2, '0')}";

    return formattedTimeZone;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).userModel;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
        surfaceTintColor: Colors.white,
        title: Text(
          "Settings",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold
          ),
        ),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.logout_rounded, size: 20, color: Colors.red,))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //profile settings
              Column(
                children: [
                  Container(
                    height: 55,
                    width: MediaQuery.of(context).size.width,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: InkWell(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileSettings(userInfo: user)));
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 55,
                                width: 55,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  shape: BoxShape.circle
                                ),
                                child: user.image.isEmpty ? Center(
                                  child: Icon(IconlyBold.profile, color: Colors.grey, size: 20,),
                                ) : Image.network(user.image, fit: BoxFit.cover, errorBuilder: (context, err, st) {
                                  return Center(
                                    child: Icon(IconlyBold.profile, color: Colors.grey, size: 20,),
                                  );
                                },),
                              ),
                              const SizedBox(width: 10,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${user.firstName} ${user.lastName} ${user.otherNames}",
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    "Profile Settings",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12
                                    ),
                                  ),
                                  RichText(text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Last Updated At: ",
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.blueGrey
                                        )
                                      ),
                                      TextSpan(
                                        text: DateFormat.yMMMd().format(user.updatedAt!),
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.blueGrey
                                        )
                                      ),
                                    ]
                                  ))
                                ],
                              )
                            ],
                          ),
                          Spacer(),
                          Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey, size: 13,)
                        ],
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20,),
              //app settings
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "APP",
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey
                    ),
                  ),
                  const SizedBox(height: 5,),
                  SettingsOptionCardStyleOne(iconTwo: Icon(IconlyBold.lock, size: 14, color: Color(AppColors.primaryColor),), title: "Security", isValueColored: false, hasSwitch: false, onClick: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SecuritySettingsScreen()));
                  }, icon: '',),
                  SettingsOptionCardStyleOne(icon: AppIcons.notificationSettingsIcons, title: "Notification Settings", isValueColored: false, hasSwitch: false, onClick: (){},),
                ],
              ),
              const SizedBox(height: 20,),
              //invite section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "INVITE YOUR FAMILY AND FRIENDS",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  ReferralSection(),
                ],
              ),
              const SizedBox(height: 20,),
              //system settings group
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "SYSTEM SETTINGS",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey
                    ),
                  ),
                  const SizedBox(height: 5,),
                  SettingsOptionCardStyleOne(icon: "", title: "Currency", isValueColored: false, hasSwitch: false, onClick: (){}, value: "NGN",iconTwo: Icon(Icons.money, size: 14, color: Color(AppColors.primaryColor),)),
                  SettingsOptionCardStyleOne(icon: "", title: "Language", isValueColored: false, hasSwitch: false, onClick: (){}, value: "English",iconTwo: Icon(Icons.language, size: 14, color: Color(AppColors.primaryColor),)),
                  SettingsOptionCardStyleOne(icon: "", title: "FAQ", isValueColored: false, hasSwitch: false, onClick: (){},iconTwo: Icon(Icons.help, size: 14, color: Color(AppColors.primaryColor),)),
                  SettingsOptionCardStyleOne(icon: "", title: "Time", isValueColored: false, hasSwitch: false, onClick: (){}, value: "${getTimeZone()}",iconTwo: Icon(IconlyBold.time_circle, size: 14, color: Color(AppColors.primaryColor),)),

                ],
              ),
              const SizedBox(height: 20,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "SEND US A REVIEW",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: 44,
                    width: MediaQuery.of(context).size.width,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(8)),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                      height: 38,
                                      width: 38,
                                      decoration: BoxDecoration(
                                          color: const Color(AppColors.primaryColor)
                                              .withOpacity(0.3),
                                          shape: BoxShape.circle),
                                      child: Image.asset(
                                          "images/casual-life-3d-first-place-badge-1.png")),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Write a Review",
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.black),
                                      ),
                                      Text(
                                        "Write us a review on play store or appstore",
                                        style: TextStyle(
                                            fontSize: 10, color: Colors.grey),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              const Spacer(),
                              Icon(
                                Icons.arrow_right_alt,
                                size: 20,
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: MaterialButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const WriteUsAReviewScreen()));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              //customer care section
              const SizedBox(height: 20,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "CUSTOMER CARE",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  //customer care
                  Container(
                    height: 35,
                    width: MediaQuery.of(context).size.width,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(8)),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 25,
                                    width: 25,
                                    decoration: BoxDecoration(
                                        color: const Color(AppColors.primaryColor)
                                            .withOpacity(0.2),
                                        shape: BoxShape.circle),
                                    child: Center(
                                      child: Icon(
                                        Icons.headphones,
                                        size: 18,
                                        color: const Color(AppColors.primaryColor),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "Contact Us",
                                    style:
                                    TextStyle(fontSize: 12, color: Colors.black),
                                  )
                                ],
                              ),
                              Container(
                                height: 6,
                                width: 6,
                                decoration: const BoxDecoration(
                                    color: Colors.green, shape: BoxShape.circle),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: MaterialButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const HelpCenterScreen()));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
