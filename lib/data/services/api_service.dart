import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static final ApiService _instance = ApiService._internal();

  factory ApiService() {
    return _instance;
  }

  ApiService._internal();

  static const String baseUrl = 'https://api.navio.com/v1';
  static const int timeoutSeconds = 30;

  /// GET request
  Future<Map<String, dynamic>?> get(String endpoint) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final response = await http
          .get(url)
          .timeout(const Duration(seconds: timeoutSeconds));

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// POST request
  Future<Map<String, dynamic>?> post(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body ?? {}),
          )
          .timeout(const Duration(seconds: timeoutSeconds));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// PUT request
  Future<Map<String, dynamic>?> put(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final response = await http
          .put(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body ?? {}),
          )
          .timeout(const Duration(seconds: timeoutSeconds));

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// DELETE request
  Future<bool> delete(String endpoint) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final response = await http
          .delete(url)
          .timeout(const Duration(seconds: timeoutSeconds));

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      return false;
    }
  }

  /// Get routes
  Future<List<dynamic>?> getRoutes() async {
    final response = await get('/routes');
    return response?['routes'] as List<dynamic>?;
  }

  /// Get buses
  Future<List<dynamic>?> getBuses() async {
    final response = await get('/buses');
    return response?['buses'] as List<dynamic>?;
  }

  /// Get trips
  Future<List<dynamic>?> getTrips(String userId) async {
    final response = await get('/trips?userId=$userId');
    return response?['trips'] as List<dynamic>?;
  }

  /// Book a trip
  Future<Map<String, dynamic>?> bookTrip({
    required String userId,
    required String routeId,
    required double fare,
  }) async {
    return await post(
      '/trips/book',
      body: {
        'userId': userId,
        'routeId': routeId,
        'fare': fare,
        'bookingTime': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Cancel trip
  Future<bool> cancelTrip(String tripId) async {
    return await delete('/trips/$tripId');
  }

  /// Rate trip
  Future<Map<String, dynamic>?> rateTrip({
    required String tripId,
    required double rating,
    required String comment,
  }) async {
    return await post(
      '/trips/$tripId/rate',
      body: {'rating': rating, 'comment': comment},
    );
  }

  /// Get nearby buses
  Future<List<dynamic>?> getNearbyBuses({
    required double latitude,
    required double longitude,
    required double radiusKm,
  }) async {
    final response = await get(
      '/buses/nearby?lat=$latitude&lon=$longitude&radius=$radiusKm',
    );
    return response?['buses'] as List<dynamic>?;
  }
}
