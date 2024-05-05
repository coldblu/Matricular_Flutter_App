import 'package:flutter/material.dart';

import 'package:matricular/matricular.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:built_collection/built_collection.dart';
import 'package:routefly/routefly.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signals/signals_flutter.dart';

import '../../routes.dart';

class TurmaPage extends StatefulWidget {
  const TurmaPage({super.key});


  @override
  State<TurmaPage> createState() => _TurmaPageState();
}

class _TurmaPageState extends State<TurmaPage> {
  final url = signal('');
  TurmaControllerApi? turmaApi;

  @override
  void initState() {
    _loadPreferences();
    debugPrint("URL init start${url()}");
    super.initState();
  }

  // Method to load the shared preference data
  void _loadPreferences() {
    //WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    SharedPreferences.getInstance().then((value) {
      url.set(value.getString('URL') ?? 'http://192.168.10.100');
      turmaApi = Matricular(basePathOverride: url()).getTurmaControllerApi();
    });
  }

  Future<Response<BuiltList<TurmaDTO>>> _getData() async {
    SharedPreferences pf = await SharedPreferences.getInstance();
    url.set(pf.getString('URL') ?? 'http://192.168.10.100');

    turmaApi = Matricular(basePathOverride: url(),interceptors: [

    ]).getTurmaControllerApi();
    var dado = await turmaApi?.turmaControllerListAll();
    print(dado);
    if (dado != null) {
      return dado;
    }
    return Future.value([] as FutureOr<Response<BuiltList<TurmaDTO>>>?);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Build Home page student");
    return Scaffold(
      body: FutureBuilder<Response<BuiltList<TurmaDTO>>>(
          future: _getData(),
          builder:
              (context, AsyncSnapshot<Response<BuiltList<TurmaDTO>>> snapshot) {
            return buildListView(snapshot);
          }),
    );
  }

  Widget buildListView(AsyncSnapshot<Response<BuiltList<TurmaDTO>>> snapshot) {
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
                        title: Text("nome:${snapshot.data!.data?[index].titulo}",
                            style: const TextStyle(fontSize: 22.0)),
                        subtitle: Text(
                            "curso:${snapshot.data!.data?[index].turno}",
                            style: const TextStyle(fontSize: 18.0)),
                      ),
                      ButtonBar(
                        children: <Widget>[
                          ElevatedButton(
                            child: const Text('Editar'),
                            onPressed: () {
                              /* ... */
                            },
                          ),
                          ElevatedButton(
                            child: const Text('Excluir'),
                            onPressed: () {
                              /* ... */
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
      AsyncSnapshot<Response<BuiltList<TurmaDTO>>> snapshot, int index) {
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