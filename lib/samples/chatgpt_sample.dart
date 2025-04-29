import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

class ChatGPTSample extends StatefulWidget {
  @override
  _ChatGPTSampleState createState() => _ChatGPTSampleState();
}

class _ChatGPTSampleState extends State<ChatGPTSample> {
  final LocalAuthentication auth = LocalAuthentication();
  List<BiometricType> availableBiometrics = [];

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    try {
      final biometrics = await auth.getAvailableBiometrics();
      setState(() {
        availableBiometrics = biometrics;
      });
    } catch (e) {
      debugPrint('Error checking biometrics: $e');
    }
  }

  Future<void> _authenticate(BiometricType type) async {
    try {
      final authenticated = await auth.authenticate(
        localizedReason: 'Use ${_biometricName(type)} to access the app',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (!mounted) return;

      if (authenticated) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Authentication failed')),
        );
      }
    } catch (e) {
      debugPrint('Authentication error: $e');
    }
  }

  String _biometricName(BiometricType type) {
    switch (type) {
      case BiometricType.face:
        return "Face ID";
      case BiometricType.fingerprint:
        return "Fingerprint";
      default:
        return "Biometric";
    }
  }

  void _showBiometricOptions() {
    if (availableBiometrics.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No biometrics available')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: availableBiometrics.map((type) {
            return ListTile(
              leading: Icon(type == BiometricType.face
                  ? Icons.face
                  : Icons.fingerprint),
              title: Text('Use ${_biometricName(type)}'),
              onTap: () {
                Navigator.pop(context);
                _authenticate(type);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Biometric Login')),
      body: Center(
        child: ElevatedButton(
          onPressed: _showBiometricOptions,
          child: const Text('Authenticate'),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(
        child: Text('Authenticated Successfully!', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
