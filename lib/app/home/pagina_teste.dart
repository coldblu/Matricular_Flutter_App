import 'package:flutter/cupertino.dart';

class NewPageScreen extends StatelessWidget {
  final String texto;

  const NewPageScreen(this.texto, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(texto),
      ),
    );
  }
}
