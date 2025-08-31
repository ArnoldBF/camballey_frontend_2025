import 'package:flutter/material.dart';

class DriverTxn {
  final String label;
  final String amount;
  final int minutesAgo;
  final bool up;
  const DriverTxn({
    required this.label,
    required this.amount,
    required this.minutesAgo,
    required this.up,
  });
}

class RecentSection extends StatelessWidget {
  const RecentSection({super.key});

  @override
  Widget build(BuildContext context) {
    const items = [
      DriverTxn(label: 'Estudiante', amount: '1,00 Bs', minutesAgo: 0, up: true),
      DriverTxn(label: 'Adulto', amount: '2,30 Bs', minutesAgo: 1, up: true),
      DriverTxn(label: 'Niño', amount: '1,00 Bs', minutesAgo: 4, up: false),
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

class _RecentTile extends StatelessWidget {
  final DriverTxn txn;
  const _RecentTile({required this.txn});

  @override
  Widget build(BuildContext context) {
    final color = txn.up ? const Color(0xFF30D158) : Colors.redAccent;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Color(0x11000000), blurRadius: 8, offset: Offset(0, 4))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(txn.label, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text(
                'Hace ${txn.minutesAgo} ${txn.minutesAgo == 1 ? "Minuto" : "Minutos"}',
                style: const TextStyle(color: Colors.black45, fontSize: 12),
              ),
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
