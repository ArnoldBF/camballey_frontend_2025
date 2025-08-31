import 'package:flutter/material.dart';

class DriverActionButtons extends StatelessWidget {
  final VoidCallback onCobrar;
  final VoidCallback onPagar;
  const DriverActionButtons({super.key, required this.onCobrar, required this.onPagar});

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
