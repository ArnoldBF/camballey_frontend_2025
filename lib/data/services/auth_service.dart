import 'package:camballey_frontend_2025/data/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'api_client.dart';
import '../../core/utils/validators.dart';
import 'package:dio/dio.dart';
import '../../core/constants.dart';
import 'dart:convert'; 

class ApiException implements Exception {
  final String message;
  final int? status;
  ApiException(this.message, {this.status});
  @override
  String toString() => message;
}
String? currentFullName;

class AuthService {

  /* Llama: POST /auth/login  { userName, password }
     Respuesta: { token: "<JWT>" } */

  Dio get _http => ApiClient.dio;

   /* ---------- LOGIN ---------- */

  Future<int?> signInUsernamePassword({
    required String userName,
    required String password,
  }) async {
    try {

      debugPrint('[AUTH] POST ${ApiClient.dio.options.baseUrl}/auth/login');
      debugPrint('[AUTH] body: {userName: $userName, password: ${password}}');
      final r = await ApiClient.dio.post(
        '/auth/login',
        data: {'userName': userName, 'password': password},
        options: Options(headers: {'Authorization': null}), // sin bearer previo
      );

      final token = (r.data as Map)['token'] as String;
      debugPrint('[AUTH] token.prefix: ${token.substring(0, 12)}... len=${token.length}');  
      await ApiClient.setToken(token);

      final claims = _decodeJwt(token);
      debugPrint('Datos del usuario en el token: $claims');
      // Tu backend pone el rol adentro del token. En el ejemplo aparece "rol":2.
      currentFullName = claims['fullName'] as String?;
      debugPrint('Datos del usuario en el token: $currentFullName');
      final role = (claims['rol'] ?? claims['role'] ?? claims['roleId']) as int?;
      return role; // p.ej. 1=Pasajero, 2=Conductor (ajústalo a tu mapping real)
    } on DioException catch (e) {
       final status = e.response?.statusCode;
       final body = e.response?.data;
       debugPrint('[AUTH][DIO ERROR] status=$status body=$body');
      final msg = e.response?.data is Map
          ? (e.response!.data['message'] ?? 'Usuario o contraseña incorrectos')
          : 'Usuario o contraseña incorrectos';
      throw Exception(msg);
    } catch (e) {
      throw Exception('Error de red: $e');
    }
  }

  Future<void> signOut() async {
    await ApiClient.clearToken(); // limpia y listo
  }

  Map<String, dynamic> _decodeJwt(String token) {
    // payload es la parte [1]
    final parts = token.split('.');
    if (parts.length != 3) return {};
    final payload = base64Url.normalize(parts[1]);
    final jsonStr = utf8.decode(base64Url.decode(payload));
    return json.decode(jsonStr) as Map<String, dynamic>;
  }



// REGISTRO: crea usuario pasajero (rolId=2) y devuelve el JSON de la API
Future<Map<String, dynamic>> registerPassenger({
  required String nombre,
  required String apellido,
  required String ci,
  required String telefono,
  required int edad,
  required String correo,
  required String password,
  int rolId = 2, // pasajero por defecto
}) async {
  try {
    final body = {
      'nombre': nombre,
      'apellido': apellido,
      'ci': ci,
      'telefono': telefono,
      'edad': edad,
      'correo': correo,
      'password': password,
      'rolId': rolId,
    };

    // Logs útiles
    debugPrint('[REGISTER] POST ${ApiClient.dio.options.baseUrl}/usuarios/crear');
    debugPrint('[REGISTER] body: {nombre:$nombre, apellido:$apellido, ci:$ci, tel:$telefono, edad:$edad, correo:$correo, rolId:$rolId, password:${password}}');

    final resp = await ApiClient.dio.post('/usuarios/crear',
        data: body,
        options: Options(headers: {'Authorization': null})); // registro no necesita bearer

    final data = (resp.data as Map).cast<String, dynamic>();
    debugPrint('[REGISTER] status=${resp.statusCode} userName=${data['userName']} id=${data['id']}');
    return data;
  } on DioException catch (e) {
    final status = e.response?.statusCode;
    final body = e.response?.data;
    debugPrint('[REGISTER][DIO ERROR] status=$status body=$body');

    String msg = 'No se pudo registrar';
    if (body is Map && body['message'] != null) {
      msg = body['message'].toString();
    } else if (status == 409) {
      msg = 'Ese correo/CI ya está registrado';
    } else if (status == 500) {
      msg = 'Error interno del servidor';
    }
    throw Exception(msg);
  } catch (e) {
    debugPrint('[REGISTER][ERROR] $e');
    throw Exception('Error de red: $e');
  }
}

Future<void> loginWithGoogle() async {
   const url = 'https://camballeybacked2025-production.up.railway.app/api/auth/google';
  final uri = Uri.parse(url);

  try {
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched) {
      throw Exception('No se pudo abrir la URL de Google Auth');
    }
  } catch (e) {
    debugPrint('[Google Auth Error] $e');
    // Muestra un mensaje al usuario
  }
  }

   

  Future<String?> _readRefresh() async => await const FlutterSecureStorage().read(key: 'refresh_token');



// }

}