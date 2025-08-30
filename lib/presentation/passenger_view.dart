import 'package:flutter/material.dart';

class PassengerView extends StatelessWidget {
  const PassengerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: const Text('Home Pasajero', style: TextStyle(color: Colors.black54)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black54),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: const [
          _Header(name: 'Lourdes Fátima', role: 'Estudiante'),
          SizedBox(height: 14),
          _BalanceCard(
            balance: '43,50 Bs.',
            account: '7513213686',
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
  final String role;
  const _Header({required this.name, required this.role});

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
              Text(role, style: const TextStyle(color: Colors.black54)),
            ],
          ),
        ),
        Row(
          children: [
            Container(width: 10, height: 10,
              decoration: const BoxDecoration(color: Color(0xFF30D158), shape: BoxShape.circle)),
            const SizedBox(width: 6),
            const Text('En línea', style: TextStyle(color: Colors.black54)),
          ],
        ),
      ],
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final String balance;
  final String account;
  const _BalanceCard({required this.balance, required this.account});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
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
              const Text('Saldo', style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 6),
              Text(balance, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700)),
              const Spacer(),
              const Text('Cuenta', style: TextStyle(color: Colors.white70)),
              Text(account, style: const TextStyle(color: Colors.white)),
            ],
          ),
          const Positioned(
            right: 8, bottom: 8,
            child: Icon(Icons.person, size: 72, color: Colors.white24),
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
      _Txn(title: 'Línea 38', amount: '-1,00 Bs', minutesAgo: 30),
      _Txn(title: 'Trufi Toborochi', amount: '-2,00 Bs', minutesAgo: 15),
      _Txn(title: 'Línea 74', amount: '-1,00 Bs', minutesAgo: 60 * 24), // 1 día
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
  final String title;
  final String amount;
  final int minutesAgo;
  const _Txn({required this.title, required this.amount, required this.minutesAgo});
}

class _RecentTile extends StatelessWidget {
  final _Txn txn;
  const _RecentTile({required this.txn});

  String _timeLabel(int minutes) {
    if (minutes < 60) return 'Hace $minutes Minutos';
    final days = (minutes / 1440).floor();
    if (days >= 1) return 'Hace ${days} Días';
    final hours = (minutes / 60).floor();
    return 'Hace $hours Horas';
  }

  @override
  Widget build(BuildContext context) {
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
              Text(_timeLabel(txn.minutesAgo), style: const TextStyle(color: Colors.black45, fontSize: 12)),
              const SizedBox(height: 2),
              Text(txn.title, style: const TextStyle(fontWeight: FontWeight.w600)),
            ]),
          ),
          Text(txn.amount, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_drop_down, color: Colors.redAccent),
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
      _QuickItem(icon: Icons.emergency_share, label: 'Emergencia'),
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
      onTap: () {}, // conecta acciones
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
