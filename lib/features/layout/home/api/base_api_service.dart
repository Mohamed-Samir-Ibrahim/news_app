abstract class BaseApiService {
  Future<dynamic> get(String endPoint, {Map<String, String>? headers});

  Future<dynamic> post(
    String endPoint, {
    Map<String, String>? headers,
    dynamic body,
  });

  Future<dynamic> put(
    String endPoint, {
    Map<String, String>? headers,
    dynamic body,
  });

  Future<dynamic> delete(String endPoint, {Map<String, String>? headers});
}
