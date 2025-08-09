//Other custom imports
import 'dart:io';

// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

//AR Flutter Plugin
import 'package:ar_flutter_plugin_updated/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin_updated/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin_updated/datatypes/node_types.dart';
import 'package:ar_flutter_plugin_updated/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin_updated/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin_updated/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin_updated/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin_updated/models/ar_node.dart';
import 'package:ar_flutter_plugin_updated/widgets/ar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vector_math/vector_math_64.dart';

class LocalObjectView extends StatefulWidget {
  const LocalObjectView({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<LocalObjectView> createState() => _LocalObjectViewState();
}

class _LocalObjectViewState extends State<LocalObjectView> {
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  //String localObjectReference;
  ARNode? localObjectNode;
  //String webObjectReference;
  ARNode? webObjectNode;
  ARNode? fileSystemNode;
  HttpClient? httpClient;

  @override
  void dispose() {
    super.dispose();
    arSessionManager!.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Local & Web Objects'),
      ),
      body: Stack(
        children: [
          ARView(
            onARViewCreated: onARViewCreated,
            planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
          ),
          Align(
            alignment: FractionalOffset.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed:() => onLocalObjectAtOriginButtonPressed('SinoMissoes.glb'),
                      child: Text("Sino Missoes"),
                    ),
                    ElevatedButton(
                      onPressed:() => onLocalObjectAtOriginButtonPressed('SaoMiguel_30k.glb'),
                      child: Text("Sao Miguel 30k"),
                    ),
                  ],
                ),                  
              ],
            ),
          ),
        ],
      ),
    );
  }

  void onARViewCreated(
    ARSessionManager arSessionManager,
    ARObjectManager arObjectManager,
    ARAnchorManager arAnchorManager,
    ARLocationManager arLocationManager,
  ) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;

    this.arSessionManager!.onInitialize(
      showFeaturePoints: false,
      showPlanes: true,
      customPlaneTexturePath: "assets/triangle.png",
      showWorldOrigin: true,
      handleTaps: false,
    );
    _copyAssetModelsToDocumentDirectory('SaoMiguel_30k.glb');
    _copyAssetModelsToDocumentDirectory('sinoMissoes.glb');

    this.arObjectManager!.onInitialize();
  }

  Future<void> _copyAssetModelsToDocumentDirectory(String fileName) async {
    final docDir = await getApplicationDocumentsDirectory();
    final docDirPath = docDir.path;
    final file = File('$docDirPath/$fileName');
    final assetBytes = await rootBundle.load('assets/$fileName');
    final buffer = assetBytes.buffer;
    await file.writeAsBytes(buffer.asUint8List(assetBytes.offsetInBytes, assetBytes.lengthInBytes));
  }

  Future<void> onLocalObjectAtOriginButtonPressed(String file) async {
    if (localObjectNode != null) {
      arObjectManager!.removeNode(localObjectNode!);
      localObjectNode = null;
    } else {
      var newNode = ARNode(
        type: NodeType.fileSystemAppFolderGLB,
        uri: file,
        scale: Vector3(0.5, 0.5, 0.5),
        position: Vector3(0, 0, 0)
      );
      bool? didAddLocalNode = await arObjectManager!.addNode(newNode);
      localObjectNode = (didAddLocalNode!) ? newNode : null;
    }
  }
}
