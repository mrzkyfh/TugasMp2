import 'package:flutter/material.dart';
import '../model/poli.dart';

class PoliForm extends StatefulWidget {
  const PoliForm({super.key});

  @override
  State<PoliForm> createState() => _PoliFormState();
}

class _PoliFormState extends State<PoliForm> {
  final _formKey = GlobalKey<FormState>();
  final _namaPoliCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Poli')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _fieldNamaPoli(),
              const SizedBox(height: 20),
              _tombolSimpan(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fieldNamaPoli() {
    return TextFormField(
      controller: _namaPoliCtrl,
      decoration: const InputDecoration(
        labelText: 'Nama Poli',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Nama poli tidak boleh kosong';
        }
        return null;
      },
    );
  }

  Widget _tombolSimpan() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState?.validate() != true) return;

        final addedPoli = Poli(namaPoli: _namaPoliCtrl.text.trim());
        Navigator.pop(context, addedPoli);
      },
      child: const Text('Simpan'),
    );
  }

  @override
  void dispose() {
    _namaPoliCtrl.dispose();
    super.dispose();
  }
}
