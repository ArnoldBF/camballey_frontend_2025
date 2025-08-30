import 'package:flutter/material.dart';

class ConfirmPagoView extends StatelessWidget {
  final String interno;
  const ConfirmPagoView({super.key, required this.interno});

  @override
  Widget build(BuildContext context) {
    final primary = const Color(0xFF5B3CF6);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black54),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Text(
              '¿Desea Confirmar\nEl Pago?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: primary,
                fontWeight: FontWeight.w800,
                fontSize: 26,
                height: 1.15,
              ),
            ),
            const SizedBox(height: 28),

            // Bloque emisor → receptor
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _AvatarWithLabel(
                  name: 'Luis',
                  role: 'Enviador',
                  color: primary,
                  icon: Icons.person,
                ),
                Column(
                  children: [
                    Icon(Icons.arrow_right_alt, size: 48, color: primary),
                    Text('Interno: $interno',
                        style: const TextStyle(
                            color: Colors.black54, fontWeight: FontWeight.w600)),
                  ],
                ),
                _AvatarWithLabel(
                  name: 'Gregorio',
                  role: 'Receptor',
                  color: primary,
                  icon: Icons.directions_bus_filled,
                ),
              ],
            ),

            const Spacer(),

            // Botones
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Confirmar'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE74C3C),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {},
              child: const Text('Términos y Condiciones'),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _AvatarWithLabel extends StatelessWidget {
  final String name;
  final String role;
  final Color color;
  final IconData icon;
  const _AvatarWithLabel({
    required this.name,
    required this.role,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 36,
          backgroundColor: color.withOpacity(.12),
          child: Icon(icon, color: color, size: 36),
        ),
        const SizedBox(height: 8),
        Text(name, style: const TextStyle(color: Colors.black54)),
        Text(role,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
            )),
      ],
    );
  }
}
