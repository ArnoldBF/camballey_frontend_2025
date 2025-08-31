import 'package:flutter/material.dart';

class DriverHeader extends StatelessWidget {
  final String name;
  final String line;
  const DriverHeader({super.key, required this.name, required this.line});

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
            Container(
              width: 10, height: 10,
              decoration: const BoxDecoration(color: Color(0xFF30D158), shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            const Text('En línea', style: TextStyle(color: Colors.black54)),
          ],
        ),
      ],
    );
  }
}
