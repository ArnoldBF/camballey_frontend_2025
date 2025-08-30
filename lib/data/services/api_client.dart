import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/constants.dart';

class ApiClient {
  static late Dio dio;
  static final _secure = const FlutterSecureStorage();
  static String? _token;
  // static String? _refreshToken;
  // static bool _initialized = false;
  // static bool _isRefreshing = false;
  // static final List<Completer<void>> _refreshQueue = [];

  static Future<void> init() async {
      dio = Dio(BaseOptions(
      baseUrl: K.apiBaseUrl,
      headers: {'Content-Type': 'application/json'},
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
    ));

    _token = await _secure.read(key: 'access_token');
    // (opcional) logs de red
    // dio.interceptors.add(PrettyDioLogger(requestBody: true, responseBody: true));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (opt, handler) {
        if (_token != null) {
          opt.headers['Authorization'] = 'Bearer $_token';
        }
        handler.next(opt);
      },
    ));
  }

  static Future<void> setToken(String token) async {
    _token = token;
    await _secure.write(key: 'access_token', value: token);
    print('Token set: $token');
  }

  static Future<void> clearToken() async {
    _token = null;
    await _secure.delete(key: 'access_token');
  }
}

