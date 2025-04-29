import 'package:local_auth/local_auth.dart';
import 'package:flutter/material.dart';

class DeepSeekSample extends StatelessWidget {
  const DeepSeekSample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Biometric Auth')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.fingerprint, size: 80),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Authenticate with Face ID'),
              onPressed: () async {
                final hasBiometrics = await BiometricAuth.hasBiometrics();
                if (hasBiometrics) {
                  final authenticated = await BiometricAuth.authenticate();
                  if (authenticated) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const NextScreen()),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No biometrics available')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class NextScreen extends StatelessWidget {
  const NextScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Secure Screen')),
      body: const Center(
        child: Text('🎉 Successfully Authenticated!',
            style: TextStyle(fontSize: 24)),
      ),
    );
  }
}

class BiometricAuth {
  static final _auth = LocalAuthentication();

  static Future<bool> hasBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> authenticate() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Authenticate to access secure content',
        options: const AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      return false;
    }
  }
}