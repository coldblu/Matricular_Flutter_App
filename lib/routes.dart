import 'package:routefly/routefly.dart';

import 'app/funcionarios/funcionario_page.dart' as a0;
import 'app/home/home_page.dart' as a1;
import 'app/login/login_page.dart' as a2;
import 'app/prefers/prefers_page.dart' as a3;
import 'app/turma/turma_page.dart' as a4;
import 'app/turmas/turma_page.dart' as a5;

List<RouteEntity> get routes => [
  RouteEntity(
    key: '/funcionarios/funcionario',
    uri: Uri.parse('/funcionarios/funcionario'),
    routeBuilder: (ctx, settings) => Routefly.defaultRouteBuilder(
      ctx,
      settings,
      const a0.FuncionarioPage(),
    ),
  ),
  RouteEntity(
    key: '/home',
    uri: Uri.parse('/home'),
    routeBuilder: (ctx, settings) => Routefly.defaultRouteBuilder(
      ctx,
      settings,
      const a1.HomePage(),
    ),
  ),
  RouteEntity(
    key: '/login',
    uri: Uri.parse('/login'),
    routeBuilder: (ctx, settings) => Routefly.defaultRouteBuilder(
      ctx,
      settings,
      const a2.LoginPage(),
    ),
  ),
  RouteEntity(
    key: '/prefers',
    uri: Uri.parse('/prefers'),
    routeBuilder: (ctx, settings) => Routefly.defaultRouteBuilder(
      ctx,
      settings,
      const a3.PrefsPage(),
    ),
  ),
  RouteEntity(
    key: '/turma',
    uri: Uri.parse('/turma'),
    routeBuilder: (ctx, settings) => Routefly.defaultRouteBuilder(
      ctx,
      settings,
      a4.TurmaPage(),
    ),
  ),
  RouteEntity(
    key: '/turmas/turma',
    uri: Uri.parse('/turmas/turma'),
    routeBuilder: (ctx, settings) => Routefly.defaultRouteBuilder(
      ctx,
      settings,
      const a5.TurmaPage(),
    ),
  ),
];

const routePaths = (
  path: '/',
  funcionarios: (
    path: '/funcionarios',
    funcionario: '/funcionarios/funcionario',
  ),
  home: '/home',
  login: '/login',
  prefers: '/prefers',
  turma: '/turma',
  turmas: (
    path: '/turmas',
    turma: '/turmas/turma',
  ),
);
