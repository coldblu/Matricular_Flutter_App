import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:matricular/matricular.dart';
import 'package:matricular_app/app/api/AppAPI.dart';
import 'package:matricular_app/app/utils/config_state.dart';
import 'package:provider/provider.dart';
import 'package:signals/signals.dart';
import 'package:signals/signals_flutter.dart';

class FuncionarioIncludePage extends StatefulWidget {
  const FuncionarioIncludePage({super.key});

  static Route<void> route() {
    return MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => MultiProvider(
          providers: [
            Provider(create: (_) => context.read<ConfigState>(),
              dispose: (_, instance) => instance.dispose() ,),
            Provider(create: (_) => context.read<AppAPI>())
          ],
          child: const FuncionarioIncludePage(),
        )
    );
  }

  @override
  State<FuncionarioIncludePage> createState() => _FuncionarioIncludePageState();
}

class _FuncionarioIncludePageState extends State<FuncionarioIncludePage> {
  var pessoaNome;
  var pessoaCPF;
  var email;
  var cargo;
  var pessoaTelefone;
  var senha;
  //Controle do botão
  late final isValid =
  computed(() =>
      pessoaNome().isNotEmpty &&
      pessoaCPF().isNotEmpty &&
      email().isNotEmpty &&
      cargo().isNotEmpty &&
      pessoaTelefone().isNotEmpty &&
      senha().isNotEmpty
  );

  late AppAPI appAPI;
  late Matricular usuarioApi;

  validateForm() async {
    var ok = false;
    /*
    if (password().length > 4) {
      passwordError.value = null;
      ok = true;
    } else {
      passwordError.value = 'Erro! Mínimo de 6 caracteres';
    }

    if(ok) {

      try {

        if(response.statusCode == 200){
          appAPI.config.token.set(response.data!.accessToken!);
          debugPrint("ok cadastrado");
          //Routefly.navigate(routePaths.home);
        }else {
          message() {
            showMessage(context, "Login Falhou: ${response.data}");
          }
          message();
        }
      } on DioException catch (e) {
        print("Exception when calling authenticator: $e\n");
      }
    }*/
  }

  @override
  Widget build(BuildContext context) {
    appAPI = context.read<AppAPI>();
    usuarioApi = appAPI.api;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Tela de login'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          height: MediaQuery.of(context).size.height - 120,
          //height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                  flex: 3,
                  child: TextField(
                    onChanged: pessoaNome.set,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), label: Text("Nome")),
                  )),
              const Spacer(
                flex: 1,
              ),
              Flexible(
                  flex: 3,
                  child: TextField(
                    onChanged: pessoaCPF.set,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("CPF"),
                        //errorText: passwordError.watch(context)
                    ),
                    enableSuggestions: false,
                    autocorrect: false,
                    obscureText: true,
                  )),
              Flexible(
                flex: 3,
                child: FractionallySizedBox(
                  widthFactor: 0.4,
                  heightFactor: 0.4,
                  child: FilledButton(
                    //onPressed: isValid.watch(context) ? validateForm : null,
                    onPressed: isValid.watch(context) ? validateForm : null,/*() {
                      Routefly.pushNavigate(routePaths.home);
                    },*/
                    child: const Text('Cadastrar'),
                  ),
                ),
              ),
              const Spacer(
                flex: 2,
              ),

            ],
          ),
        ),
      ),
    );
  }

}