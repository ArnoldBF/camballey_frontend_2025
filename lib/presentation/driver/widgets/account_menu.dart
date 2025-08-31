import 'package:flutter/material.dart';
import 'package:camballey_frontend_2025/data/services/auth_service.dart';
import 'package:camballey_frontend_2025/routes/app_router.dart';

class AccountMenu extends StatelessWidget {
  const AccountMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_AccountAction>(
      tooltip: 'Cuenta',
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (value) async {
        switch (value) {
          case _AccountAction.profile:
            Navigator.pushNamed(context, Routes.profile);
            break;
          case _AccountAction.logout:
            final ok = await _confirmLogout(context);
            if (ok == true) {
              final auth = AuthService();
              await auth.signOut();
              if (context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
              }
            }
            break;
        }
      },
      itemBuilder: (ctx) => const [
        PopupMenuItem(
          value: _AccountAction.profile,
          child: ListTile(
            leading: Icon(Icons.person_outline),
            title: Text('Perfil'),
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
        PopupMenuDivider(),
        PopupMenuItem(
          value: _AccountAction.logout,
          child: ListTile(
            leading: Icon(Icons.logout),
            title: Text('Cerrar sesión'),
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: CircleAvatar(
          radius: 18,
          backgroundColor: Color(0xFFEEF2FF),
          child: Icon(Icons.person, color: Colors.deepPurple),
        ),
      ),
    );
  }
}

enum _AccountAction { profile, logout }

Future<bool?> _confirmLogout(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Cerrar sesión'),
      content: const Text('¿Deseas salir de tu cuenta?'),
      actions: [
        ElevatedButton(
          style: TextButton.styleFrom(
            foregroundColor: Color(0xFF5B3CF6), // color primario
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Color(0xFF5B3CF6),
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Salir'),
        ),
      ],
    ),
  );
}
