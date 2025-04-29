import 'package:boks/features/settings/service/settings_service.dart';
import 'package:boks/utility/shared_components/custom_back_button.dart';
import 'package:boks/utility/shared_components/show_snack_bar.dart';
import 'package:flutter/material.dart';

import '../../../../../utility/constants/app_colors.dart';
import '../../../../../utility/shared_components/custom_button.dart';
import '../../../../auth/service/auth_service.dart';
import '../profile_update_success_screen.dart';

class AccountPinSettingsScreen extends StatefulWidget {
  const AccountPinSettingsScreen({super.key});

  @override
  State<AccountPinSettingsScreen> createState() => _AccountPinSettingsScreenState();
}

class _AccountPinSettingsScreenState extends State<AccountPinSettingsScreen> {
  String accountPIN = "";
  AuthService authService = AuthService();
  final SettingsService _settingsService = SettingsService();

  Widget otpButtons(int numbers) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: SizedBox(
        height: 60,
        width: 100,
        child: GestureDetector(
          onTap: () {
            setState(() {
              if (accountPIN.length < 4) {
                accountPIN += numbers.toString();
              }
            });
          },
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  border:
                  Border.all(width: 1, color: Colors.grey.withOpacity(0.2)),
                  borderRadius: BorderRadius.circular(15)),
              child: Center(
                child: Text(
                  numbers.toString(),
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              )),
        ),
      ),
    );
  }

  bool isLoading = false;

  Future<void> _createAccountPIN(BuildContext context) async {
    print("GO");
    try {
      setState(() {
        isLoading = true;
      });
      int data = int.parse(accountPIN);
      int response = await _settingsService.setAccountPIN(context, data);
      debugPrint(response.toString());
      if (response == 200 || response == 201) {
        setState(() {
          isLoading = false;
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ProfileUpdateSuccessScreen()));
        });
        await authService.userProfile(context);
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              automaticallyImplyLeading: false,
              leading: CustomBackButton(context: context),
              centerTitle: true,
              title: const Text(
                "Account PIN",
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
            body: Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(4, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3.0),
                          child: Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                              color: index < accountPIN.length
                                  ? const Color(AppColors.primaryColor)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  width: 1,
                                  color: index < accountPIN.length
                                      ? const Color(AppColors.primaryColor)
                                      : Colors.grey.withOpacity(0.3)),
                              boxShadow: [
                                BoxShadow(
                                  color: index < accountPIN.length
                                      ? const Color(AppColors.primaryColor)
                                      .withOpacity(0.3)
                                      : Colors.transparent,
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  offset: const Offset(1, 5),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                index < accountPIN.length
                                    ? accountPIN[index]
                                    : "",
                                style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                const Spacer(),
                for (int i = 0; i < 3; i++)
                  accountPIN.length == 4
                      ? const SizedBox.shrink()
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                        3, (index) => otpButtons(1 + 3 * i + index))
                        .toList(),
                  ),
                accountPIN.length == 4
                    ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: CustomButton(
                    title: "Set PIN",
                    onClick: () => _createAccountPIN(context), isLoading: isLoading ? true : false,
                  ),
                )
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(3),
                      child: SizedBox(
                        height: 60,
                        width: 100,
                        child: GestureDetector(
                            onTap: () {
                              setState(() {});
                            },
                            child: const Text("")),
                      ),
                    ),
                    otpButtons(0),
                    Padding(
                      padding: const EdgeInsets.all(3),
                      child: SizedBox(
                        height: 60,
                        width: 100,
                        child: GestureDetector(
                            onTap: () {
                              setState(() {
                                accountPIN = accountPIN.substring(
                                    0, accountPIN.length - 1);
                              });
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: Colors.transparent),
                              child: const Center(
                                child: Icon(
                                  Icons.backspace,
                                  color: Colors.grey,
                                ),
                              ),
                            )),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          if (isLoading)
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.05)),
            )
        ],
      ),
    );
  }
}
