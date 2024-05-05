import 'package:flutter/material.dart';

class TurmaPage extends StatefulWidget {
  const TurmaPage({super.key});


  @override
  State<TurmaPage> createState() => _TurmaPageState();
}

class _TurmaPageState extends State<TurmaPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Turmas'),
        ),
    );
  }
}