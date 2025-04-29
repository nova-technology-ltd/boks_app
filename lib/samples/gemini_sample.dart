import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

class AuthenticationScreen extends StatefulWidget {
  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics = false;
  List<BiometricType> _availableBiometrics = <BiometricType>[];
  String _authorized = 'Not Authorized';
  bool _isFaceUnlockAvailable = false;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
    _getAvailableBiometrics();
  }

  Future<void> _checkBiometrics() async {
    bool canCheck = false;
    try {
      canCheck = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _canCheckBiometrics = canCheck;
    });
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics = <BiometricType>[];
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
      _isFaceUnlockAvailable = availableBiometrics.contains(BiometricType.face) ||
          availableBiometrics.contains(BiometricType.strong) ||
          availableBiometrics.contains(BiometricType.weak); // Consider both strong and weak
    } on PlatformException catch (e) {
      print("Error getting available biometrics: $e");
    }
    if (!mounted) return;

    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }

  Future<void> _authenticateWithFaceUnlock() async {
    if (!_isFaceUnlockAvailable) {
      setState(() {
        _authorized = 'Face Unlock not available on this device.';
      });
      return;
    }

    bool authenticated = false;
    try {
      setState(() {
        _authorized = 'Authenticating with Face Unlock...';
      });
      authenticated = await auth.authenticate(
        localizedReason: 'Scan your face to proceed.',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      setState(() {
        _authorized = authenticated ? 'Authorized' : 'Not Authorized';
      });
    } on PlatformException catch (e) {
      print("Error during Face Unlock authentication: $e");
      setState(() {
        _authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) return;

    if (authenticated) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NextScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Face Unlock Authentication'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Can check biometrics: $_canCheckBiometrics\n'),
            Text('Available biometrics: $_availableBiometrics\n'),
            Text('Face Unlock potentially available: $_isFaceUnlockAvailable\n'),
            Text('Current state: $_authorized\n'),
            ElevatedButton(
              onPressed: _isFaceUnlockAvailable ? _authenticateWithFaceUnlock : null,
              child: const Text('Authenticate with Face Unlock'),
            ),
            if (!_isFaceUnlockAvailable)
              const Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Text(
                  'Face Unlock might not be available or configured on this device.',
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class NextScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Next Screen'),
      ),
      body: const Center(
        child: Text('You have successfully authenticated with Face Unlock!'),
      ),
    );
  }
}