import 'package:flutter/material.dart';
import '../model/pasien.dart';
import 'pasien_detail.dart';

class PasienUpdateForm extends StatefulWidget {
  final Pasien pasien;

  const PasienUpdateForm({super.key, required this.pasien});

  @override
  State<PasienUpdateForm> createState() => _PasienUpdateFormState();
}

class _PasienUpdateFormState extends State<PasienUpdateForm> {
  final _formKey = GlobalKey<FormState>();
  final _namaPasienCtrl = TextEditingController();
  final _noRekamMedisCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _namaPasienCtrl.text = widget.pasien.namaPasien;
    _noRekamMedisCtrl.text = widget.pasien.noRekamMedis;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ubah Pasien')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
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
        if (_formKey.currentState?.validate() != true) {
          return;
        }

        final updatedPasien = Pasien(
          namaPasien: _namaPasienCtrl.text.trim(),
          noRekamMedis: _noRekamMedisCtrl.text.trim(),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PasienDetail(pasien: updatedPasien),
          ),
        );
      },
      child: const Text('Simpan Perubahan'),
    );
  }

  @override
  void dispose() {
    _namaPasienCtrl.dispose();
    _noRekamMedisCtrl.dispose();
    super.dispose();
  }
}
