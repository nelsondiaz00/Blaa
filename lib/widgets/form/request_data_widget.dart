import 'dart:io';
import 'package:blaa/services/user_service.dart';
import 'package:blaa/widgets/shared/loading_icon_widget.dart';
import 'package:blaa/widgets/shared/snack_bar_result_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';

class UserFormWidget extends StatefulWidget {
  const UserFormWidget({super.key});

  @override
  UserFormWidgetState createState() => UserFormWidgetState();
}

class UserFormWidgetState extends State<UserFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final Logger _logger = Logger('UserFormWidget');
  final UserService _userService = UserService();
  final ImagePicker _picker = ImagePicker();

  String? email;
  String? password;
  String? fullName;
  String? phoneNumber;
  String? position;
  File? _imageFile;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  final Color primaryColor = const Color(0xFFF00A5E);
  final Color inputBorderColor = const Color(0xFFEA6A8C);
  final Color backgroundColor = const Color.fromARGB(255, 255, 232, 241);
  final Color inputTextColor = const Color.fromARGB(255, 84, 0, 95);

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
                  'Crear cuenta',
                  style: TextStyle(
                    fontFamily: 'Curly',
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '¡Crea una cuenta para empezar mensajear ahora!',
                  style: TextStyle(
                    fontFamily: 'Coolvetica',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: inputTextColor,
                  ),
                ),
                const SizedBox(height: 32),

                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage:
                        _imageFile != null ? FileImage(_imageFile!) : null,
                    backgroundColor: Colors.white,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (_imageFile == null)
                          Icon(Icons.person, size: 80, color: primaryColor),
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.edit,
                              size: 20,
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                _buildTextFormField('Email', false, (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Por favor ingresa un email válido';
                  }
                  return null;
                }, (value) => email = value),

                const SizedBox(height: 16),

                _buildTextFormField('Contraseña', true, (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa una contraseña';
                  }
                  return null;
                }, (value) => password = value),

                const SizedBox(height: 16),

                _buildTextFormField('Nombre completo', false, (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu nombre completo';
                  }
                  return null;
                }, (value) => fullName = value),

                const SizedBox(height: 16),

                _buildTextFormField('Número de teléfono', false, (value) {
                  if (value == null || value.isEmpty || value.length < 10) {
                    return 'El número de teléfono debe tener al menos 10 dígitos';
                  }
                  return null;
                }, (value) => phoneNumber = value),

                const SizedBox(height: 16),

                SizedBox(
                  width: 300,
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Puesto',
                      labelStyle: TextStyle(
                        fontFamily: 'Coolvetica',
                        color: inputTextColor,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: inputBorderColor,
                          width: 1,
                        ),
                      ),
                      errorStyle: TextStyle(
                        fontFamily: 'Coolvetica',
                        color: primaryColor,
                      ),
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
                    value: position,
                    items:
                        [
                              'Software Engineer',
                              'Frontend Developer',
                              'Backend Developer',
                              'Full Stack Developer',
                              'DevOps Engineer',
                              'Quality Assurance Engineer',
                            ]
                            .map(
                              (String role) => DropdownMenuItem<String>(
                                value: role,
                                child: Text(
                                  role,
                                  style: TextStyle(
                                    fontFamily: 'Coolvetica',
                                    color: inputTextColor,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      setState(() {
                        position = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor selecciona un puesto';
                      }
                      return null;
                    },
                    onSaved: (value) => position = value,
                    style: TextStyle(
                      fontFamily: 'Coolvetica',
                      color: inputTextColor,
                      fontSize: 18,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                ElevatedButton(
                  onPressed:
                      _isLoading
                          ? null
                          : () async {
                            if (_formKey.currentState!.validate()) {
                              if (_imageFile == null) {
                                showCustomSnackbar(
                                  context,
                                  'Por favor selecciona una foto de perfil',
                                  false,
                                );
                                return;
                              }

                              _formKey.currentState!.save();
                              setState(() => _isLoading = true);

                              try {
                                final photoUrl = await _userService.uploadPhoto(
                                  _imageFile!.path,
                                );

                                if (photoUrl == null) {
                                  if (!context.mounted) return;
                                  showCustomSnackbar(
                                    context,
                                    'Error subiendo la foto :(',
                                    false,
                                  );
                                  return;
                                }

                                final result = await _userService.createAccount(
                                  email!,
                                  password!,
                                  fullName!,
                                  phoneNumber!,
                                  position!,
                                  photoUrl,
                                );

                                if (!context.mounted) return;

                                showCustomSnackbar(
                                  context,
                                  result
                                      ? 'Cuenta creada exitosamente :)'
                                      : 'Tuvimos problemas al crear tu cuenta :(',
                                  result,
                                );

                                if (result) {
                                  setState(() {
                                    email = '';
                                    password = '';
                                    fullName = '';
                                    phoneNumber = '';
                                    position = null;
                                    _imageFile = null;
                                  });

                                  _formKey.currentState!.reset();
                                }
                              } catch (e) {
                                _logger.severe('Error: $e');
                                if (context.mounted) {
                                  showCustomSnackbar(
                                    context,
                                    'Ocurrió un error inesperado :(',
                                    false,
                                  );
                                }
                              } finally {
                                if (mounted) {
                                  setState(() => _isLoading = false);
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
                          : const Text('Crear cuenta'),
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
