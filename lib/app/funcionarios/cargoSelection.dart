import 'package:flutter/material.dart';

class CargoSelection extends StatefulWidget {
  final Function(String) onSaved;

  const CargoSelection({Key? key, required this.onSaved}) : super(key: key);

  @override
  State<CargoSelection> createState() => _CargoSelectionState();
}

class _CargoSelectionState extends State<CargoSelection> {
  String? _selectedCargo;
  final List<String> _cargos = ['ADMIN', 'SECRETARIA', 'COORDENADORA'];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: _selectedCargo,
      hint: const Text('Selecione o Cargo'),
      items: _cargos.map((cargo) {
        return DropdownMenuItem<String>(
          value: cargo,
          child: Text(cargo),
        );
      }).toList(),
      validator: (value) {
        if (value == null) {
          return 'Selecione um cargo';
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          _selectedCargo = value;
        });
        widget.onSaved(value!); // Call onSaved immediately
      },
    );
  }
}