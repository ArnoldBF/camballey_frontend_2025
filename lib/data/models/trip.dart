class Transporte {
  final int id;
  final String placa;
  final String interno;
  final String linea;

  Transporte({
    required this.id,
    required this.placa,
    required this.interno,
    required this.linea,
  });

  factory Transporte.fromMap(Map<String, dynamic> m) => Transporte(
        id: m['id'] as int,
        placa: (m['placa'] ?? '').toString(),
        interno: (m['interno'] ?? '').toString(),
        linea: (m['linea'] ?? '').toString(),
      );
}

class Trip {
  final int id;
  final double monto;
  final DateTime createdAt;
  final Transporte transporte;

  Trip({
    required this.id,
    required this.monto,
    required this.createdAt,
    required this.transporte,
  });

  factory Trip.fromMap(Map<String, dynamic> m) => Trip(
        id: m['id'] as int,
        monto: double.tryParse((m['monto'] ?? '0').toString()) ?? 0.0,
        createdAt: DateTime.parse(m['createdAt'] as String),
        transporte: Transporte.fromMap(m['transporte'] as Map<String, dynamic>),
      );
}
