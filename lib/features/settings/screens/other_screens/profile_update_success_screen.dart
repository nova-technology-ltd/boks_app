import 'package:boks/utility/shared_components/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utility/constants/app_colors.dart';
import '../../../auth/service/auth_service.dart';

class ProfileUpdateSuccessScreen extends StatefulWidget {
  const ProfileUpdateSuccessScreen({super.key});

  @override
  State<ProfileUpdateSuccessScreen> createState() => _ProfileUpdateSuccessScreenState();
}

class _ProfileUpdateSuccessScreenState extends State<ProfileUpdateSuccessScreen> {
  final AuthService _authService = AuthService();
  @override
  void initState() {

    _authService.userProfile(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: const Color(AppColors.primaryColor).withOpacity(0.8),
                shape: BoxShape.circle
              ),
              child: const Center(
                child: Icon(Icons.check, color: Colors.white,),
              ),
            ),
            const SizedBox(height: 10,),
            const Text(
              "Profile Updated",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500
              ),
            ),
            const Text(
              "You have successfully updated your profile information",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey
              ),
            ),
            const Spacer(),
            CustomButton(title: "Done", onClick: (){
              Navigator.pop(context);
              Navigator.pop(context);
            }, isLoading: false,)
          ],
        ),
      ),
    );
  }
}
