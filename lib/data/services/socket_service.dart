import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'notification_service.dart';

class SocketService {
  SocketService._();
  static final SocketService I = SocketService._();

  IO.Socket? _socket;

  /// Conexión al servidor de **Socket.IO**.
  /// [baseUrl] SOLO el host del socket (p. ej. http://10.0.2.2:3000 o https://tu-backend.com).
  /// **No** pongas /api ni rutas REST aquí.
  void connect({
    required String baseUrl,
    required int userId, // debe coincidir con el configurado en el server
  }) async {
    await NotificationService.I.init();

    // Cierra sockets previos si los hubiera
    _socket?.dispose();

    _socket = IO.io(
      baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setPath('/socket.io/')      // <-- path por defecto de Socket.IO
          .enableReconnection()
          .setReconnectionAttempts(999)
          .setReconnectionDelay(1000)
          .setTimeout(10000)
          .enableAutoConnect()
          .build(),
    );

    _socket!.onConnect((_) {
      debugPrint('[SOCKET] connected with id: ${_socket!.id}');
      final sala = 'usuario_$userId';
      _socket!.emit('join', {'sala': sala}); // <-- tu backend espera { sala }
      debugPrint('[SOCKET] join -> $sala');
    });

    _socket!.on('joined', (data) {
      debugPrint('[SOCKET] joined ack: $data');
    });

    // Evento que emite tu backend (para CHOFER)
    _socket!.on('saldoAbonado', (data) {
      debugPrint('[SOCKET] saldoAbonado => $data');
      final monto = (data is Map && data['montoAbonado'] != null)
          ? data['montoAbonado'].toString()
          : '';
      final emisor = (data is Map && data['pasajeroEmisor'] != null)
          ? data['pasajeroEmisor'].toString()
          : 'Pasajero';
      final saldo = (data is Map && data['nuevoSaldo'] != null)
          ? data['nuevoSaldo'].toString()
          : '';

      NotificationService.I.show(
        title: 'Pago recibido',
        body: 'De: $emisor · $monto Bs · Saldo: $saldo Bs',
      );
    });

    // (Opcional) para el PASAJERO
    _socket!.on('saldoDescontado', (data) {
      debugPrint('[SOCKET] saldoDescontado => $data');
    });

    // Debug / errores
    _socket!.onAny((event, data) => debugPrint('[SOCKET] <$event> $data'));
    _socket!.onConnectError((e) => debugPrint('[SOCKET] connect_error: $e'));
    _socket!.onError((e) => debugPrint('[SOCKET] error: $e'));
    _socket!.onDisconnect((_) => debugPrint('[SOCKET] disconnected'));
  }

  void dispose() {
    _socket?.dispose();
    _socket = null;
  }
}
