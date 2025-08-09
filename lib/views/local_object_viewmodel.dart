import 'package:ar_flutter_plugin_updated/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin_updated/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin_updated/models/ar_node.dart';
import 'package:ar_flutter_plugin_updated/datatypes/node_types.dart';
import 'package:vector_math/vector_math_64.dart';

class LocalObjectViewModel {
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  ARNode? localObjectNode;

  Future<void> initAR(ARSessionManager session, ARObjectManager object) async {
    arSessionManager = session;
    arObjectManager = object;

    arSessionManager!.onInitialize(
      showFeaturePoints: false,
      showPlanes: true,
      customPlaneTexturePath: "assets/triangle.png",
      showWorldOrigin: true,
      handleTaps: false,
    );

    arObjectManager!.onInitialize();
  }

  Future<void> placeObject(String fileName) async {
    if (localObjectNode != null) return; // já colocado

    final newNode = ARNode(
      type: NodeType.fileSystemAppFolderGLB,
      uri: fileName,
      scale: Vector3(0.5, 0.5, 0.5),
      position: Vector3(0, 0, 0),
    );
    final didAdd = await arObjectManager!.addNode(newNode);
    if (didAdd == true) {
      localObjectNode = newNode;
    }
  }
}
