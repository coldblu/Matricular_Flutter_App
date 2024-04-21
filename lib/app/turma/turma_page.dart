import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matricular_app/app/home/pagina_teste.dart';

class TurmaPage extends StatefulWidget {

  @override
  State<TurmaPage> createState() => _TurmaPageState();
}

class _TurmaPageState extends State<TurmaPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text('Turmas'),
        ),
    );
  }
}