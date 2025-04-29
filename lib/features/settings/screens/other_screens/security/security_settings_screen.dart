import 'package:boks/features/settings/screens/other_screens/security/account_pin_settings_screen.dart';
import 'package:boks/features/settings/screens/other_screens/security/update_password_screen.dart';
import 'package:boks/utility/shared_components/custom_back_button.dart';
import 'package:flutter/material.dart';

import '../../../../../utility/constants/app_colors.dart';
import '../../../components/settings_option_card_style_one.dart';

class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  State<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  bool isBiometricEnabled = false;

  void _onBiometricSwitchFlop(bool value) {
    setState(() {
      isBiometricEnabled = value;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: CustomBackButton(context: context),
        centerTitle: true,
        title: const Text(
          "Security",
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: SizedBox(
                height: 100,
                width: 100,
                child: Image.asset("images/splash_screen_logo.png")),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            SettingsOptionCardStyleOne(icon: "", title: "Password", isValueColored: false, hasSwitch: false, onClick: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const UpdatePasswordScreen()));
            },iconTwo: Icon(Icons.password, size: 14, color: Color(AppColors.primaryColor),)),
            SettingsOptionCardStyleOne(icon: "", title: "PIN", isValueColored: false, hasSwitch: false, onClick: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AccountPinSettingsScreen()));
            },iconTwo: Icon(Icons.lock, size: 14, color: Color(AppColors.primaryColor),)),
            SettingsOptionCardStyleOne(icon: "", title: "Biometric", isValueColored: false, hasSwitch: true, onClick: (){},iconTwo: Icon(Icons.fingerprint_rounded, size: 14, color: Color(AppColors.primaryColor),),
              switchValue: isBiometricEnabled,
              onFlip: _onBiometricSwitchFlop,),

          ],
        ),
      ),
    );
  }
}
