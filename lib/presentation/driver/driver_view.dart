import 'package:flutter/material.dart';

import 'widgets/header.dart';
import 'widgets/earnings_card.dart';
import 'widgets/recent_section.dart';
import 'widgets/main_menu.dart';
import 'widgets/account_menu.dart';
// (Opcional para futuros usos)
// import 'widgets/action_buttons.dart';

class DriverView extends StatelessWidget {
  const DriverView({super.key});

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
