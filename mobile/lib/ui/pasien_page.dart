import 'package:flutter/material.dart';
import '../model/pasien.dart';
import '../widget/sidebar.dart';
import 'pasien_item.dart';
import 'pasien_form.dart';

class PasienPage extends StatefulWidget {
  const PasienPage({super.key});

  @override
  State<PasienPage> createState() => _PasienPageState();
}

class _PasienPageState extends State<PasienPage> {
  final List<Pasien> _pasiens = [
    Pasien(namaPasien: 'Rina Wijaya', noRekamMedis: 'RM001'),
    Pasien(namaPasien: 'Bambang Sutrisno', noRekamMedis: 'RM002'),
    Pasien(namaPasien: 'Dewi Lestari', noRekamMedis: 'RM003'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Sidebar(),
      appBar: AppBar(
        title: const Text('Data Pasien'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final newPasien = await Navigator.push<Pasien>(
                context,
                MaterialPageRoute(builder: (context) => const PasienForm()),
              );

              if (newPasien != null) {
                setState(() {
                  _pasiens.add(newPasien);
                });
              }
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _pasiens.length,
        itemBuilder: (context, index) {
          return PasienItem(pasien: _pasiens[index]);
        },
      ),
    );
  }
}
