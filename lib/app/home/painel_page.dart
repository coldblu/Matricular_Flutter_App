import 'package:flutter/material.dart';

import 'package:matricular/matricular.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:built_collection/built_collection.dart';
import 'package:matricular_app/app/api/AppAPI.dart';
import 'package:matricular_app/app/utils/config_state.dart';
import 'package:provider/provider.dart';
import 'package:routefly/routefly.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signals/signals_flutter.dart';

import '../../routes.dart';

class PainelPage extends StatefulWidget {
  const PainelPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => MultiProvider(
          providers: [
            Provider(create: (_) => context.read<ConfigState>(),
              dispose: (_, instance) => instance.dispose() ,),
            Provider(create: (_) => context.read<AppAPI>())
          ],
          child: const PainelPage(),
        )
    );
  }

  @override
  State<PainelPage> createState() => _PainelPageState();
}

class _PainelPageState extends State<PainelPage> {
  final url = signal('');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Build Painel page");
    return Scaffold(
      body:  Container(
        child: Center(
          child: Text("Inicio"),
        ),
      )
    );
  }

}