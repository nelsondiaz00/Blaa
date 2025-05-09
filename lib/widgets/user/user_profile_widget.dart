import 'package:blaa/entity/user.dart';
import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  final User user;

  const ProfileWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 60),
            Center(
              child: CircleAvatar(
                radius: 130,
                backgroundColor: const Color(0xFFF2377C),
                backgroundImage: NetworkImage(user.photoUrl),
                child:
                    user.photoUrl.isEmpty ||
                            Uri.tryParse(user.photoUrl)?.isAbsolute == false
                        ? Icon(Icons.person, size: 50, color: Colors.white)
                        : null,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              user.fullName,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Coolvetica',
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 84, 0, 95),
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              user.position,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Coolvetica',
                fontSize: 20,
                fontStyle: FontStyle.italic,
                color: const Color.fromARGB(150, 84, 0, 95),
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 24),
            _buildProfileRow('Correo Electrónico', user.email),
            const SizedBox(height: 16),
            _buildProfileRow('Número de Teléfono', user.phoneNumber),
            const SizedBox(height: 16),
            _buildProfileRow(
              'Miembro desde',
              '${user.createdAt.day}/${user.createdAt.month}/${user.createdAt.year}',
            ),
            const Spacer(),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/chat', arguments: user);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF2377C),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      SizedBox(width: 5),
                      Text(
                        'Ir al chat',
                        style: TextStyle(
                          fontFamily: 'Coolvetica',
                          fontSize: 18,
                          color: Colors.white,
                          letterSpacing: 1.5,
                        ),
                      ),
                      SizedBox(width: 9),
                      Icon(Icons.send_rounded, color: Colors.white, size: 22),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontFamily: 'Coolvetica',
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color.fromARGB(255, 84, 0, 95),
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: 'Coolvetica',
                fontSize: 16,
                color: Color.fromARGB(150, 84, 0, 95),
                letterSpacing: 1.2,
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
