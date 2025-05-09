import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class HomeWidget extends StatelessWidget {
  final Logger _logger = Logger('WelcomeWidget');

  final Color primaryColor = const Color(0xFFF00A5E);
  final Color backgroundColor = const Color.fromARGB(255, 255, 232, 241);

  HomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Image.asset('assets/images/logo.png', height: 120),
              const SizedBox(height: 16),

              Text(
                '¡Bienvenido!',
                style: TextStyle(
                  fontFamily: 'Curly',
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  _logger.info('Navigate to Login Screen');
                  Navigator.pushNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(
                    fontFamily: 'Coolvetica',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                  minimumSize: const Size(250, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Iniciar sesión'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _logger.info('Navigate to Sign Up Screen');
                  Navigator.pushNamed(context, '/sign-up');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: primaryColor,
                  side: BorderSide(color: primaryColor, width: 2),
                  textStyle: const TextStyle(
                    fontFamily: 'Coolvetica',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                  minimumSize: const Size(250, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Crear cuenta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
