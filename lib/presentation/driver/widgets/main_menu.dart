import 'package:flutter/material.dart';

class DriverMainMenu extends StatelessWidget {
  const DriverMainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    const items = [
      _QuickItem(icon: Icons.receipt_long, label: 'Historial'),
      _QuickItem(icon: Icons.sync_alt, label: 'Transferir'),
      _QuickItem(icon: Icons.route, label: 'Rutas'),
      _QuickItem(icon: Icons.account_balance_wallet, label: 'Recargar'),
      _QuickItem(icon: Icons.notifications_none, label: 'Notificaciones'),
      _QuickItem(icon: Icons.support_agent, label: 'Soporte'),
    ];
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Color(0x11000000), blurRadius: 10, offset: Offset(0, 6))],
      ),
      padding: const EdgeInsets.all(12),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1.15),
        itemBuilder: (_, i) => _Tile(item: items[i]),
      ),
    );
  }
}

class _QuickItem {
  final IconData icon;
  final String label;
  const _QuickItem({required this.icon, required this.label});
}

class _Tile extends StatelessWidget {
  final _QuickItem item;
  const _Tile({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {}, // conecta acciones aquí
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFFF3F5FF), borderRadius: BorderRadius.circular(16)),
            child: Icon(item.icon),
          ),
          const SizedBox(height: 8),
          Text(item.label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
