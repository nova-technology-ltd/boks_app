import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class CoPilotSample extends StatelessWidget {
  final LocalAuthentication auth = LocalAuthentication();

  Future<bool> authenticate() async {
    try {
      return await auth.authenticate(
        localizedReason: 'Please authenticate to proceed',
        // biometricOnly: true,
      );
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Face ID App')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            bool isAuthenticated = await authenticate();
            if (isAuthenticated) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NextScreen()),
              );
            }
          },
          child: Text('Authenticate with Face ID'),
        ),
      ),
    );
  }
}

class NextScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Next Screen')),
      body: Center(child: Text('Welcome to the next screen!')),
    );
  }
}
