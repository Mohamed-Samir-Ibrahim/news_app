import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news_app/features/layout/home/api/api_constants.dart';
import 'package:news_app/features/layout/home/api/base_api_service.dart';

class ApiService extends BaseApiService {
  final http.Client _client;

  /// initialize before the constructor body
  ApiService() : _client = http.Client();

  @override
  Future<dynamic> get(String endPoint, {Map<String, String>? headers}) async {
    try {
      print('${ApiConstants.baseUrl}$endPoint');
      final response = await _client.get(
        Uri.parse('${ApiConstants.baseUrl}$endPoint'),
        headers:
            headers ??
            {'Content-Type': 'application/json', 'apiKey': ApiConstants.apiKey},
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('GET request failed: $e');
    }
  }

  @override
  Future<dynamic> post(
    String endPoint, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('${ApiConstants.baseUrl}$endPoint'),
        headers: headers ?? {'Content-Type': 'application/json'},
        body: body != null ? jsonEncode(body) : null,
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('POST request failed: $e');
    }
  }

  @override
  Future<dynamic> put(
    String endPoint, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    try {
      final response = await _client.put(
        Uri.parse('${ApiConstants.baseUrl}$endPoint'),
        headers:
            headers ??
            {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: body != null ? jsonEncode(body) : null,
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('PUT request failed: $e');
    }
  }

  @override
  Future<dynamic> delete(
    String endPoint, {
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _client.delete(
        Uri.parse('${ApiConstants.baseUrl}$endPoint'),
        headers: headers ?? {'Content-Type': 'application/json'},
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('DELETE request failed: $e');
    }
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isNotEmpty) {
        print('hereee');
        print(jsonDecode(response.body));
      }
      return response.body.isNotEmpty ? jsonDecode(response.body) : null;
    } else {
      throw Exception('HTTP ${response.statusCode}: ${response.reasonPhrase}');
    }
  }

  void dispose() {
    _client.close();
  }
}
