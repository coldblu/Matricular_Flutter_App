import 'package:flutter/material.dart';
import 'package:matricular_app/app/funcionarios/funcionario_page.dart';
import 'package:matricular_app/app/home/pagina_teste.dart';
import 'package:matricular_app/app/home/painel_page.dart';
import 'package:routefly/routefly.dart';

import '../turmas/turma_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _indiceAtual = 0; // Variável para controlar o índice das telas
  final List<Widget> _telas = [
    const PainelPage(),
    const FuncionarioPage(),
    const TurmaPage()
  ];


  void onTabTapped(int index) {
    setState(() {
      _indiceAtual = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Tela Principal'),
        ),
      body: _telas[_indiceAtual],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceAtual,
        onTap: onTabTapped, //Chamando método ao clicar em uma das opções
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Início",
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.group),
              label: "Funcionarios"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.class_),
              label: "Turmas"
          ),
        ],
      ),
    );
  }
}