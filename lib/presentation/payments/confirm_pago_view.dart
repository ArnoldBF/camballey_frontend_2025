import 'package:flutter/material.dart';
import 'package:camballey_frontend_2025/data/services/wallet_service.dart';

class ConfirmPagoView extends StatelessWidget {
  final String interno;
  final double monto;
  final int usuarioId;

  const ConfirmPagoView({
    super.key,
    required this.interno,
    required this.monto,
    required this.usuarioId,
  });

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
            // ...avatar y detalles...
            const Spacer(),
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
                onPressed: () async {
                  final transporteId = int.tryParse(interno);
                  if (transporteId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('ID de transporte inválido')),
                    );
                    return;
                  }
                  try {
                    final exito = await WalletService().pagar(monto, usuarioId, transporteId);
                    // if (!mounted) return;

                    if (exito) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Pago realizado con éxito')),
                      );
                      Navigator.of(context).pop<bool>(true);   // 👈 devuelve bool
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Error al realizar el pago')),
                      );
                    }
                  } catch (e) {
                    // if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                },
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
            // ...otros widgets...
          ],
        ),
      ),
    );
  }
}