import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:matricular/matricular.dart';
import 'package:matricular_app/app/api/AppAPI.dart';
import 'package:matricular_app/app/utils/config_state.dart';
import 'package:matricular_app/routes.dart';
import 'package:provider/provider.dart';
import 'package:routefly/routefly.dart';
import 'package:signals/signals.dart';
import 'package:signals/signals_flutter.dart';

class FuncionarioPage extends StatefulWidget {
  const FuncionarioPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => MultiProvider(
          providers: [
            Provider(create: (_) => context.read<ConfigState>(),
              dispose: (_, instance) => instance.dispose() ,),
            Provider(create: (_) => context.read<AppAPI>())
          ],
          child: const FuncionarioPage(),
        )
    );
  }

  @override
  State<FuncionarioPage> createState() => _FuncionarioPageState();
}

class _FuncionarioPageState extends State<FuncionarioPage> {
  final url = signal('');
  final refresh = signal('');
  TurmaControllerApi? turmaApi;

  @override
  void initState() {
    debugPrint("URL init start${url()}");
    super.initState();
  }


  Future<Response<BuiltList<UsuarioDTO>>> _getData(UsuarioControllerApi usuarioApi, String refresh) async {
    try {
      var dado = await usuarioApi.usuarioControllerListAll();
      debugPrint("home-page:data:$dado");
      return dado;
    } on DioException catch (e) {
      debugPrint("Erro home:${e.response}");
      return Future.value([] as FutureOr<Response<BuiltList<UsuarioDTO>>>?);
    }
  }

  void _excluirFuncionario(int? id) async {
    try{
      UsuarioControllerApi? usuarioApi = context.read<AppAPI>().api.getUsuarioControllerApi();
      int idFuncionario = id!;
      var retornoExcluido = await usuarioApi.usuarioControllerRemover(id: idFuncionario);
      debugPrint("Excluido: ${retornoExcluido.data}");
      refresh.set("value");
    }on DioException catch (e) {
      debugPrint("Erro home:${e.response}");
    }
  }


  @override
  Widget build(BuildContext context) {
    UsuarioControllerApi? usuarioApi = context.read<AppAPI>().api.getUsuarioControllerApi();
    debugPrint("Build Funcionario page");

      return ListenableBuilder(
          listenable: Routefly.listenable,
          builder: (BuildContext context, Widget? child) {
            //debugPrint("testeListener");
            return Scaffold(
              body: FutureBuilder<Response<BuiltList<UsuarioDTO>>>(
                future: _getData(usuarioApi, refresh.watch(context)),
                builder:
                    (context,
                    AsyncSnapshot<Response<BuiltList<UsuarioDTO>>> snapshot) {
                  return buildListView(snapshot);
                },
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Routefly.pushNavigate(
                      routePaths.funcionarios.funcionarioInclude);
                },
                child: const Icon(Icons.add),
              ),
            );
          });
  }

  Widget buildListView(AsyncSnapshot<Response<BuiltList<UsuarioDTO>>> snapshot) {
    if (snapshot.hasData) {
      return ListView.builder(
        itemCount: snapshot.data?.data?.length,
        itemBuilder: (BuildContext context, int index) {
          debugPrint("Index:$index");
          return Center(
              child: Container(
                //height: 100,
                //width: 200,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Colors.blue.withAlpha(70),
                  elevation: 10,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: const Icon(Icons.account_box, size: 60),
                        title: Text("Nome:${snapshot.data!.data?[index].pessoaNome}",
                            style: const TextStyle(fontSize: 22.0)),
                        subtitle: Text(
                            "Cargo:${snapshot.data!.data?[index].cargo}",
                            style: const TextStyle(fontSize: 18.0)),

                      ),
                      ButtonBar(
                        children: <Widget>[
                          ElevatedButton(
                            child: const Text('Editar'),
                            onPressed: () {
                              Routefly.pushNavigate('${routePaths.funcionarios.path}/${snapshot.data!.data?[index].id}' );
                            },
                          ),
                          ElevatedButton(
                            child: const Text('Excluir'),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('TEstes'),
                                    content: Text(
                                      'Deseja excluir : ${snapshot.data!.data?[index].pessoaNome}?'
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: Text('Cancelar')
                                      ),
                                      TextButton(
                                          onPressed: () {
                                            _excluirFuncionario(snapshot.data!.data?[index].id);
                                            Navigator.pop(context);
                                            },
                                          child: Text('Excluir')
                                      )
                                    ],
                                  )
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ));
        },
      );
    } else if (snapshot.hasError) {
      return const Text('Erro ao acessar dados');
    } else {
      return const CircularProgressIndicator();
    }
  }

  Text buildItemList(
      AsyncSnapshot<Response<BuiltList<UsuarioDTO>>> snapshot, int index) {
    debugPrint("coisa");
    debugPrint(snapshot.data.toString());
    return Text("nome:${snapshot.data!.data?[index]}");
  }



  @override
  dispose(){
    debugPrint("Disponse call ed;");
    super.dispose();
  }
  @override
  deactivate(){
    debugPrint("Deactivate");
    super.deactivate();
  }

  @override
  void activate() {
    debugPrint("HOme activate");
    // TODO: implement activate
    super.activate();
  }
  @override
  void didChangeDependencies() {
    print("didChangeDependencies");
    super.didChangeDependencies();
  }


}