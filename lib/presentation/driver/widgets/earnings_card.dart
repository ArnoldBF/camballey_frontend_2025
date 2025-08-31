import 'package:flutter/material.dart';

class EarningsCard extends StatelessWidget {
  final String title, amount, subtitle, subAmount;
  const EarningsCard({
    super.key,
    required this.title,
    required this.amount,
    required this.subtitle,
    required this.subAmount,
  });

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
          Positioned(
            right: 10,
            bottom: 8,
            child: Image.asset(
              '/images/Bus.png', // conserva tu ruta actual
              width: 250,
              height: 100,
              colorBlendMode: BlendMode.srcIn,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.directions_bus_filled,
                size: 64,
                color: Colors.white24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
