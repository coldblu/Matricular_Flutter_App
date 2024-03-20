import 'package:flutter/material.dart';

class CadastroPage extends StatefulWidget {

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text("Pagina de Cadastro"),
        ),
        body: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                Flexible(
                  fit: FlexFit.tight,
                  flex: 5,
                  child: Image.asset('assets/images/logo.png'), //   <--- image
                ),
                  
                const TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  initialValue: 'Teste',
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(
                      Icons.visibility_off_outlined,
                    )
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Login'),
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: (){
                    }, 
                    child: const Text(
                      "Cadastrar",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(0, 0, 0, 0.5),
                       ),
                      ),
                  ),                
                ),
              ]),
            )));
  }
}

class RegisterScreen {
}
