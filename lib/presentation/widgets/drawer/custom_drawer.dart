import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final String currentRoute;

  const CustomDrawer({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Opções',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          // Dashboard Option
          ListTile(
            leading: Icon(
              Icons.filter_list,
              color: currentRoute == '/dashboard' ? Colors.blue : null,
            ),
            title: Text(
              'Dashboard',
              style: TextStyle(
                color: currentRoute == '/dashboard' ? Colors.blue : null,
                fontWeight:
                    currentRoute == '/dashboard' ? FontWeight.bold : null,
              ),
            ),
            onTap: currentRoute == '/dashboard'
                ? null
                : () {
                    Navigator.pop(context); // Fecha o Drawer
                    Navigator.pushReplacementNamed(
                      context,
                      '/dashboard',
                    );
                  },
          ),
          // Movies Option
          ListTile(
            leading: Icon(
              Icons.pages,
              color: currentRoute == '/movies' ? Colors.blue : null,
            ),
            title: Text(
              'Filmes',
              style: TextStyle(
                color: currentRoute == '/movies' ? Colors.blue : null,
                fontWeight: currentRoute == '/movies' ? FontWeight.bold : null,
              ),
            ),
            onTap: currentRoute == '/movies'
                ? null
                : () {
                    Navigator.pop(context); // Fecha o Drawer
                    Navigator.pushReplacementNamed(
                      context,
                      '/movies',
                    );
                  },
          ),
        ],
      ),
    );
  }
}
