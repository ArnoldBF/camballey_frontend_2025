import 'package:camballey_frontend_2025/data/services/api_client.dart';
import 'package:camballey_frontend_2025/data/services/auth_service.dart';
import 'package:camballey_frontend_2025/presentation/payments/multi_pagos.dart';
import 'package:camballey_frontend_2025/data/services/wallet_service.dart';
import 'package:flutter/material.dart';

// nuevas importaciones
import 'package:camballey_frontend_2025/presentation/payments/popup_pago.dart';
import 'package:camballey_frontend_2025/presentation/payments/confirm_pago_view.dart';
import 'package:camballey_frontend_2025/data/services/auth_service.dart' show currentFullName;

class PassengerView extends StatelessWidget {
  const PassengerView({super.key});

  static const _purple = Color(0xFF5B3CF6);

  @override
  Widget build(BuildContext context) {
    final name = currentFullName ?? 'Usuario';
    final monto = 2.5; // Puedes obtenerlo dinámicamente si lo necesitas
    final usuarioId = ApiClient.currentUserId ?? 0; // Usa el ID del usuario autenticado
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: const Text('Pasajero', style: TextStyle(color: Colors.black54)),
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
        children: [
          _Header(name: name, role: 'Estudiante'),
          const SizedBox(height: 14),
          _BalanceCard(account: '43,50 Bs.', userId: 351957),
          const SizedBox(height: 14),

          _ActionButtons(
            onCobrar: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MultiPagosPage()),
              );
            },
            onPagar: () async {
              final interno = await showPopupPago(context, monto: monto, usuarioId: usuarioId);
              if (interno == null || interno.isEmpty) return;

              if (!context.mounted) return;
              final confirmed = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                   builder: (_) => ConfirmPagoView(
                    interno: interno,
                    monto: monto,
                    usuarioId: usuarioId,
                  ),
                ),
              );

          //   final interno = await showPopupPago(context, monto: monto, usuarioId: usuarioId);
          //   if (interno == null) return;

          //   // Confirmación y pago
          //   final result = await Navigator.push<Map<String, dynamic>?>(
          //     context,
          //     MaterialPageRoute(
          //       builder: (_) => ConfirmPagoView(
          //         interno: interno,
          //         monto: monto,
          //         usuarioId: usuarioId,
          //     ),
          //   ),
          // );

          // if (!context.mounted) return;

          //    // Si el pago fue exitoso y tienes respuesta con saldo abonado
          //     final confirmed = await Navigator.push<bool>(
          //       context,
          //       MaterialPageRoute(
          //         builder: (_) => ConfirmPagoView(
          //           interno: interno,
          //           monto: monto,
          //           usuarioId: usuarioId,
          //         ),
          //       ),
          //     );

          //     if (!context.mounted) return;
          //     if (confirmed == true) {
          //       ScaffoldMessenger.of(context).showSnackBar(
          //         const SnackBar(content: Text('Pago confirmado')),
          //       );
          //     }
            },
          ),

          const SizedBox(height: 18),
          const _RecentSection(),
          const SizedBox(height: 16),
          const _MainMenu(),
          const SizedBox(height: 24),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _purple,
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
              Text(name,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(role,
                  style: const TextStyle(
                      color: Colors.black54, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        Row(
          children: [
            Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                    color: Color(0xFF30D158), shape: BoxShape.circle)),
            const SizedBox(width: 6),
            const Text('En línea', style: TextStyle(color: Colors.black54)),
          ],
        ),
      ],
    );
  }
}

