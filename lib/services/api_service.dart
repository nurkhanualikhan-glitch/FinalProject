import 'package:dio/dio.dart';

import '../models/quote_model.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://dummyjson.com',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Future<List<QuoteModel>> fetchQuotes() async {
    final response = await _dio.get('/quotes');

    final data = response.data as Map<String, dynamic>;
    final quotes = data['quotes'] as List<dynamic>;

    return quotes
        .map((item) => QuoteModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}