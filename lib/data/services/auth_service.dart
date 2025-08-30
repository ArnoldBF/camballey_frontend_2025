import 'package:supabase_flutter/supabase_flutter.dart';
import 'api_client.dart';
import '../../core/utils/validators.dart';

class AuthService {
  final supa = ApiClient.supa;

  Future<AuthResponse> signInWithEmail(String email, String password) {
    return supa.auth.signInWithPassword(email: email.trim(), password: password);
  }

  Future<void> startPhoneOtp(String phone) {
    return supa.auth.signInWithOtp(
      phone: Validators.normalizeBoPhone(phone),
      channel: OtpChannel.sms,
    );
  }

  Future<AuthResponse> verifySmsCode(String phone, String code) {
    return supa.auth.verifyOTP(
      phone: Validators.normalizeBoPhone(phone),
      token: code.trim(),
      type: OtpType.sms,
    );
  }

  Future<void> upsertProfile({
    required String role, // 'passenger' | 'driver' | 'admin'
    required String fullName,
  }) async {
    final user = supa.auth.currentUser;
    if (user == null) throw Exception('No autenticado');

    await supa.from('profiles').upsert({
      'id': user.id,
      'full_name': fullName.isEmpty ? 'Usuario' : fullName,
      'email': user.email,
      'phone': user.phone,
      'role': role, // RLS impedirá cambios posteriores por el cliente
    }, onConflict: 'id');
  }
}
