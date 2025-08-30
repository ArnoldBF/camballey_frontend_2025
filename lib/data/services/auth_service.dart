import 'package:camballey_frontend_2025/data/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
      // Tu backend pone el rol adentro del token. En el ejemplo aparece "rol":2.
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




    // --------- PHONE OTP (2 pasos) ----------
  // Inicia OTP por SMS (para login o registro)
  // Future<void> startPhoneOtp(String phone) async {
  //   final normalized = Validators.normalizeBoPhone(phone);
  //   if (K.useMock) {
  //     await Future.delayed(const Duration(milliseconds: 300));
  //     return;
  //   }
  //   try {
  //     await _http.post('/auth/otp/start', data: {'phone': normalized},
  //         options: Options(headers: {'Authorization': null}));
  //   } on DioException catch (e) {
  //     throw ApiException(e.response?.data?['message'] ?? 'No se pudo enviar OTP', status: e.response?.statusCode);
  //   }
  }

    // Verifica OTP (devuelve y guarda tokens)
  // Future<void> verifySmsCode(String phone, String code) async {
  //   final normalized = Validators.normalizeBoPhone(phone);
  //   if (K.useMock) {
  //     await Future.delayed(const Duration(milliseconds: 200));
  //     if (code.trim() != '123456') throw ApiException('Código incorrecto (MOCK)');
  //     await ApiClient.setTokens(accessToken: 'mock-access', refreshToken: 'mock-refresh');
  //     return;
  //   }
  //   try {
  //     final resp = await _http.post('/auth/otp/verify',
  //         data: {'phone': normalized, 'code': code.trim()},
  //         options: Options(headers: {'Authorization': null}));
  //     await ApiClient.setTokens(
  //       accessToken: resp.data['access_token'],
  //       refreshToken: resp.data['refresh_token'],
  //     );
  //   } on DioException catch (e) {
  //     throw ApiException(e.response?.data?['message'] ?? 'OTP inválido', status: e.response?.statusCode);
  //   }
  // }








 /* ---------- REGISTRO ---------- */

  // Future<void> signUpWithEmailPassword({
  //   required String email,
  //   required String password,
  //   String? phone,
  //   String? ci,
  //   String? fullName,
  //   String role = 'passenger',
  // }) async {
  //   if (K.useMock) {
  //     await Future.delayed(const Duration(milliseconds: 300));
  //     if (!Validators.looksLikeEmail(email) || password.length < 6) {
  //       throw ApiException('Datos inválidos (MOCK)');
  //     }
  //     return;
  //   }
  //   try {
  //     await _http.post('/auth/register', data: {
  //       'email': email.trim(),
  //       'password': password,
  //       'phone': (phone ?? '').isEmpty ? null : Validators.normalizeBoPhone(phone!),
  //       'ci': ci,
  //       'full_name': fullName,
  //       'role': role,
  //     }, options: Options(headers: {'Authorization': null}));
  //   } on DioException catch (e) {
  //     throw ApiException(e.response?.data?['message'] ?? 'No se pudo registrar', status: e.response?.statusCode);
  //   }
  // }

    // En muchos backends: registro por teléfono = start OTP + luego verify
  // Future<void> signUpWithPhone(String phone) async {
  //   // si tu backend requiere endpoint distinto para signup, cámbialo
  //   await startPhoneOtp(phone);
  // }


  // Future<void> confirmPhoneSignup({required String phone, required String code}) async {
  //   await verifySmsCode(phone, code); // y luego upsertProfile()
  // }


    /* ---------- PERFIL ---------- */

  // Future<AppUserProfile?> getMyProfile() async {
  //   if (K.useMock) {
  //     await Future.delayed(const Duration(milliseconds: 200));
  //     return AppUserProfile(
  //       id: 'mock-1',
  //       fullName: 'Usuario Demo',
  //       email: 'demo@correo.com',
  //       phone: '+59170000000',
  //       role: UserType.driver,
  //     );
  //   }
  //   try {
  //     final resp = await _http.get('/profiles/me');
  //     return AppUserProfile.fromMap(resp.data as Map<String, dynamic>);
  //   } on DioException catch (e) {
  //     if (e.response?.statusCode == 404) return null;
  //     throw ApiException('No se pudo obtener tu perfil');
  //   }
  // }

  //   Future<void> upsertProfile({required String role, required String fullName, String? ci}) async {
  //   if (K.useMock) {
  //     await Future.delayed(const Duration(milliseconds: 200));
  //     return;
  //   }
  //   try {
  //     await _http.put('/profiles/me', data: {
  //       'full_name': fullName.isEmpty ? 'Usuario' : fullName,
  //       'role': role,
  //       if (ci != null) 'ci': ci,
  //     });
  //   } on DioException {
  //     throw ApiException('No se pudo guardar el perfil');
  //   }
  // }

  // Future<void> updateProfileName(String fullName) => upsertProfile(role: 'passenger', fullName: fullName);


    /* ---------- LOGOUT ---------- */

  // Future<void> signOut() async {
  //   try {
  //     if (!K.useMock) {
  //       await _http.post('/auth/logout', data: {'refresh_token': await _readRefresh()});
  //     }
  //   } catch (_) {
  //     // no bloquees el logout si el endpoint falla
  //   } finally {
  //     await ApiClient.clearTokens();
  //   }
  // }

  Future<String?> _readRefresh() async => await const FlutterSecureStorage().read(key: 'refresh_token');



// }