class _BalanceCard extends StatefulWidget {
       final String account;   
   // ej: 'Cuenta 123-456'
       final int? userId;      
      const _BalanceCard({super.key, required this.account, this.userId});
  @override
  State<_BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<_BalanceCard> {
  late Future<double> _future;
  // double? balance;
  
  @override
  void initState() {
    super.initState();
    final svc = WalletService();
    // debugPrint('[BALANCE] param.userId=${widget.userId} token.userId=${ApiClient.currentUserId}');
    // _future = (widget.userId != null)
    //     ? svc.getBalanceByUserId(widget.userId!)
    //     : svc.getMyBalance();
      debugPrint('[BALANCE] forcing token id. param.userId=${widget.userId} token.userId=${ApiClient.currentUserId}');
    _future = svc.getMyBalance(); // <-- SIEMPRE usa el ID del JWT
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<double>(
      future: _future,
      builder: (context, snap) {
        final isLoading = snap.connectionState == ConnectionState.waiting;
        final hasError  = snap.hasError;
        final amount    = snap.data ?? 0.0;

        final balanceText = hasError
            ? 'Error'
            : isLoading
                ? 'Cargando...'
                : 'Bs ${amount.toStringAsFixed(2)}';

        return Container(
          height: 180,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF5B3CF6), Color(0xFF6E7BF6)],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
            borderRadius: BorderRadius.circular(22),
            boxShadow: const [
              BoxShadow(
                blurRadius: 18,
                color: Color(0x335B3CF6),
                offset: Offset(0, 10),
              ),
            ],
          ),
          padding: const EdgeInsets.all(18),
          child: Stack(
            children: [
              // decoración
              Positioned.fill(child: IgnorePointer(child: CustomPaint(painter: _LinePainter()))),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Saldo', style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 6),
                  Text(
                    balanceText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                  const Text('Cuenta', style: TextStyle(color: Colors.white70)),
                  Text(widget.account, style: const TextStyle(color: Colors.white)),
                ],
              ),
              const Positioned(
                right: 8,
                bottom: 8,
                child: Icon(Icons.person, size: 80, color: Colors.white24),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Colors.white.withOpacity(.35)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    final path = Path();
    path.moveTo(12, size.height * .65);
    path.cubicTo(size.width * .25, size.height * .55, size.width * .35,
        size.height * .8, size.width * .55, size.height * .5);
    path.cubicTo(size.width * .7, size.height * .3, size.width * .8,
        size.height * .75, size.width - 12, size.height * .35);
    canvas.drawPath(path, p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ActionButtons extends StatelessWidget {
  final VoidCallback onCobrar;
  final VoidCallback onPagar;
  const _ActionButtons({required this.onCobrar, required this.onPagar});

  @override
  Widget build(BuildContext context) {
    const purple = PassengerView._purple;
    final style = FilledButton.styleFrom(
      backgroundColor: purple,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: const TextStyle(fontWeight: FontWeight.w700),
    );

    return Row(
      children: [
        Expanded(
          child: FilledButton(
            onPressed: onCobrar,
            style: style,
            child: const Text('PAGO MULTIPLE'),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: FilledButton(
            onPressed: onPagar,
            style: style,
            child: const Text('PAGAR'),
          ),
        ),
      ],
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
      _Txn(title: 'Línea 74', amount: '-1,00 Bs', minutesAgo: 60 * 24),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 6),
        const Text('Reciente',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        ...items.map((e) => _RecentTile(txn: e)),
      ],
    );
  }
}

class _Txn {
  final String title;
  final String amount;
  final int minutesAgo;
  const _Txn(
      {required this.title, required this.amount, required this.minutesAgo});
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
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Color(0x11000000), blurRadius: 10, offset: Offset(0, 6))
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_timeLabel(txn.minutesAgo),
                      style:
                          const TextStyle(color: Colors.black45, fontSize: 12)),
                  const SizedBox(height: 2),
                  Text(txn.title,
                      style:
                          const TextStyle(fontWeight: FontWeight.w700)),
                ]),
          ),
          _AmountPill(text: txn.amount),
        ],
      ),
    );
  }
}

class _AmountPill extends StatelessWidget {
  final String text;
  const _AmountPill({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(text, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFFFFEDF0),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(Icons.arrow_drop_down, color: Colors.redAccent),
        ),
      ],
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 6),
        const Text('Menú',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                  color: Color(0x11000000), blurRadius: 10, offset: Offset(0, 6))
            ],
          ),
          padding: const EdgeInsets.all(12),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.1,
            ),
            itemBuilder: (_, i) => _Tile(item: items[i]),
          ),
        ),
      ],
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
      onTap: () {},
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F5FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(item.icon, color: PassengerView._purple),
          ),
          const SizedBox(height: 8),
          Text(item.label,
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
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
            break;
          case _AccountAction.logout:
            final ok = await _confirmLogout(context);
            if (ok == true) {
              final auth = AuthService();
              await auth.signOut();
              if (context.mounted) {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/', (route) => false);
              }
            }
            break;
        }
      },
      itemBuilder: (ctx) => const [
        PopupMenuItem(
          value: _AccountAction.profile,
          child: ListTile(
            leading: Icon(Icons.person_outline),
            title: Text('Perfil'),
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
        PopupMenuDivider(),
        PopupMenuItem(
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
          child: Icon(Icons.person, color: PassengerView._purple),
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
        ElevatedButton(
          style: TextButton.styleFrom(
            foregroundColor: Color(0xFF5B3CF6), // color primario
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Color(0xFF5B3CF6),
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Salir'),
        ),
      ],
    ),
  );
}
