import 'dart:core';
import 'dart:core';

import 'package:matricular/matricular.dart';
import 'package:dio/dio.dart';
import 'package:matricular_app/app/utils/config_state.dart';
import 'package:signals/signals.dart';


class AppAPI{
  late final Matricular api;
  final ConfigState config;

  AppAPI({required this.config}){

    final matricularApi = Matricular(basePathOverride: config.url(),
        interceptors: [
          InterceptorsWrapper(onRequest: (options, handler) {
            options.headers['Authorization'] = 'Bearer ${config.token()}';
            return handler.next(options);
          })
        ]);
    api = matricularApi;


    config.url.subscribe((value) {
      api.dio.options.baseUrl = value;
    });
  }

  dispose() async {
    config.dispose();
  }
}