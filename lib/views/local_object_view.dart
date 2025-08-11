import 'package:ar_flutter_plugin_updated/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin_updated/widgets/ar_view.dart';
import 'package:flutter/material.dart';

import 'local_object_viewmodel.dart';

class LocalObjectView extends StatefulWidget {
  final String initialModel;

  const LocalObjectView({super.key, required this.initialModel});

  @override
  State<LocalObjectView> createState() => _LocalObjectViewState();
}

class _LocalObjectViewState extends State<LocalObjectView> {
  late final LocalObjectViewModel viewModel;
  bool hasObjectPlaced = false;

  @override
  void initState() {
    super.initState();
    viewModel = LocalObjectViewModel(widget.initialModel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ARView(
            onARViewCreated: (session, object, anchor, location) async {
              await viewModel.initAR(session, object, anchor);
            },
            planeDetectionConfig: PlaneDetectionConfig.horizontal,
          ),
          Positioned(
            bottom: 30,
            left: 30,
            right: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: viewModel.onRemoveEverything,
                  child: const Text('Remover Tudo'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
