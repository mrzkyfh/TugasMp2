import 'package:flutter/material.dart';
import '../model/pegawai.dart';
import 'pegawai_detail.dart';

class PegawaiUpdateForm extends StatefulWidget {
  final Pegawai pegawai;

  const PegawaiUpdateForm({super.key, required this.pegawai});

  @override
  State<PegawaiUpdateForm> createState() => _PegawaiUpdateFormState();
}

class _PegawaiUpdateFormState extends State<PegawaiUpdateForm> {
  final _formKey = GlobalKey<FormState>();
  final _namaPegawaiCtrl = TextEditingController();
  final _jabatanCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _namaPegawaiCtrl.text = widget.pegawai.namaPegawai;
    _jabatanCtrl.text = widget.pegawai.jabatan;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ubah Pegawai')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
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
        if (_formKey.currentState?.validate() != true) {
          return;
        }

        final updatedPegawai = Pegawai(
          namaPegawai: _namaPegawaiCtrl.text.trim(),
          jabatan: _jabatanCtrl.text.trim(),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PegawaiDetail(pegawai: updatedPegawai),
          ),
        );
      },
      child: const Text('Simpan Perubahan'),
    );
  }

  @override
  void dispose() {
    _namaPegawaiCtrl.dispose();
    _jabatanCtrl.dispose();
    super.dispose();
  }
}
