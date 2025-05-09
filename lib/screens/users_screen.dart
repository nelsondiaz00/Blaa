import 'package:blaa/services/auth_service.dart';
import 'package:blaa/widgets/user/user_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:blaa/entity/user.dart';
import 'package:flutter/services.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  User? _user;
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await AuthService().getUserLogged();
    if (mounted) {
      setState(() {
        _user = user;
      });
    }
  }

  void _navigateToProfile() {
    Navigator.pushNamed(context, '/profile', arguments: _user);
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchTerm = value.toLowerCase();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        SystemNavigator.pop();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFFF4FC),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: const Color(0xFFF8045C),
            title: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              style: const TextStyle(
                fontSize: 18,
                fontFamily: 'Coolvetica',
                color: Colors.white,
                letterSpacing: 1.8,
              ),
              decoration: InputDecoration(
                hintText: 'Buscar por nombre o email',
                hintStyle: const TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                  fontFamily: 'Coolvetica',
                  letterSpacing: 1.2,
                ),
                border: InputBorder.none,
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: _navigateToProfile,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage:
                        Uri.tryParse(_user?.photoUrl ?? '')?.isAbsolute == true
                            ? NetworkImage(_user!.photoUrl)
                            : null,
                    child:
                        _user?.photoUrl.isEmpty ?? true
                            ? const Icon(Icons.person, color: Color(0xFFF00A5E))
                            : null,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.exit_to_app, color: Colors.white),
                onPressed: () async {
                  await AuthService().logout();
                  if (!context.mounted) return;
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            SizedBox(height: 10),
            Expanded(
              child: UserListWidget(
                searchTerm: _searchTerm,
                showRecent: _selectedIndex == 1,
              ),
            ),
          ],
        ),

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(0xFFF8045C),
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.contacts),
              label: 'Contactos',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chats'),
          ],
        ),
      ),
    );
  }
}
