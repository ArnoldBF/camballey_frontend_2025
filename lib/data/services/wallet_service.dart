import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'api_client.dart';



class WalletService {
  Dio get _http => ApiClient.dio;

  // GET /saldo/{userId} -> devuelve monto como double
  Future<double> getBalanceByUserId(int userId) async {
    final resp = await _http.get('/saldo/$userId');
    // respuesta: { "id": 5, "monto": "1000", ... }
    print('hioal');
    print(resp);
    final data = resp.data as Map<String, dynamic>;
    final montoStr = data['monto']?.toString() ?? '0';
    final monto = double.tryParse(montoStr) ?? 0.0;
    debugPrint('[SALDO] monto=$monto');
    return monto;
  }

  // Deriva userId desde el token y pide el saldo
 Future<double> getMyBalance() async {
    final id = ApiClient.currentUserId;
    debugPrint('[SALDO] token.userId=$id');
    if (id == null) throw Exception('No hay usuario autenticado');
    return getBalanceByUserId(id);
  }

  int? _userIdFromToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;
      final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
      final claims = json.decode(payload) as Map<String, dynamic>;
      final sub = claims['sub'];
      if (sub is int) return sub;
      return int.tryParse(sub.toString());
    } catch (_) {
      return null;
    }
  }
}
