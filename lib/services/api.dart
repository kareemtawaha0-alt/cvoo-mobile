import 'package:dio/dio.dart';

class Api {
  static final Dio dio = Dio(
    BaseOptions(baseUrl: 'http://127.0.0.1:4000/api'),
  )
    ..options.headers['Authorization'] = 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY5MDRmYjVlNTc3OTY1MzdhYmNkYWU4ZiIsInJvbGUiOiJlbXBsb3llZSIsIm5hbWUiOiJMYW1hIEVtcGxveWVlIiwiaWF0IjoxNzYxOTM0MzU5LCJleHAiOjE3NjI1MzkxNTl9.t-GJTe4bLdieLE8jVOOX6lEF-RDf7PR1NfN1J5McIwA';
}
