import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:matricular/matricular.dart';
import 'package:matricular_app/app/api/AppAPI.dart';
import 'package:matricular_app/app/utils/config_state.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:async';

import 'package:signals/signals.dart';

class PainelPage extends StatefulWidget {
  const PainelPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => MultiProvider(
        providers: [
          Provider(
            create: (_) => context.read<ConfigState>(),
            dispose: (_, instance) => instance.dispose(),
          ),
          Provider(create: (_) => context.read<AppAPI>())
        ],
        child: const PainelPage(),
      ),
    );
  }

  @override
  State<PainelPage> createState() => _PainelPageState();
}

class _PainelPageState extends State<PainelPage> {
  final url = signal('');
  AppAPI? appAPI;

  int matriculasAtivas = 0;
  int matriculasInativas = 0;
  int matriculasValidacao = 0;
  int matriculasRenovacao = 0;
  int totalMatriculas = 0;
  final Completer<void> _dataLoadedCompleter = Completer<void>();

  Future<void> _loadData() async {
    try {
      final matriculaApi = await appAPI?.api.getMatriculaControllerApi();
      if (matriculaApi != null) {
        final ativas = await matriculaApi.matriculaControllerCount({MatriculaDTOStatusEnum.ATIVO}, statusMatricula: 'ATIVO');
        final inativas = await matriculaApi.matriculaControllerCount({MatriculaDTOStatusEnum.INATIVO}, statusMatricula: 'INATIVO');
        final renovacao = await matriculaApi.matriculaControllerCount({MatriculaDTOStatusEnum.AGUARDANDO_RENOVACAO}, statusMatricula: 'AGUARDANDO_RENOVACAO');
        final validacao = await matriculaApi.matriculaControllerCount({MatriculaDTOStatusEnum.AGUARDANDO_ACEITE}, statusMatricula: 'AGUARDANDO_ACEITE');

        setState(() {
          matriculasAtivas = ativas.data ?? 0;
          matriculasInativas = inativas.data ?? 0;
          matriculasRenovacao = renovacao.data ?? 0;
          matriculasValidacao = validacao.data ?? 0;
          totalMatriculas = matriculasAtivas + matriculasInativas + matriculasValidacao + matriculasRenovacao;
        });

        _dataLoadedCompleter.complete();
      }
    } on DioException catch (e) {
      debugPrint("Erro ao carregar dados: ${e.response}");
      _dataLoadedCompleter.completeError(e);
    }
  }

  @override
  void initState() {
    super.initState();
    appAPI = context.read<AppAPI>();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Build Painel page");
    return Scaffold(
      body: FutureBuilder<void>(
        future: _dataLoadedCompleter.future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar dados'));
          } else {
            return _infosMatricula();
          }
        },
      ),
    );
  }

  Widget _infosMatricula() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Matrículas:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                            color: Colors.blue,
                            value: matriculasAtivas.toDouble(),
                            title: '${matriculasAtivas}',
                            radius: 60,
                            titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          PieChartSectionData(
                            color: Colors.orange,
                            value: matriculasInativas.toDouble(),
                            title: '${matriculasInativas}',
                            radius: 60,
                            titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          PieChartSectionData(
                            color: Colors.green,
                            value: matriculasValidacao.toDouble(),
                            title: '${matriculasValidacao}',
                            radius: 60,
                            titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          PieChartSectionData(
                            color: Colors.red,
                            value: matriculasRenovacao.toDouble(),
                            title: '${matriculasRenovacao}',
                            radius: 60,
                            titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ],
                        centerSpaceRadius: 40,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLegendItem(Colors.blue, 'Ativas'),
                      const SizedBox(height: 10),
                      _buildLegendItem(Colors.orange, 'Inativas'),
                      const SizedBox(height: 10),
                      _buildLegendItem(Colors.green, 'Validação'),
                      const SizedBox(height: 10),
                      _buildLegendItem(Colors.red, 'Renovação'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total:', style: TextStyle(fontSize: 16)),
                Text('$totalMatriculas', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          color: color,
        ),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }
}
