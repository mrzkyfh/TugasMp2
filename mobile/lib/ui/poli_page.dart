import 'package:flutter/material.dart';
import '../model/poli.dart';
import '../service/poli_service.dart';
import 'poli_detail.dart';
import '../widget/sidebar.dart';
import 'poli_item.dart';
import 'poli_form.dart';

class PoliPage extends StatefulWidget {
  const PoliPage({super.key});

  @override
  State<PoliPage> createState() => _PoliPageState();
}

class _PoliPageState extends State<PoliPage> {
  final List<Poli> _polies = [
    Poli(namaPoli: 'Poli Anak'),
    Poli(namaPoli: 'Poli Kandungan'),
    Poli(namaPoli: 'Poli Gigi'),
    Poli(namaPoli: 'Poli THT'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Sidebar(),
      appBar: AppBar(
        title: const Text('Data Poli'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final newPoli = await Navigator.push<Poli>(
                context,
                MaterialPageRoute(builder: (context) => const PoliForm()),
              );

              if (newPoli != null) {
                setState(() {
                  _polies.add(newPoli);
                });
              }
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _polies.length,
        itemBuilder: (context, index) {
          return PoliItem(poli: _polies[index]);
        },
      ),
    );
  }
} 