import 'dart:convert';

import 'package:camballey_frontend_2025/data/services/auth_service.dart';
import 'package:camballey_frontend_2025/data/services/notification_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// UI fragmentada
import 'widgets/header.dart';
import 'widgets/earnings_card.dart';
import 'widgets/recent_section.dart';
import 'widgets/main_menu.dart';
import 'widgets/account_menu.dart';

// Socket
import 'package:camballey_frontend_2025/data/services/socket_service.dart';

// 👇 Notificaciones locales

class DriverView extends StatefulWidget {
  const DriverView({
    super.key,
    this.userId = 2,        // ID del chofer que recibirá saldoAbonado
    this.socketBaseUrl,     // p.ej. http://10.0.2.2:3000 | https://tu-dominio
  });

  final int userId;
  final String? socketBaseUrl;

  @override
  State<DriverView> createState() => _DriverViewState();
}

class _DriverViewState extends State<DriverView> {
  String _resolveSocketUrl() {
    if (widget.socketBaseUrl != null && widget.socketBaseUrl!.isNotEmpty) {
      return widget.socketBaseUrl!;
    }
    const prod = 'https://camballeybacked2025-production.up.railway.app';
    return prod;
  }

  @override
  void initState() {
    super.initState();

    final url = _resolveSocketUrl();
    SocketService.I.connect(baseUrl: url, userId: widget.userId);

    // ⬇️ Notificación + snackbar al recibir saldoAbonado
    SocketService.I.on('saldoAbonado', (raw) async {
      try {
        // Acepta Map o String JSON (y descarta bool/otros)
        Map<String, dynamic>? m;
        if (raw is Map) {
          m = Map<String, dynamic>.from(raw);
        } else if (raw is String) {
          final dec = json.decode(raw);
          if (dec is Map) m = Map<String, dynamic>.from(dec);
        } else {
          debugPrint('[SOCKET] saldoAbonado payload inesperado: ${raw.runtimeType}');
          return;
        }
        if (m == null) return;

        final targetId = (m['usuarioId'] as num?)?.toInt();
        if (targetId != null && targetId != widget.userId) {
          // El evento no es para este chofer
          debugPrint('[SOCKET] saldoAbonado para otro usuarioId=$targetId (yo=${widget.userId})');
          return;
        }

        final pasajero   = (m['pasajeroEmisor'] ?? 'Pasajero').toString();
        final monto      = (m['montoAbonado'] as num?)?.toDouble() ?? 0.0;
        final nuevoSaldo = (m['nuevoSaldo'] as num?)?.toDouble() ?? 0.0;

        // Notificación local (iOS/Android)
        if (!kIsWeb) {
          await NotificationService.instance.show(
            title: 'Saldo abonado',
            body: '$pasajero abonó Bs ${monto.toStringAsFixed(2)}. '
                  'Nuevo saldo: Bs ${nuevoSaldo.toStringAsFixed(2)}',
            payload: {
              'type': 'saldoAbonado',
              'monto': monto,
              'nuevoSaldo': nuevoSaldo,
              'pasajero': pasajero,
            },
          );
        }

        if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Pasajero: $pasajero abonó Bs ${monto.toStringAsFixed(2)}. '
                                  'Nuevo saldo: Bs ${nuevoSaldo.toStringAsFixed(2)}')),
          );
      } catch (e) {
        debugPrint('[SOCKET][saldoAbonado] error: $e');
      }
    });
  }

  @override
  void dispose() {
    SocketService.I.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final name = currentFullName ?? 'Usuario';

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: const Text('Conductor', style: TextStyle(color: Colors.black54)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black54),
        actions: const [AccountMenu(), SizedBox(width: 4)],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: const [
          // (cuando tengas los datos reales, sustitúyelos como ya vimos)
          DriverHeader(name: 'Usuario', line: 'Línea 74'),
          SizedBox(height: 14),
          EarningsCard(
            title: 'Viaje N°3',
            amount: '350,00 Bs',
            subtitle: 'Total Día',
            subAmount: '700,20 Bs',
          ),
          SizedBox(height: 18),
          RecentSection(),
          SizedBox(height: 16),
          DriverMainMenu(),
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
