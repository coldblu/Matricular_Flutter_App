import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:matricular/matricular.dart';
import 'package:matricular_app/app/api/AppAPI.dart';
import 'package:matricular_app/app/funcionarios/cargoSelection.dart';
import 'package:matricular_app/app/utils/config_state.dart';
import 'package:matricular_app/routes.dart';
import 'package:provider/provider.dart';
import 'package:routefly/routefly.dart';
import 'package:signals/signals.dart';
import 'package:signals/signals_flutter.dart';
import 'package:brasil_fields/brasil_fields.dart';

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
      usuarioDTO.pessoaCpf = this.pessoaCPF.replaceAll(RegExp(r'[^\d]'), '');
      usuarioDTO.email = this.email;
      usuarioDTO.cargo = UsuarioDTOCargoEnum.valueOf(this.cargo);
      usuarioDTO.pessoaTelefone = this.pessoaTelefone.replaceAll(RegExp(r'[^\d]'), '');
      usuarioDTO.senha = this.senha;

      var response = await this.usuarioApi.usuarioControllerIncluir(usuarioDTO: usuarioDTO.build());
      if(response.statusCode == 200){
        debugPrint("ok inserido");
        Routefly.navigate(
            routePaths.home.path,
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

    bool _showPassword = false;
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
                  decoration: InputDecoration(labelText: 'Nome completo'),
                  // Label for the name field
                  validator: (value) {
                    // Validation function for the name field
                    if (value!.isEmpty) {
                      return 'Insira o nome.'; // Return an error message if the name is empty
                    } else if (value.length < 10) {
                      return 'O nome deve ter pelo menos 10 caracteres.'; // Return error if less than 6 chars
                    }
                    return null; // Return null if the name is valid
                  },
                  onSaved: (value) {
                    pessoaNome = value!; // Save the entered name
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'CPF'),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    // Use a package like 'brasil_inputs' for CPF mask
                    FilteringTextInputFormatter.digitsOnly,
                    CpfInputFormatter()
                  ],
                  // Label for the email field
                  validator: (value) {
                    // Validation function for the email field
                    if (value!.isEmpty) {
                      return 'Insira o CPF.'; // Return an error message if the email is empty
                    } else if (value.length < 11) {
                      return 'O CPF deve ter pelo menos 11 dígitos.'; // Return error if less than 11 digits
                    }
                    // You can add more complex validation logic here
                    return null; // Return null if the email is valid
                  },
                  onSaved: (value) {
                    pessoaCPF = value!; // Save the entered email
                  },
                ),TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
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
                TextFormField(
                  decoration: InputDecoration(labelText: 'Telefone'),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    TelefoneInputFormatter(),
                  ],
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
                  decoration: InputDecoration(labelText: 'Senha', suffixIcon: IconButton(
                    icon: Icon(
                      // Use an icon to toggle password visibility
                      _showPassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () => setState(() => _showPassword = !_showPassword),
                  )),
                  // Label for the password field with visibility toggle
                  obscureText: !_showPassword,
                  // Label for the email field
                  validator: (value) {
                    // Validation function for the email field
                    if (value!.isEmpty) {
                      return 'Por favor, insira uma senha.'; // Return an error message if the email is empty
                    }else if (value.length < 6) {
                      return 'A senha deve ter pelo menos 6 digitos.'; // Return error if less than 6 chars
                    }
                    // You can add more complex validation logic here
                    return null; // Return null if the email is valid
                  },
                  onChanged: (value) => setState(() => senha = value!),
                  onSaved: (value) {
                    senha = value!; // Save the entered email
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Confirmar Senha'),
                  // Label for the confirm password field
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, confirme a senha.'; // Return error if confirmation is empty
                    }else if (value.length < 6) {
                      return 'A senha deve ter pelo menos 6 digitos.'; // Return error if less than 6 chars
                    }
                    if (value != senha) {
                      return 'As senhas não coincidem.'; // Return error if passwords don't match
                    }
                    return null; // Return null if confirmation is valid
                  },
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancelar'),
                ),
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
