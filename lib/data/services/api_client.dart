import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants.dart';

class ApiClient {
  static late final SupabaseClient supa;

  static Future<void> init() async {
    await Supabase.initialize(url: K.supabaseUrl, anonKey: K.supabaseAnonKey);
    supa = Supabase.instance.client;
  }
}
