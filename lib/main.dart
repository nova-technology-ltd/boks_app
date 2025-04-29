import 'package:boks/chart_screen.dart';
import 'package:boks/features/demo_screen.dart';
import 'package:boks/features/home/bills/airtime/provider/airtime_provider.dart';
import 'package:boks/features/home/bills/betting/provider/selected_betting_service_provider.dart';
import 'package:boks/features/home/bills/data_bundle/provider/data_provider.dart';
import 'package:boks/features/home/bills/electricity/provider/selected_electricity_service_provider.dart';
import 'package:boks/features/home/bills/tv_and_cable/provider/selected_tv_and_cable_service_provider.dart';
import 'package:boks/features/home/screens/home_screen.dart';
import 'package:boks/features/settings/screens/other_screens/security/security_settings_screen.dart';
import 'package:boks/samples/chatgpt_sample.dart';
import 'package:boks/samples/copilot_sample.dart';
import 'package:boks/samples/deep_seek_sample.dart';
import 'package:boks/samples/gemini_sample.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/auth/service/auth_service.dart';
import 'features/home/bills/airtime/screens/airtime_screen.dart';
import 'features/profile/model/user_provider.dart';
import 'features/welcome/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => SelectedElectricityServiceProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => SelectedTvAndCableServiceProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => SelectedBettingServiceProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => AirtimeProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => DataProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => UserProvider(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthService(),
      child: Consumer<AuthService>(
        builder: (context, auth, _) => MaterialApp(
          title: 'Boks',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          home: const SplashScreen(),
          // home: const DemoScreen(),
          // home: SecuritySettingsScreen(),
        ),
      ),
    );
  }
}
