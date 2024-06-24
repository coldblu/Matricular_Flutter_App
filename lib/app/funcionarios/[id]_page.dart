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

class FuncionarioEditPage extends StatefulWidget {
  const FuncionarioEditPage({super.key});

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
          child: const FuncionarioEditPage(),
        )
    );
  }

  @override
  State<FuncionarioEditPage> createState() => _FuncionarioEditPageState();
}

class _FuncionarioEditPageState extends State<FuncionarioEditPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var pessoaNome = null;
  var pessoaCPF = null;
  var email = null;
  var cargo = null;
  var pessoaTelefone = null;
  String? _selectedCargo;
  final List<String> _cargos = ['ADMIN', 'SECRETARIA(O)', 'COORDENADORA(O)'];
  final idValue = signal<int?>(null);
  
  AppAPI? appAPI;

  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() {
    if (appAPI == null) {
      appAPI = context.read<AppAPI>();
      idValue.set(Routefly.query['id'] ?? idValue());
      _loadUserData();
    }
  }

  Future<Response<UsuarioDTO>> _loadUserData() async {
   // if(pessoaNome == null && pessoaCPF == null && email == null && cargo == null && pessoaTelefone == null) {
      try {
        final usuarioResponse = await appAPI?.api.getUsuarioControllerApi()
            .usuarioControllerObterPorId(id: idValue() ?? -1);
        if (usuarioResponse != null && usuarioResponse.data != null) {
          setState(() {
            final usuarioDto = usuarioResponse.data;
            pessoaNome = usuarioDto!.pessoaNome;
            pessoaCPF = usuarioDto.pessoaCpf;
            email = usuarioDto.email;
            var cargoDoBack;
            cargoDoBack = usuarioDto.cargo;
            cargo = cargoDoBack.name;
            pessoaTelefone = usuarioDto.pessoaTelefone;
          });
        }
        return Future.value(Response<UsuarioDTO>(data: usuarioResponse?.data,
            requestOptions: usuarioResponse!.requestOptions));
      } on DioException catch (e) {
        debugPrint("Erro home:${e.response}");
        return Future.value([] as FutureOr<Response<UsuarioDTO>>?);
      }
    //}
  }

  void _setData() async {
    final usuarioApi = appAPI?.api.getUsuarioControllerApi();
    try {
      UsuarioAlterarDTOBuilder usuarioDTO = UsuarioAlterarDTOBuilder();
      usuarioDTO.pessoaNome = pessoaNome;
      usuarioDTO.pessoaCpf = pessoaCPF;
      usuarioDTO.email = email;
      usuarioDTO.cargo = UsuarioAlterarDTOCargoEnum.valueOf(cargo);
      usuarioDTO.pessoaTelefone = pessoaTelefone;
      usuarioDTO.idUsuarioRequisicao = Routefly.query['id'];
      var response = await usuarioApi?.usuarioControllerNovoAlterar(usuarioAlterarDTO: usuarioDTO.build(), id: Routefly.query['id'] ?? idValue());
      if(response?.statusCode == 200){
        debugPrint("ok alterado");
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

      _setData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Alterar Funcionário'),
        ),
        body: FutureBuilder<Response<UsuarioDTO>>(
          future: pessoaNome == null ? _loadUserData() : null,
          builder: (context, AsyncSnapshot<Response<UsuarioDTO>> snapshot) {
              return _buildForm(snapshot);
            },
        )
    );

  }

  Widget _buildForm(AsyncSnapshot<Response<UsuarioDTO>> snapshot) {
    if (snapshot.hasData) {
      return Form(
        key: _formKey, // Associate the form key with this Form widget
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Nome completo'),
                initialValue: pessoaNome,
                validator: (value) {
                  // Validation function for the name field
                  if (value!.isEmpty) {
                    return 'Insira o nome.'; // Return an error message if the name is empty
                  } else if (value.length < 10) {
                    return 'O nome deve ter pelo menos 10 caracteres.'; // Return error if less than 6 chars
                  }
                  return null; // Return null if the name is valid
                },
                onSaved: (value) => pessoaNome = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'CPF'),
                initialValue: pessoaCPF,
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
                onSaved: (value) => pessoaCPF = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                initialValue: email,
                keyboardType: TextInputType.emailAddress,
                // Label for the name field
                validator: (value) {
                  // Validation function for the name field
                  if (value!.isEmpty) {
                    return 'Insira o email.'; // Return an error message if the name is empty
                  }
                  return null; // Return null if the name is valid
                },
                onSaved: (value) => email = value!,
              ),
              CargoSelection(
                  onSaved: (value) => cargo = value,
                  cargoInicial: cargo
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Telefone'),
                initialValue: pessoaTelefone,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  // Use a package like 'brasil_inputs' for phone mask
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
                onSaved: (value) => pessoaTelefone = value!,
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Atualizar'),
              ),
            ],
          ),
        ),
      );
    } else if (snapshot.hasError) {
      return Text('Ocorreu um erro ao carregar os dados do usuário: ${snapshot.error}');
    } else {
      return CircularProgressIndicator();
    }
  }




  // void initData(BuildContext context) {
  //   if(appAPI == null){
  //     appAPI = context.read<AppAPI>();
  //     idValue.set(Routefly.query['id'] ?? idValue());
  //     appAPI?.api.getUsuarioControllerApi().usuarioControllerObterPorId(id: idValue()??0)
  //         .then((usuarioResponse) {
  //       var usuarioDto = usuarioResponse.data;
  //       pessoaNome = usuarioDto!.pessoaNome;
  //       pessoaCPF = usuarioDto.pessoaCpf;
  //       email = usuarioDto.email;
  //       cargo = usuarioDto.cargo;
  //       pessoaTelefone = usuarioDto.pessoaTelefone;
  //       senha = usuarioDto.senha;
  //     },);
  //   }
  // }
}
