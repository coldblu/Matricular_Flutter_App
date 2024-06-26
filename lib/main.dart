import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:routefly/routefly.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/api/AppAPI.dart';
import 'app/utils/config_state.dart';
import 'app/utils/security-store.dart';
import 'routes.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //SharedPreferences prefs = await SharedPreferences.getInstance();
  final storage = SecurityStore();
  final state = ConfigState(prefs: storage);
  final appAPI = AppAPI(config: state);
  runApp(
      MultiProvider(
        providers: [
          Provider(create: (_) => state,
            dispose: (_, instance) => instance.dispose() ,),
          Provider(create: (_) => appAPI,
            dispose: (_, instance) => instance.dispose(),)
        ],
        child: const MyApp(),
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
     return MaterialApp.router(
      routerConfig: Routefly.routerConfig(
        routes: routes, // GENERATED
        initialPath: routePaths.login,
        routeBuilder: (context, settings, child) {
          return MaterialPageRoute(
            settings: settings, // !! IMPORTANT !!
            builder: (context) => child,
          
          );
        },
      ),
      debugShowCheckedModeBanner: false,

      title: 'Aplicação Login',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      //home: const LoginPage(title: 'Login Page'),
    );
  }
}


