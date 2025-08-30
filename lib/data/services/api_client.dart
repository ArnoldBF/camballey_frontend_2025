import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants.dart';

class ApiClient {
  static SupabaseClient? supa; // null cuando mock

    static Future<void> init() async {
    if (K.useSupabase && K.supabaseUrl.isNotEmpty && K.supabaseAnonKey.isNotEmpty) {
      await Supabase.initialize(url: K.supabaseUrl, anonKey: K.supabaseAnonKey);
      supa = Supabase.instance.client;
      // ignore: avoid_print
      print('***** Supabase init completed *****');
    } else {
      supa = null;
      // ignore: avoid_print
      print('>>> Supabase DISABLED: running in MOCK mode');
    }
  }
}
