import 'package:camballey_frontend_2025/data/models/trip.dart';
import 'package:camballey_frontend_2025/data/services/auth_service.dart';
import 'package:camballey_frontend_2025/data/services/trip_service.dart';
import 'package:flutter/material.dart';

import 'widgets/header.dart';
import 'widgets/earnings_card.dart';
import 'widgets/recent_section.dart';
import 'widgets/main_menu.dart';
import 'widgets/account_menu.dart';
// (Opcional para futuros usos)
// import 'widgets/action_buttons.dart';

class DriverView extends StatefulWidget {
  const DriverView({super.key});

  @override
  State<DriverView> createState() => _DriverViewState();
}

class _DriverViewState extends State<DriverView> {

  late Future<List<Trip>> _future;
  
   @override
  void initState() {
    super.initState();
    _future = TripService().getMyTrips();
  }

  String _formatBs(num v) => 'Bs ${v.toStringAsFixed(2)}';

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

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
        actions: const [
          AccountMenu(),
          SizedBox(width: 4),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children:  [
          DriverHeader(name: name, line: 'Línea 74'),
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
