import 'package:flutter/material.dart';
import '../models/ar_model_drive.dart';
import 'local_object_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ARModelRepository _repository = ARModelRepository();

  @override
  void initState() {
    super.initState();
    _prepareAssets();
  }

  Future<void> _prepareAssets() async {
    await _repository.copyAssetToDocuments('sinoMissoes.glb');
    await _repository.copyAssetToDocuments('SaoMiguel_30k.glb');
  }

  void _openAR(String model) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LocalObjectView(initialModel: model),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _openAR('sinoMissoes.glb'),
              child: const Text("Sino Missoes"),
            ),
            ElevatedButton(
              onPressed: () => _openAR('SaoMiguel_30k.glb'),
              child: const Text("Sao Miguel 30k"),
            ),
          ],
        ),
      ),
    );
  }
}
