import 'package:blaa/services/auth_service.dart';
import 'package:blaa/widgets/shared/loading_icon_widget.dart';
import 'package:blaa/widgets/shared/snack_bar_result_widget.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({super.key});

  @override
  LoginFormWidgetState createState() => LoginFormWidgetState();
}

class LoginFormWidgetState extends State<LoginFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final Logger _logger = Logger('LoginFormWidget');
  final Color primaryColor = const Color(0xFFF00A5E);
  final Color inputBorderColor = const Color(0xFFEA6A8C);
  final Color backgroundColor = const Color.fromARGB(255, 255, 232, 241);
  final Color inputTextColor = const Color.fromARGB(255, 84, 0, 95);
  bool _isLoading = false;

  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Text(
                  'Iniciar sesión',
                  style: TextStyle(
                    fontFamily: 'Curly',
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '¡Bienvenido de nuevo!',
                  style: TextStyle(
                    fontFamily: 'Coolvetica',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: inputTextColor,
                  ),
                ),
                const SizedBox(height: 32),

                _buildTextFormField('Email', false, (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Por favor ingresa un email válido';
                  }
                  return null;
                }, (value) => email = value),

                const SizedBox(height: 16),

                _buildTextFormField('Contraseña', true, (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu contraseña';
                  }
                  return null;
                }, (value) => password = value),

                const SizedBox(height: 32),

                ElevatedButton(
                  onPressed:
                      _isLoading
                          ? null
                          : () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              setState(
                                () => _isLoading = true,
                              ); 
                              _logger.info('Email: $email');
                              _logger.info('Password: $password');

                              try {
                                final success = await AuthService().login(
                                  email!,
                                  password!,
                                );
                                if (!context.mounted) return;

                                if (success) {
                                  _logger.info('Login exitoso');
                                  showCustomSnackbar(
                                    context,
                                    'Inicio de sesión exitoso :)',
                                    true,
                                  );
                                  Navigator.pushReplacementNamed(
                                    context,
                                    '/messaging',
                                  );
                                } else {
                                  _logger.warning('Login fallido');
                                  showCustomSnackbar(
                                    context,
                                    'Inicio de sesión fallido :(',
                                    false,
                                  );
                                }
                              } catch (e) {
                                _logger.severe('Error: $e');
                                if (context.mounted) {
                                  showCustomSnackbar(
                                    context,
                                    'Error inesperado :(',
                                    false,
                                  );
                                }
                              } finally {
                                if (mounted) {
                                  setState(
                                    () => _isLoading = false,
                                  );
                                }
                              }
                            }
                          },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(200, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                      fontFamily: 'Coolvetica',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                  child:
                      _isLoading
                          ? const LoadingIcon(
                            icon: Icons.refresh,
                            size: 24,
                            color: Colors.white,
                          )
                          : const Text('Iniciar sesión'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(
    String label,
    bool obscureText,
    String? Function(String?) validator,
    Function(String?) onSaved,
  ) {
    return SizedBox(
      width: 300,
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            fontFamily: 'Coolvetica',
            color: inputTextColor,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: inputBorderColor, width: 1),
          ),
          errorStyle: TextStyle(fontFamily: 'Coolvetica', color: primaryColor),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: primaryColor, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: primaryColor, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 16,
          ),
        ),
        obscureText: obscureText,
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }
}
