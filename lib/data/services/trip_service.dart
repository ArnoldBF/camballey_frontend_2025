import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../services/api_client.dart';
import '../models/trip.dart';

class TripService {
  Dio get _http => ApiClient.dio;

  Future<List<Trip>> getTripsByUserId(int userId) async {
    debugPrint('[TRIPS] GET /viaje/all/$userId');
    final r = await _http.get('/viaje/all/$userId');
    final list = (r.data as List)
        .map((e) => Trip.fromMap(e as Map<String, dynamic>))
        .toList();

    // más reciente primero
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    debugPrint('[TRIPS] count=${list.length}');
    return list;
  }

  Future<List<Trip>> getMyTrips() async {
    final id = ApiClient.currentUserId;
    if (id == null) throw Exception('No hay userId en el token');
    return getTripsByUserId(id);
  }
}
