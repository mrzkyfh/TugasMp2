import 'package:flutter/material.dart';
import '../model/pegawai.dart';
import '../widget/sidebar.dart';
import 'pegawai_item.dart';
import 'pegawai_form.dart';

class PegawaiPage extends StatefulWidget {
  const PegawaiPage({super.key});

  @override
  State<PegawaiPage> createState() => _PegawaiPageState();
}

class _PegawaiPageState extends State<PegawaiPage> {
  final List<Pegawai> _pegawais = [
    Pegawai(namaPegawai: 'Budi Santoso', jabatan: 'Dokter'),
    Pegawai(namaPegawai: 'Siti Nurhaliza', jabatan: 'Perawat'),
    Pegawai(namaPegawai: 'Ahmad Wijaya', jabatan: 'Administrasi'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Sidebar(),
      appBar: AppBar(
        title: const Text('Data Pegawai'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final newPegawai = await Navigator.push<Pegawai>(
                context,
                MaterialPageRoute(builder: (context) => const PegawaiForm()),
              );

              if (newPegawai != null) {
                setState(() {
                  _pegawais.add(newPegawai);
                });
              }
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _pegawais.length,
        itemBuilder: (context, index) {
          return PegawaiItem(pegawai: _pegawais[index]);
        },
      ),
    );
  }
}
