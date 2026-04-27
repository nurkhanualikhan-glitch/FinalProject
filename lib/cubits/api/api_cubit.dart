import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/quote_model.dart';
import '../../services/api_service.dart';

sealed class ApiState {}

class ApiInitial extends ApiState {}

class ApiLoading extends ApiState {}

class ApiLoaded extends ApiState {
  final List<QuoteModel> quotes;

  ApiLoaded(this.quotes);
}

class ApiError extends ApiState {
  final String message;

  ApiError(this.message);
}

class ApiCubit extends Cubit<ApiState> {
  ApiCubit(this._apiService) : super(ApiInitial());

  final ApiService _apiService;

  Future<void> loadQuotes() async {
    emit(ApiLoading());

    try {
      final quotes = await _apiService.fetchQuotes();
      emit(ApiLoaded(quotes));
    } catch (error) {
      emit(ApiError(error.toString()));
    }
  }
}
