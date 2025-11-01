import 'package:dio/dio.dart';
import 'package:product_showcase/helpers/http_helper.dart';
import 'package:product_showcase/helpers/storage_helper.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor();

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await getStorageStringItem('token');
    options.headers['Authorization'] = 'Bearer $token';
    super.onRequest(options, handler);
  }
}

final dio = Dio(BaseOptions(baseUrl: apiBaseUrl))
  ..interceptors.add(AuthInterceptor());
