import 'package:dio/dio.dart';

class AuthService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: "https://fakestoreapi.com",
  ));

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await _dio.post(
        "/auth/login",
        data: {
          "username": username,
          "password": password,
        },
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
      );

      print(" Server Response: ${response.data}");
      return response.data;
    } on DioException catch (e) {
      print(" Server Error: ${e.response?.data ?? e.message}");
      throw Exception(e.response?.data ?? e.message);
    }
  }
}
