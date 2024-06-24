import 'package:flutter/material.dart';

class CargoSelection extends StatefulWidget {
  final Function(String) onSaved;
  final String? cargoInicial; // Adicione o parâmetro inicial
  const CargoSelection({Key? key, required this.onSaved, this.cargoInicial}) : super(key: key);

  @override
  State<CargoSelection> createState() => _CargoSelectionState();
}

class _CargoSelectionState extends State<CargoSelection> {
  String? _selectedCargo;
  final List<String> _cargos = ['ADMIN', 'SECRETARIA', 'COORDENADORA'];

  @override
  void initState() {
    super.initState();
    _selectedCargo = widget.cargoInicial; // Use o valor inicial
  }

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