import 'package:blaa/entity/user.dart';
import 'package:blaa/services/user_service.dart';
import 'package:blaa/widgets/shared/snack_bar_result_widget.dart';
import 'package:blaa/widgets/user/user_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class UserListWidget extends StatelessWidget {
  final String searchTerm;
  final bool showRecent;
  final Logger _logger = Logger('UserFormWidget');

  UserListWidget({
    super.key,
    required this.searchTerm,
    required this.showRecent,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<User>>(
      future:
          showRecent
              ? UserService().getRecentUsers()
              : UserService().getUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          _logger.severe('Error loading users', snapshot.error);
          showCustomSnackbar(
            context,
            'Ocurrió un error al cargar los usuarios.',
            false,
          );
          return const SizedBox();
        }

        final users = snapshot.data ?? [];

        final filteredUsers =
            users.where((user) {
              final name = user.fullName.toLowerCase();
              final email = user.email.toLowerCase();
              return name.contains(searchTerm) || email.contains(searchTerm);
            }).toList();

        if (filteredUsers.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 100, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  showRecent
                      ? 'No tienes conversaciones recientes'
                      : 'No se encontraron contactos',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                    fontFamily: 'Coolvetica',
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: filteredUsers.length,
          itemBuilder: (context, index) {
            final user = filteredUsers[index];
            return UserItemWidget(user: user, isRecent: showRecent);
          },
        );
      },
    );
  }
}
