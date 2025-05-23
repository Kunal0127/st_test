import 'dart:developer' as dev;

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

class ApiService {
  final Dio _dio = Dio();
  ApiService() {
    // Add an interceptor to log request and response details
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Log the request details (URL, method, headers, and body)
        dev.log('Request: ${options.method} ${options.uri}');
        dev.log('Headers: ${options.headers}');
        dev.log('Body: ${options.data}');
        return handler.next(options); // Continue with the request
      },
      onResponse: (response, handler) {
        // Log the response details (status, data)
        dev.log('Response: ${response.statusCode} ${response.statusMessage}');
        dev.log('Response Data: ${response.data}');
        return handler.next(response); // Continue with the response
      },
      onError: (DioException e, handler) {
        // Log any errors
        dev.log('Error: ${e.response?.statusCode} ${e.message} ${e.response}');
        return handler.next(e); // Continue with the error handling
      },
    ));
  }
  Future<String> uploadFile({
    required String filePath,
    required String employeeCode,
    required String action, // login, breakin, breakout, logout
  }) async {
    final fileName = filePath.split('/').last;
    final formData = FormData.fromMap({
      'employee_code': employeeCode,
      action: 'yes',
      'profile_image': await MultipartFile.fromFile(
        filePath,
        filename: fileName,
        contentType: MediaType('image', 'jpg'),
      ),
    });

    try {
      final response = await _dio.post(
        'https://dev-dev009.pantheonsite.io/wp-json/custom-api/v1/login',
        data: formData,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return data['message'] ?? "Upload successful";
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      print("object 2 : $e");
      if (e is DioException) {
        // Handle Dio errors
        if (e.response?.statusCode == 400) {
          // Check for 400 error and log/display the response message
          final errorMessage = e.response?.data['message'] ?? 'Unknown error';
          return errorMessage;
        } else {
          // For other errors, log the response error or message
          return "Upload failed: ${e.message}";
        }
      } else {
        // In case it's not a DioException, handle the error generically
        return "Upload failed: $e";
      }
    }
  }
}
