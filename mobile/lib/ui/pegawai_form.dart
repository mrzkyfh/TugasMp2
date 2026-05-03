import 'package:flutter/material.dart';
import '../model/pegawai.dart';

class PegawaiForm extends StatefulWidget {
  const PegawaiForm({super.key});

  @override
  State<PegawaiForm> createState() => _PegawaiFormState();
}

class _PegawaiFormState extends State<PegawaiForm> {
  final _formKey = GlobalKey<FormState>();
  final _namaPegawaiCtrl = TextEditingController();
  final _jabatanCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Pegawai')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _fieldNamaPegawai(),
              const SizedBox(height: 20),
              _fieldJabatan(),
              const SizedBox(height: 20),
              _tombolSimpan(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fieldNamaPegawai() {
    return TextFormField(
      controller: _namaPegawaiCtrl,
      decoration: const InputDecoration(
        labelText: 'Nama Pegawai',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Nama pegawai tidak boleh kosong';
        }
        return null;
      },
    );
  }

  Widget _fieldJabatan() {
    return TextFormField(
      controller: _jabatanCtrl,
      decoration: const InputDecoration(
        labelText: 'Jabatan',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Jabatan tidak boleh kosong';
        }
        return null;
      },
    );
  }

  Widget _tombolSimpan() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState?.validate() != true) return;

        final addedPegawai = Pegawai(
          namaPegawai: _namaPegawaiCtrl.text.trim(),
          jabatan: _jabatanCtrl.text.trim(),
        );
        Navigator.pop(context, addedPegawai);
      },
      child: const Text('Simpan'),
    );
  }

  @override
  void dispose() {
    _namaPegawaiCtrl.dispose();
    _jabatanCtrl.dispose();
    super.dispose();
  }
}
