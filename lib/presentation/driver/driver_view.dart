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

class DriverView extends StatefulWidget {
  const DriverView({
    super.key,
    this.userId = 2,          // ID del chofer que recibirá saldoAbonado
    this.socketBaseUrl,       // p.ej. http://10.0.2.2:3000 | http://localhost:3000 | https://tu-dominio
  });

  final int userId;
  final String? socketBaseUrl;

  @override
  State<DriverView> createState() => _DriverViewState();
}

class _DriverViewState extends State<DriverView> {
  String _resolveSocketUrl() {
    // 1) Si te pasan una URL desde fuera, usa esa
    if (widget.socketBaseUrl != null && widget.socketBaseUrl!.isNotEmpty) {
      return widget.socketBaseUrl!;
    }
    // 2) Producción por defecto (Railway u otro host)
    const prod = 'https://camballeybacked2025-production.up.railway.app';
    // 3) Si estás en local:
    //    - Web/iOS/macOS/Windows: localhost
    //    - Android emulador: 10.0.2.2
    if (kIsWeb) return prod; // en web te conviene consumir el host público
    return prod;
  }

  @override
  void initState() {
    super.initState();
    final url = _resolveSocketUrl(); // ¡IMPORTANTE! No apuntes a /api ni a rutas REST
    SocketService.I.connect(
      baseUrl: url,    // EJEMPLO correcto: https://mi-backend.com  (sin /api)
      userId: widget.userId,
    );
  }

  @override
  void dispose() {
    SocketService.I.dispose();
    super.dispose();
  }

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
          AccountMenu(),
          SizedBox(width: 4),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: const [
          DriverHeader(name: 'José Armando', line: 'Línea 74'),
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
