import 'package:routefly/routefly.dart';

import 'app/cadastro/cadastro_page.dart' as a0;
import 'app/login/login_page.dart' as a1;

List<RouteEntity> get routes => [
  RouteEntity(
    key: '/cadastro',
    uri: Uri.parse('/cadastro'),
    routeBuilder: (ctx, settings) => Routefly.defaultRouteBuilder(
      ctx,
      settings,
      a0.CadastroPage(),
    ),
  ),
  RouteEntity(
    key: '/login',
    uri: Uri.parse('/login'),
    routeBuilder: (ctx, settings) => Routefly.defaultRouteBuilder(
      ctx,
      settings,
      a1.LoginPage(),
    ),
  ),
];

const routePaths = (
  path: '/',
  cadastro: '/cadastro',
  login: '/login',
);
