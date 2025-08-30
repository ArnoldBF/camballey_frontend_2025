import 'package:supabase_flutter/supabase_flutter.dart';
import 'api_client.dart';
import '../../core/utils/validators.dart';

/// OTP mock permitido cuando no hay Supabase:
const _mockOtp = '123456';


class AuthService {
  final supa = ApiClient.supa;

  // Estado mock en memoria (NO persistente, solo para demos)
  static Map<String, dynamic>? _mockSession;
  static Map<String, dynamic>? _mockProfile;

  bool get isMock => ApiClient.supa == null;


  // --------- EMAIL + PASSWORD ----------
  Future<void> signInWithEmail(String email, String password) async {
     final c = ApiClient.supa;
    if (c != null) {
      await c.auth.signInWithPassword(email: email.trim(), password: password);
      return;
    }
    // MOCK: valida localmente
    await Future.delayed(const Duration(milliseconds: 400));
    if (!Validators.looksLikeEmail(email)) {
      throw Exception('Email inválido (MOCK)');
    }
    if (password.length < 6) {
      throw Exception('Contraseña muy corta (MOCK)');
    }
    // _mockSession = {'email': email};
  }

    // --------- PHONE OTP (2 pasos) ----------
  Future<void> startPhoneOtp(String phone) async {
    final c = ApiClient.supa;
    if (c != null) {
      await c.auth.signInWithOtp(
        phone: Validators.normalizeBoPhone(phone),
        channel: OtpChannel.sms,
      );
      return;
    }
    // MOCK: “envía” _mockOtp
    await Future.delayed(const Duration(milliseconds: 400));
    // _mockSession = {'phone': Validators.normalizeBoPhone(phone), 'otpSent': true};
  }

  Future<void> verifySmsCode(String phone, String code) async {
    final c = ApiClient.supa; 
    if (c != null) {
      await c.auth.verifyOTP(
        phone: Validators.normalizeBoPhone(phone),
        token: code.trim(),
        type: OtpType.sms,
      );
      return;
    }
    await Future.delayed(const Duration(milliseconds: 200));
    if (code.trim() != _mockOtp) {
      throw Exception('Código SMS incorrecto (MOCK). Usa $_mockOtp');
    }
    // _mockSession ??= {};
    // _mockSession!['phone'] = Validators.normalizeBoPhone(phone);
    // _mockSession!['otpOk'] = true;
  }

  // --------- PROFILE (upsert) ----------
  Future<void> upsertProfile({
    required String role, // 'passenger' | 'driver' | 'admin'
    required String fullName,
  }) async {
    final c = ApiClient.supa;
    if (c != null) {
      final user = c.auth.currentUser;
      if (user == null) throw Exception('No autenticado');
      await c.from('profiles').upsert({
        'id': user.id,
        'full_name': fullName.isEmpty ? 'Usuario' : fullName,
        'email': user.email,
        'phone': user.phone,
        'role': role,
      }, onConflict: 'id');
      return;
    }
    // MOCK en memoria
    // _mockProfile = {
    //   'id': 'mock-user',
    //   'full_name': fullName.isEmpty ? 'Usuario' : fullName,
    //   'email': _mockSession?['email'],
    //   'phone': _mockSession?['phone'],
    //   'role': role,
    // };
  }

  // Helpers opcionales por si los necesitas luego
  Map<String, dynamic>? get mockProfile => _mockProfile;
  Map<String, dynamic>? get mockSession => _mockSession;
}
