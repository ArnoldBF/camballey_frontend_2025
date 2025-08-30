import 'package:camballey_frontend_2025/data/services/auth_service.dart';
import 'package:camballey_frontend_2025/routes/app_router.dart';
import 'package:flutter/material.dart';

class DriverView extends StatelessWidget {
  const DriverView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: const Text('Conductor', style: TextStyle(color: Colors.black54)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black54),
        actions: const [
          _AccountMenu(),
          SizedBox(width: 4),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children:  [
          _Header(name: 'José Armando', line: 'Línea 74'),
          SizedBox(height: 14),
          const _EarningsCard(
            title: 'Viaje N°3',
            amount: '350,00 Bs',
            subtitle: 'Total Día',
            subAmount: '700,20 Bs',
          ),

          const SizedBox(height: 12),

          // ⬇️ Nuevo: fila con "Cobrar" y "Pagar"
          _ActionButtons(
            onCobrar: () {
              // TODO: navega a collect_screen.dart
              // Navigator.pushNamed(context, '/driver/collect');
            },
            onPagar: () {
              // TODO: navega a pay_screen.dart
              // Navigator.pushNamed(context, '/passenger/pay');
            },
          ),
          SizedBox(height: 18),
          _RecentSection(),
          SizedBox(height: 16),
          _MainMenu(),
          SizedBox(height: 24),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.apps),
      ),
    );
  }
}

/* ------------------------------ Secciones ------------------------------ */

class _Header extends StatelessWidget {
  final String name;
  final String line;
  const _Header({required this.name, required this.line});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(line, style: const TextStyle(color: Colors.black54)),
            ],
          ),
        ),
        Row(
          children: [
            Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFF30D158), shape: BoxShape.circle)),
            const SizedBox(width: 6),
            const Text('En línea', style: TextStyle(color: Colors.black54)),
          ],
        ),
      ],
    );
  }
}

class _EarningsCard extends StatelessWidget {
  final String title, amount, subtitle, subAmount;
  const _EarningsCard({required this.title, required this.amount, required this.subtitle, required this.subAmount});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF5B3CF6), Color(0xFF6E7BF6)]),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(blurRadius: 16, color: Color(0x335B3CF6), offset: Offset(0, 8))],
      ),
      padding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 8),
              Text(amount, style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w700)),
              const Spacer(),
              Row(
                children: [
                  Text(subtitle, style: const TextStyle(color: Colors.white70)),
                  const SizedBox(width: 8),
                  Text(subAmount, style: const TextStyle(color: Colors.white)),
                ],
              ),
            ],
          ),
          const Positioned(
            right: 8, bottom: 8,
            child: Icon(Icons.directions_bus_filled, size: 64, color: Colors.white24),
          ),
        ],
      ),
    );
  }
}

class _RecentSection extends StatelessWidget {
  const _RecentSection();

  @override
  Widget build(BuildContext context) {
    final items = const [
      _Txn(label: 'Estudiante', amount: '1,00 Bs', minutesAgo: 0, up: true),
      _Txn(label: 'Adulto', amount: '2,30 Bs', minutesAgo: 1, up: true),
      _Txn(label: 'Niño', amount: '1,00 Bs', minutesAgo: 4, up: false),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Reciente', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        ...items.map((e) => _RecentTile(txn: e)),
      ],
    );
  }
}

class _Txn {
  final String label;
  final String amount;
  final int minutesAgo;
  final bool up;
  const _Txn({required this.label, required this.amount, required this.minutesAgo, required this.up});
}

class _RecentTile extends StatelessWidget {
  final _Txn txn;
  const _RecentTile({required this.txn});

  @override
  Widget build(BuildContext context) {
    final color = txn.up ? const Color(0xFF30D158) : Colors.redAccent;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Color(0x11000000), blurRadius: 8, offset: Offset(0, 4))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(txn.label, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text('Hace ${txn.minutesAgo} ${txn.minutesAgo == 1 ? "Minuto" : "Minutos"}',
                  style: const TextStyle(color: Colors.black45, fontSize: 12)),
            ]),
          ),
          Text(txn.amount, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(width: 8),
          Icon(txn.up ? Icons.arrow_drop_up : Icons.arrow_drop_down, color: color),
        ],
      ),
    );
  }
}

class _MainMenu extends StatelessWidget {
  const _MainMenu();

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


class _ActionButtons extends StatelessWidget {
  final VoidCallback onCobrar;
  final VoidCallback onPagar;
  const _ActionButtons({required this.onCobrar, required this.onPagar});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: onCobrar,
            icon: const Icon(Icons.point_of_sale),
            label: const Text('Cobrar'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onPagar,
            icon: const Icon(Icons.payments_outlined),
            label: const Text('Pagar'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              side: BorderSide(color: scheme.primary, width: 1.6),
              foregroundColor: scheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}


class _AccountMenu extends StatelessWidget {
  const _AccountMenu();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_AccountAction>(
      tooltip: 'Cuenta',
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (value) async {
        switch (value) {
          case _AccountAction.profile:
            // TODO: ir a pantalla de perfil si la tienes
            Navigator.pushNamed(context, Routes.profile);
            break;
          case _AccountAction.logout:
            final ok = await _confirmLogout(context);
            if (ok == true) {
              final auth = AuthService();
              await auth.signOut();
              if (context.mounted) {
                // Vuelve al login y limpia el stack
                Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
              }
            }
            break;
        }
      },
      itemBuilder: (ctx) => [
        const PopupMenuItem(
          value: _AccountAction.profile,
          child: ListTile(
            leading: Icon(Icons.person_outline),
            title: Text('Perfil'),
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: _AccountAction.logout,
          child: ListTile(
            leading: Icon(Icons.logout),
            title: Text('Cerrar sesión'),
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: CircleAvatar(
          radius: 18,
          backgroundColor: const Color(0xFFEEF2FF),
          child: Icon(Icons.person, color: Theme.of(context).colorScheme.primary),
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
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
        FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Salir')),
      ],
    ),
  );
}