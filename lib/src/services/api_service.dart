import 'package:dio/dio.dart';
import '../models/chat_response_model.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://100.106.147.114:9557',
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    headers: {
      'Content-Type': 'application/json',
    },
  ));

  Future<ChatResponseModel?> sendMessage(String message, {String? context}) async {
    try {
      final String payload = context != null ? "$context\n$message" : message;
      
      final response = await _dio.post(
        '/api/chat',
        data: {'message': payload, 'original': message},
      );

      if (response.statusCode == 200 && response.data != null) {
        return ChatResponseModel.fromJson(response.data);
      }
    } catch (e) {
      print('Error calling API: $e');
    }
    return null;
  }
}
