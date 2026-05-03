import 'package:flutter/material.dart';
import '../model/pasien.dart';

class PasienForm extends StatefulWidget {
  const PasienForm({super.key});

  @override
  State<PasienForm> createState() => _PasienFormState();
}

class _PasienFormState extends State<PasienForm> {
  final _formKey = GlobalKey<FormState>();
  final _namaPasienCtrl = TextEditingController();
  final _noRekamMedisCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Pasien')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _fieldNamaPasien(),
              const SizedBox(height: 20),
              _fieldNoRekamMedis(),
              const SizedBox(height: 20),
              _tombolSimpan(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fieldNamaPasien() {
    return TextFormField(
      controller: _namaPasienCtrl,
      decoration: const InputDecoration(
        labelText: 'Nama Pasien',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Nama pasien tidak boleh kosong';
        }
        return null;
      },
    );
  }

  Widget _fieldNoRekamMedis() {
    return TextFormField(
      controller: _noRekamMedisCtrl,
      decoration: const InputDecoration(
        labelText: 'No. Rekam Medis',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'No. Rekam Medis tidak boleh kosong';
        }
        return null;
      },
    );
  }

  Widget _tombolSimpan() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState?.validate() != true) return;

        final addedPasien = Pasien(
          namaPasien: _namaPasienCtrl.text.trim(),
          noRekamMedis: _noRekamMedisCtrl.text.trim(),
        );
        Navigator.pop(context, addedPasien);
      },
      child: const Text('Simpan'),
    );
  }

  @override
  void dispose() {
    _namaPasienCtrl.dispose();
    _noRekamMedisCtrl.dispose();
    super.dispose();
  }
}
