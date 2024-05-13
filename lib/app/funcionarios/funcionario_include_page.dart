import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:matricular/matricular.dart';
import 'package:matricular_app/app/api/AppAPI.dart';
import 'package:matricular_app/app/funcionarios/cargoSelection.dart';
import 'package:matricular_app/app/utils/config_state.dart';
import 'package:matricular_app/routes.dart';
import 'package:provider/provider.dart';
import 'package:routefly/routefly.dart';
import 'package:signals/signals.dart';
import 'package:signals/signals_flutter.dart';

class FuncionarioIncludePage extends StatefulWidget {
  const FuncionarioIncludePage({super.key});

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
              child: const FuncionarioIncludePage(),
        )
    );
  }

  @override
  State<FuncionarioIncludePage> createState() => _FuncionarioIncludePageState();
}

class _FuncionarioIncludePageState extends State<FuncionarioIncludePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var pessoaNome;
  var pessoaCPF;
  var email;
  var cargo;
  var pessoaTelefone;
  var senha;
  String? _selectedCargo;
  final List<String> _cargos = ['ADMIN', 'SECRETARIA', 'COORDENADORA'];


  late AppAPI appAPI;
  late UsuarioControllerApi usuarioApi;

  void _setData() async {
    try {
      UsuarioDTOBuilder usuarioDTO = UsuarioDTOBuilder();
      usuarioDTO.pessoaNome = this.pessoaNome;
      usuarioDTO.pessoaCpf = this.pessoaCPF;
      usuarioDTO.email = this.email;
      usuarioDTO.cargo = UsuarioDTOCargoEnum.valueOf(this.cargo);
      usuarioDTO.pessoaTelefone = this.pessoaTelefone;
      usuarioDTO.senha = this.senha;

      var response = await this.usuarioApi.usuarioControllerIncluir(usuarioDTO: usuarioDTO.build());
      if(response.statusCode == 200){
        debugPrint("ok inserido");
        Routefly.navigate(
            routePaths.home,
            arguments: 1
        );
      }else {
        message() {
          //showMessage(context, "Login Falhou: ${response.data}");
        }
        message();
      }
    } on DioException catch (e) {
      debugPrint("Erro:${e.response}");
      return Future.value([] as FutureOr<Response<BuiltList<UsuarioDTO>>>?);
    }
  }

  void _submitForm() {
    // Check if the form is valid
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Save the form data

      print('Nome: $pessoaNome');
      print('CPF: $pessoaCPF');
      print('Email: $email');
      print('Cargo: $cargo');
      print('Telefone: $pessoaTelefone');
      print('Senha: $senha');

      _setData();
    }
  }


  @override
  Widget build(BuildContext context) {
    appAPI = context.read<AppAPI>();
    usuarioApi = appAPI.api.getUsuarioControllerApi();

    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Funcionário'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey, // Associate the form key with this Form widget
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Nome'),
                  // Label for the name field
                  validator: (value) {
                    // Validation function for the name field
                    if (value!.isEmpty) {
                      return 'Insira o nome.'; // Return an error message if the name is empty
                    }
                    return null; // Return null if the name is valid
                  },
                  onSaved: (value) {
                    pessoaNome = value!; // Save the entered name
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'CPF'),
                  // Label for the email field
                  validator: (value) {
                    // Validation function for the email field
                    if (value!.isEmpty) {
                      return 'Insira o CPF.'; // Return an error message if the email is empty
                    }
                    // You can add more complex validation logic here
                    return null; // Return null if the email is valid
                  },
                  onSaved: (value) {
                    pessoaCPF = value!; // Save the entered email
                  },
                ),TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  // Label for the name field
                  validator: (value) {
                    // Validation function for the name field
                    if (value!.isEmpty) {
                      return 'Insira o email.'; // Return an error message if the name is empty
                    }
                    return null; // Return null if the name is valid
                  },
                  onSaved: (value) {
                    email = value!; // Save the entered name
                  },
                ),
                CargoSelection(
                  onSaved: (value) => cargo = value, // Concise saving
                ),
                // TextFormField(
                //   decoration: InputDecoration(labelText: 'Cargo'),
                //   // Label for the email field
                //   validator: (value) {
                //     // Validation function for the email field
                //     if (value!.isEmpty) {
                //       return 'Insira o cargo.'; // Return an error message if the email is empty
                //     }
                //     // You can add more complex validation logic here
                //     return null; // Return null if the email is valid
                //   },
                //   onSaved: (value) {
                //     cargo = value!; // Save the entered email
                //   },
                // ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Telefone'),
                  // Label for the name field
                  validator: (value) {
                    // Validation function for the name field
                    if (value!.isEmpty) {
                      return 'Insira o telefone.'; // Return an error message if the name is empty
                    }
                    return null; // Return null if the name is valid
                  },
                  onSaved: (value) {
                    pessoaTelefone = value!; // Save the entered name
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Senha'),
                  // Label for the email field
                  validator: (value) {
                    // Validation function for the email field
                    if (value!.isEmpty) {
                      return 'Por favor, insira uma senha.'; // Return an error message if the email is empty
                    }
                    // You can add more complex validation logic here
                    return null; // Return null if the email is valid
                  },
                  onSaved: (value) {
                    senha = value!; // Save the entered email
                  },
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: _submitForm,
                  // Call the _submitForm function when the button is pressed
                  child: Text('Cadastrar'), // Text on the button
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
